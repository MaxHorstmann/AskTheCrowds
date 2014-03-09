library ApiController;

import 'dart:io';
import 'dart:async';
import 'package:http_server/http_server.dart';
import "BaseController.dart";
import "../models/Models.dart";
import "../models/Db.dart";
import "../models/Json.dart";
import "../common/Util.dart";

class ApiController extends BaseController
{
  
  Db _polls  = new Db<Poll>();
  Db _users  = new Db<User>();
  Db _flags = new Db<Flag>();
  
  
  bool Polls(HttpRequest request)
  {
    if (request.method == "POST")  
    {
      Poll poll = null;
      HttpBodyHandler.processRequest(request)
        .then((HttpBody body) {   
          poll = (new Json<Poll>()).FromJson(body.body);
          poll.Created = new DateTime.now();
          poll.Validate();
          return _users.SingleOrNew(poll.UserId, User.CreateNew); 
          })
       .then((User user) {
            poll.UserId = user.Id;   
            user.UpdateLastRequest(request);
            return _users.Save(user);
       })
       .then((_) => _polls.Save(poll))
       .then((_) => sendJson(request, new ApiResult(poll.Id, poll.UserId)))
       .catchError((e) => sendServerError(request, e));
      return true;                          
    }
    
    if (request.method == "GET")  
    { 
      if (!request.uri.queryParameters.containsKey("id"))
      {
        var numberOfPolls = request.uri.queryParameters.containsKey("take") ?
            int.parse(request.uri.queryParameters["take"]) : 20;
        
        var maxPollIdFuture = request.uri.queryParameters.containsKey("maxPollId") ?
            new Future<int>.value(int.parse(request.uri.queryParameters["maxPollId"])) : 
              _polls.GetSequenceValue();

        maxPollIdFuture.then((int maxPollId) {
          var polls = new List<Poll>();
          Future
            .forEach(Util.Range(maxPollId, maxPollId - numberOfPolls), 
              (int id) => _polls.Single(id.toString()).then((Poll poll) => poll != null ? polls.add(poll) : null))
            .then((_) => Future.forEach(polls, (Poll poll) => _polls.GetSetCounts(poll, "votes", poll.Options.length)
            .then((List<int> voteCounts) => poll.Votes = voteCounts)))
            .then((_) => sendJson(request, polls))
            .catchError((_) => sendJson(request, new ApiResult.Error()));
        });
        
      }
      else {
        var pollId = request.uri.queryParameters["id"];
        _polls.Single(pollId).then((Poll poll) {
          if (poll == null) { 
            this.sendPageNotFound(request); 
          }        
          else {
            _polls.GetSetCounts(poll, "votes", poll.Options.length).then((List<int> voteCounts) {
              poll.Votes = voteCounts;
              sendJson(request, poll);
            });
          }
        });
      }
      
      return true;
    }
    
    return false;           
  }
  
  
  bool Votes(HttpRequest request)
  {
    if (request.method == "POST")  
    {
      Vote vote = null;
      Poll poll = null;
      HttpBodyHandler.processRequest(request)
        .then((HttpBody body) {  
            vote = (new Json<Vote>()).FromJson(body.body);
            return _polls.Single(vote.PollId); 
          })
        .then((Poll pollFound) {
            poll = pollFound;
            if ((poll == null) || (!poll.IsValidVote(vote))) {
              sendPageNotFound(request);
              throw "Invalid vote or poll not found";
            } else {
              return _users.SingleOrNew(poll.UserId, User.CreateNew);
            }
          })
        .then((User user) {
            vote.UserId = user.Id;
            user.UpdateLastRequest(request);
            return _users.Save(user);
        })
        .then((_) {            
            if (vote.Option == Flag.FLAG_VOTE) {
              Flag flag = new Flag()
                ..Created = new DateTime.now()
                ..UserId = vote.UserId
                ..PollId = vote.PollId;
              return _flags.Save(flag);
            } else {
              return _polls.AddToSet(poll, "votes", vote.Option, vote.UserId);
            }
          })
        .then((_) => sendJson(request, new ApiResult("voted", vote.UserId)))
        .catchError((e) => print(e));
      return true;                          
    }
    
    return false;           
  }
  
  
}

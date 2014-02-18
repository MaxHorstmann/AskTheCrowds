library ApiController;

import 'dart:io';
import 'dart:async';
import 'package:http_server/http_server.dart';
import "BaseController.dart";
import "../models/Models.dart";
import "../models/Db.dart";
import "../models/Json.dart";


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
          return _users.SingleOrNew(poll.UserUuid, User.CreateNew); 
          })
       .then((User user) {          
            poll.UserUuid = user.Uuid;              
            return _polls.Save(poll); 
          })
       .then((_) => sendJson(request, new ApiResult(poll.Uuid, poll.UserUuid)));
      return true;                          
    }
    
    if (request.method == "GET")  
    { 
      if (!request.uri.queryParameters.containsKey("uuid"))
      {
        List<Poll> polls;
        _polls.Where((Poll p) => !p.IsClosed)
          .then((List<Poll> pollsFound) => polls = pollsFound )
          .then((_) => Future.forEach(polls, (Poll poll) => _polls.GetSetCounts(poll, "votes", poll.Options.length)
                                               .then((List<int> voteCounts) => poll.Votes = voteCounts)))
          .then((_) => sendJson(request, polls));
      }
      else {
        var pollUuid = request.uri.queryParameters["uuid"];
        _polls.Single(pollUuid).then((Poll poll) {
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
            return _polls.Single(vote.PollUuid); 
          })
        .then((Poll pollFound) {
            poll = pollFound;
            if ((poll == null) || (!poll.IsValidVote(vote))) {
              sendPageNotFound(request);
              throw "Invalid vote or poll not found";
            } else {
              return _users.SingleOrNew(poll.UserUuid, User.CreateNew);
            }
          })
        .then((User user) {
          if (user != null) {
              vote.UserUuid = user.Uuid;
              if (vote.Option == Flag.FLAG_VOTE) {
                Flag flag = new Flag()
                  ..Created = new DateTime.now()
                  ..UserUuid = vote.UserUuid
                  ..PollUuid = vote.PollUuid;
                return _flags.Save(flag);
              } else {
                return _polls.AddToSet(poll, "votes", vote.Option, vote.UserUuid);
              }
            }
          })
        .then((_) => sendJson(request, new ApiResult("voted", vote.UserUuid)))
        .catchError((e) => print(e));
      return true;                          
    }
    
    return false;           
  }
  
  
}

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
  
  bool Polls(HttpRequest request)
  {
    if (request.method == "POST")  
    {
      HttpBodyHandler.processRequest(request).then((HttpBody body) {   
        var poll = (new Json<Poll>()).FromJson(body.body);
        poll.Created = new DateTime.now();
        _users.SingleOrNew(poll.UserUuid, User.CreateNew).then((User user) {          
          poll.UserUuid = user.Uuid;              
          _polls.Save(poll).then((bool success) {
            sendJson(request, new ApiResult(poll.Uuid, poll.UserUuid));
          });              
        });
      });
      return true;                          
    }
    
    if (request.method == "GET")  
    { 
      if (!request.uri.queryParameters.containsKey("uuid"))
      {
        _polls.Where((Poll p) => !p.IsClosed).then((List<Poll> polls) {
          polls.forEach((Poll p) => p.CountVotes());
          sendJson(request, polls);
        });
      }
      else {
        var pollUuid = request.uri.queryParameters["uuid"];
        _polls.Single(pollUuid).then((Poll poll) {
          if (poll == null) { 
            this.sendPageNotFound(request); 
          }        
          else {
            poll.CountVotes();
            sendJson(request, poll);
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
      HttpBodyHandler.processRequest(request).then((HttpBody body) {  
        var vote = (new Json<Vote>()).FromJson(body.body);
        _polls.Single(vote.PollUuid).then((Poll poll) {
          if ((poll != null) && (vote.Option>=0) && (vote.Option<poll.Options.length)) {            
            _users.SingleOrNew(poll.UserUuid, User.CreateNew).then((User user) { 
              vote.UserUuid = user.Uuid;
              // TODO perf optimization: store votes in separate set
              if (poll.Votes == null) {
                poll.Votes = new List<List<String>>();
                for (var i=0; i<poll.Options.length; i++) {
                  poll.Votes.add(new List<String>());
                }
              }
              if (!poll.Votes[vote.Option].contains(vote.UserUuid)) {
                poll.Votes[vote.Option].add(vote.UserUuid);
              }
              poll.CountVotes();
              _polls.Save(poll);
              sendJson(request, new ApiResult("voted", vote.UserUuid));
            });
          } else {
            this.sendPageNotFound(request); 
          }
        });        

      });
      return true;                          
    }
    
    return false;           
  }
  
  
}

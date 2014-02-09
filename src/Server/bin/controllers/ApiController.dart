library ApiController;

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import "../models/Models.dart";
import "../services/Db.dart";
import "BaseController.dart";
import 'package:http_server/http_server.dart';


class ApiController extends BaseController
{
  
  Db _db  = new Db();
  
  bool Polls(HttpRequest request)
  {
    if (request.method == "POST")  
    {
      HttpBodyHandler.processRequest(request).then((HttpBody body) {        
        var poll = new Poll.fromJSON(body.body, true);
        
        var user = _db.GetUser(poll.UserGuid).then((User user) {
          
          if (user == null) {
            
            var newUser = new User.CreateNew();
            poll.UserGuid = newUser.UserGuid;
            _db.SaveUser(newUser).then((bool success) {
              
              _db.SavePoll(poll).then((bool success) {
                // TODO indicate failure
                sendJson(request, new ApiResult(poll.PollGuid, poll.UserGuid));
              });
              
            });
          } else {
            _db.SavePoll(poll).then((bool success) {
              // TODO indicate failure
              sendJson(request, new ApiResult(poll.PollGuid, poll.UserGuid));
            });
          }
          
        });
      });
      return true;                          
    }
    
    if (request.method == "GET")  
    { 
      if (!request.uri.queryParameters.containsKey("pollGuid"))
      {
        _db.GetPolls().then((List<Poll> polls) {
          //sendJson(request, polls.toString()); // TODO
        });
      }
      else {
        var pollGuid = request.uri.queryParameters["pollGuid"];
        _db.GetPoll(pollGuid).then((Poll poll) {
          if (poll == null) { 
            this.sendPageNotFound(request); 
          }        
          else {
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
        var vote = new Vote.fromJSON(body.body);
        
        if (vote.UserGuid!=null)
        {
          var userKey = "userGuid:" + vote.UserGuid.toString();
//          redisClient.exists(userKey).then((bool exists){
//            if (!exists)
//            {
//              vote.UserGuid = null;
//            }
//          });        
        }
        
        if (vote.UserGuid==null)
        {
          var newUser = new User.CreateNew();
          var json = JSON.encode(newUser);
          var key = "userGuid:" + newUser.UserGuid;
          //redisClient.set(key, json); // TODO handle success 
          vote.UserGuid = newUser.UserGuid;
        }
                
        var pollKey = "pollGuid:" + vote.PollGuid.toString() + ":poll";
        
//        redisClient.exists(pollKey).then((bool exists){
//          if (!exists)
//          {
//            sendJson(request,new ApiResult("PollGuid not found", vote.UserGuid),400);
//          }
//          else
//          {
//            var voteKey = pollKey + ":votes:" + vote.Option.toString();                    
//            redisClient.sadd(voteKey, vote.UserGuid.toString())
//              .then((_) => sendJson(request,new ApiResult("Voted", vote.UserGuid)));                
//          }
//        });
        
      });
      return true;                          
    }
    
    return false;           
  }
  
  
}

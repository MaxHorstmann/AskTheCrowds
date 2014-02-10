library ApiController;

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http_server/http_server.dart';
import "BaseController.dart";
import "../models/Models.dart";
import "../services/Db.dart";


class ApiController extends BaseController
{
  
  Db _polls  = new Db<Poll>();
  Db _users  = new Db<User>();
  
  bool Polls(HttpRequest request)
  {
    if (request.method == "POST")  
    {
      HttpBodyHandler.processRequest(request).then((HttpBody body) {        
        var poll = new Poll.fromJSON(body.body);
        poll.Created = new DateTime.now();        
        var user = _users.Single(poll.UserUuid).then((User user) {          
          if (user == null) {            
            var newUser = new User.CreateNew();
            _users.Save(newUser).then((bool success) {
              poll.UserUuid = newUser.Uuid;              
              _polls.Save(poll).then((bool success) {
                sendJson(request, new ApiResult(poll.Uuid, poll.UserUuid));
              });              
            });
          } else {
            _users.Save(poll).then((bool success) {
              sendJson(request, new ApiResult(poll.Uuid, poll.UserUuid));
            });
          }          
        });
      });
      return true;                          
    }
    
    if (request.method == "GET")  
    { 
      if (!request.uri.queryParameters.containsKey("pollUuid"))
      {
        _polls.All().then((List<Poll> polls) {
          sendJson(request, polls);
        });
      }
      else {
        var pollUuid = request.uri.queryParameters["pollUuid"];
        _polls.Single(pollUuid).then((Poll poll) {
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
          //var key = "userGuid:" + newUser.UserGuid;
          //redisClient.set(key, json); // TODO handle success 
          //vote.UserGuid = newUser.UserGuid;
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

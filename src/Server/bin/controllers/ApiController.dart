library ApiController;

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import "../models/models.dart";
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

        if (poll.UserGuid!=null)
        {
          _db.GetUser(poll.UserGuid).then((User user) {
            if (user == null) {
              poll.UserGuid = null;
            }
          });
        }
        
        if (poll.UserGuid==null)
        {
          var newUser = new User.CreateNew();
          var json = JSON.encode(newUser);
          var key = "userGuid:" + newUser.UserGuid;
          //redisClient.set(key, json); // TODO handle success 
          poll.UserGuid = newUser.UserGuid;
        }
        
        var key = "pollGuid:" + poll.PollGuid + ":poll";
        var json = JSON.encode(poll);
        //redisClient.set(key, json).then((_) => sendJson(request,new ApiResult(poll.PollGuid, poll.UserGuid)));
        
      });
      return true;                          
    }
    
    if (request.method == "GET")  
    { 
      if (!request.uri.queryParameters.containsKey("pollGuid"))
      {
        // TODO use a list of current polls instead of "keys"
        redisClient.keys("pollGuid:*:poll").then((List<String> pollGuids){
          var polls = new List<Poll>();
          var futures = new List<Future<Poll>>();
          pollGuids.forEach((String pollGuid) {
            var pollFuture = _db.GetPoll(pollGuid);
            pollFuture.then((Poll p) { 
              if (!p.IsClosed) {
                polls.add(p);
              }
              });
            futures.add(pollFuture);
          });
          Future.wait(futures).then((_) => sendJson(request, polls));
        });
        return true;
      }
      var pollGuid = request.uri.queryParameters["pollGuid"];
      var key = "pollGuid:" + pollGuid.toString() + ":poll";
      redisClient.exists(key).then((bool exists) {
        if (!exists) { 
          this.sendPageNotFound(request); 
        }        
        else {
          _db.GetPoll(key).then((Poll poll) => sendJson(request, poll));
        }
      });
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
          redisClient.exists(userKey).then((bool exists){
            if (!exists)
            {
              vote.UserGuid = null;
            }
          });        
        }
        
        if (vote.UserGuid==null)
        {
          var newUser = new User.CreateNew();
          var json = JSON.encode(newUser);
          var key = "userGuid:" + newUser.UserGuid;
          redisClient.set(key, json); // TODO handle success 
          vote.UserGuid = newUser.UserGuid;
        }
                
        var pollKey = "pollGuid:" + vote.PollGuid.toString() + ":poll";
        
        redisClient.exists(pollKey).then((bool exists){
          if (!exists)
          {
            sendJson(request,new ApiResult("PollGuid not found", vote.UserGuid),400);
          }
          else
          {
            var voteKey = pollKey + ":votes:" + vote.Option.toString();                    
            redisClient.sadd(voteKey, vote.UserGuid.toString())
              .then((_) => sendJson(request,new ApiResult("Voted", vote.UserGuid)));                
          }
        });
        
      });
      return true;                          
    }
    
    return false;           
  }
  
  
}

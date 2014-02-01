library ApiController;

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import "../models/models.dart";
import "BaseController.dart";
import "package:redis_client/redis_client.dart";
import 'package:http_server/http_server.dart';


class ApiController extends BaseController
{
  
  String connectionStringRedis;  
  RedisClient redisClient = null;
  
  ApiController(this.connectionStringRedis)
  {
    RedisClient.connect(connectionStringRedis)
      .then((RedisClient redisClientNew) { redisClient = redisClientNew; });    
  }
  
  bool Users(HttpRequest request)
  {
      if (request.method == "GET") // TODO admin-only - this route will go away later
      {
        redisClient.keys("userGuid:*").then((List<String> userGuids){
          sendContent(request, userGuids.join('\n'));
        });
        return true;
      }

      return false;      
  }

  bool Polls(HttpRequest request)
  {
    if (request.method == "POST")  
    {
      HttpBodyHandler.processRequest(request).then((HttpBody body) {        
        var poll = new Poll.fromJSON(body.body, true);

        if (poll.UserGuid!=null)
        {
          var userKey = "userGuid:" + poll.UserGuid.toString();
          redisClient.exists(userKey).then((bool exists){
            if (!exists)
            {
              poll.UserGuid = null;
            }
          });        
        }
        
        if (poll.UserGuid==null)
        {
          var newUser = new User.CreateNew();
          var json = JSON.encode(newUser);
          var key = "userGuid:" + newUser.UserGuid;
          redisClient.set(key, json); // TODO handle success 
          poll.UserGuid = newUser.UserGuid;
        }
        
        var key = "pollGuid:" + poll.PollGuid + ":poll";
        var json = JSON.encode(poll);
        redisClient.set(key, json).then((_) => sendJson(request,new ApiResult(poll.PollGuid, poll.UserGuid)));
        
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
            var pollFuture = GetPoll(pollGuid);
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
          GetPoll(key).then((Poll poll) => sendJson(request, poll));
        }
      });
      return true;
    }
    
    return false;           
  }
  
  Future<Poll> GetPoll(String key)
  {
    return redisClient.get(key).then((String value) {
      var poll = new Poll.fromJSON(value);
      poll.Votes=new List<int>.filled(poll.Options.length, 0);
      var futures = new List<Future<int>>();
      for (var i=0;i<poll.Options.length; i++) {
        var voteKey = key + ":votes:" + i.toString();
        var votesFuture = redisClient.scard(voteKey);
        futures.add(votesFuture);
        votesFuture.then((int card) {
          poll.Votes[i]=card; 
        });
      }
      return Future.wait(futures).then((_) => poll);      
    });
  }
  
  bool Votes(HttpRequest request)
  {
    if (request.method == "POST")  
    {
      HttpBodyHandler.processRequest(request).then((HttpBody body) {        
        var vote = new Vote.fromJSON(body.body);
        var userKey = "userGuid:" + vote.UserGuid.toString();
        redisClient.exists(userKey).then((bool exists){
          if (!exists)
          {
            sendJson(request,new ApiResult("UserGuid not found"),400);
          }
          else
          {
            var pollKey = "pollGuid:" + vote.PollGuid.toString() + ":poll";
            redisClient.exists(pollKey).then((bool exists){
              if (!exists)
              {
                sendJson(request,new ApiResult("PollGuid not found"),400);
              }
              else
              {
                var voteKey = pollKey + ":votes:" + vote.Option.toString();                    
                redisClient.sadd(voteKey, vote.UserGuid.toString())
                  .then((_) => sendJson(request,new ApiResult("Voted")));                
              }
            });
          }
        });      
      });
      return true;                          
    }
    
    return false;           
  }
  
  
}

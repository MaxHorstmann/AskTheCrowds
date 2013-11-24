library ApiController;

import 'dart:io';
import 'dart:convert';
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
      if (request.method == "GET") // TODO admin-only
      {
        redisClient.keys("userGuid:*").then((List<String> userGuids){
          sendContent(request, userGuids.join('\n'));
        });
        return true;
      }

      if (request.method == "POST")
      {
        var newUser = new User.CreateNew();
        var json = JSON.encode(newUser);
        var key = "userGuid:" + newUser.UserGuid;
        redisClient.set(key, json).then((_)
            {
              sendJsonRaw(request, json);
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
        var poll = new Poll.fromJSON(body.body);
        var userKey = "userGuid:" + poll.UserGuid.toString();
        redisClient.exists(userKey).then((bool exists){
          if (!exists)
          {
            var result = new Result()
            ..ResultPayload = "User not found";
            sendJson(request,result,400);
          }
          else
          {
            var key = "pollGuid:" + poll.PollGuid;
            var json = JSON.encode(poll);
            redisClient.set(key, json).then((_){
              var result = new Result()
              ..ResultPayload = poll.PollGuid;
              sendJson(request,result);
            });
          }
        });        
      });
      return true;                          
    }
    
    if (request.method == "GET")  
    { 
      var newPoll = new Poll()
      ..CategoryId = 5
      ..Language = "en"
      ..Created = new DateTime.now()
      ..DurationHours = 5
      ..Question = "Where should I go on my next vacation?"
      ..Options = [ "Hawaii", "New York" ];
      sendJson(request, [newPoll, newPoll]);                        
      return true;
    }
    
    return false;           
  }
  
  
}

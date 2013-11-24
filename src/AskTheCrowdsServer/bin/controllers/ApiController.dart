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
        redisClient.set(key, json).then((_) => sendJsonRaw(request, json));
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
            sendJson(request,new Result("UserGuid not found"),400);
          }
          else
          {
            var key = "pollGuid:" + poll.PollGuid;
            var json = JSON.encode(poll);
            redisClient.set(key, json).then((_) => sendJson(request,new Result(poll.PollGuid)));
          }
        });        
      });
      return true;                          
    }
    
    if (request.method == "GET")  
    { 
      if (!request.uri.queryParameters.containsKey("pollGuid"))
      {
        return false;        
      }
      var pollGuid = request.uri.queryParameters["pollGuid"];
      var key = "pollGuid:" + pollGuid.toString();
      redisClient.exists(key).then((bool exists) {
        if (!exists) { 
          this.sendPageNotFound(request); 
        }        
        else {
          redisClient.get(key).then((String value) {
            var poll = new Poll.fromJSON(value);
            sendJson(request, poll);                        
          });
        }
      });
      return true;
    }
    
    return false;           
  }
  
  
}

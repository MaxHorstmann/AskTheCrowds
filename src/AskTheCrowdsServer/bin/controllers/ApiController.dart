library ApiController;

import 'dart:io';
import 'dart:convert';
import "../models/models.dart";
import "BaseController.dart";
import "package:redis_client/redis_client.dart";
import 'package:http_server/http_server.dart';


class ApiController extends BaseController
{
  ApiController(String _redisConnectionString) : super(_redisConnectionString);


  void Users(HttpRequest request)
  {
      if (request.method != "POST")  { sendPageNotFound(request); return;  }
      var newUser = services.CreateNewUser();
      var json = JSON.encode(newUser);
      RedisClient.connect(connectionStringRedis)
        .then((RedisClient client) {
          var key = "userGuid:" + newUser.UserGuid;
          client.set(key, json);              
        });            
      sendJsonRaw(request, json);
  }

  void Polls(HttpRequest request)
  {
    if (request.method == "POST")  
    {
      
      //HttpBodyHandler.processRequest(request).then((HttpBody body) {
      //  // http://blog.sethladd.com/2013/09/forms-http-servers-and-polymer-with-dart.html

      request.fold(new BytesBuilder(), (builder, data) => builder..add(data))
        .then((builder) {
          
          var data = builder.takeBytes();
          var json = UTF8.decode(data);
          Map pollMap = JSON.decode(json);
          
          var poll = new Poll()
          ..PollGuid = services.NewGuid()
          ..Created = new DateTime.now()
          ..DurationHours = pollMap["DurationHours"]
          ..Question = pollMap["Question"]
          ..Options = pollMap["Options"]
          ..UserGuid = pollMap["UserGuid"];
          
          RedisClient.connect(connectionStringRedis)
            .then((RedisClient client) {
              
              var userKey = "userGuid:" + poll.UserGuid.toString();
              client.exists(userKey)
                .then((bool exists){
                  if (!exists)
                  {
                    var result = new Result()
                    ..ResultPayload = "User not found";
                    sendJson(request,result,400);
                    return;
                  }
                  var key = "pollGuid:" + poll.PollGuid;
                  var json = JSON.encode(poll);
                  client.set(key, json).then((_){
                    var result = new Result()
                    ..ResultPayload = poll.PollGuid;
                    sendJson(request,result);
                  });
                  return;                          
                });
              
            })
              .catchError((error) {
                var result = new Result()
                ..ResultPayload = "could not connect to Redis";
                sendJson(request, result, 500);
                return;                      
              });
          
        });        
      return;
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
      return;
    }
    
    sendPageNotFound(request); 
    return;              
  }
  
  
}

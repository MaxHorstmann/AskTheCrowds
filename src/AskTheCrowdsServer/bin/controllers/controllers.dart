library controllers;

import 'dart:io';
import 'dart:convert';
import "../models/models.dart";
import "../services/services.dart";
import "package:redis_client/redis_client.dart";

class Controllers
{
  String _connectionStringRedis;
  Services _services = new Services();
  
  Controllers(this._connectionStringRedis);

  void sendContent(HttpRequest request, String content, [ int statusCode = 200 ])
  {
    request.response.statusCode = statusCode;
    request.response.write(content);
    request.response.close();
  }
  
  void sendJson(HttpRequest request, Object payload, [ int statusCode = 200 ])
  {
    var json = JSON.encode(payload);
    sendJsonRaw(request,json,statusCode);
  }  
  
  void sendJsonRaw(HttpRequest request, String json, [ int statusCode = 200 ])
  {
    request.response.statusCode = statusCode;
    request.response.headers.contentType = ContentType.parse("text/json");
    request.response.write(json);        
    request.response.close();
  }  
  
  
  void sendPageNotFound(HttpRequest request)
  {
    sendContent(request, "404 not found", 404);
  }
  
  void listen(HttpServer server)
  {
      server.listen((HttpRequest request) {
        var now = new DateTime.now();
        var path = request.uri.path;
        print("$now: $path");
        
        
        switch (path){
          case "/": sendContent(request, "Ask the Crowds server"); return;
          
          case "/api/polls": 
            var newPoll = new Poll()
            ..Id = 1
            ..CategoryId = 5
            ..Language = "en"
            ..Created = new DateTime.now().millisecondsSinceEpoch
            ..DurationHours = 5
            ..Question = "Where should I go on my next vacation?"
            ..Options = [ "Hawaii", "New York" ];
            sendJson(request, [newPoll, newPoll]);                        
            return;
            
          case "/api/users":            
            if (request.method != "POST")  { sendPageNotFound(request); return;  }
            var newUser = _services.CreateNewUser();
            var json = JSON.encode(newUser);
            RedisClient.connect(_connectionStringRedis)
              .then((RedisClient client) {
                var key = "userGuid:" + newUser.UserGuid;
                client.set(key, json);              
              });            
            sendJsonRaw(request, json);
            return;

   
          case "/some/POST":   // TODO
            request.fold(new BytesBuilder(), (builder, data) => builder..add(data))
              .then((builder) {
                
                // TODO deserialize to object
                var data = builder.takeBytes();
                var json = UTF8.decode(data);
                Map user = JSON.decode(json);
                var userGuid = user["userGuid"];
                
                RedisClient.connect(_connectionStringRedis)
                  .then((RedisClient client) {
                    
                    client.sismember("users", userGuid).then((bool alreadyExists) {
                      var result = new Result()
                        ..Success = !alreadyExists;
                      if (!alreadyExists) 
                      {
                        client.sadd("users", userGuid);
                      }
                      sendJson(request, result);                      
                    });
                  });        
              });         
              return;
              
          default: sendPageNotFound(request); return;
        }
        
        

    });
  }
}
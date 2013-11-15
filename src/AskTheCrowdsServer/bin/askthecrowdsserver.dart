import "package:redis_client/redis_client.dart";
import 'dart:io';
import 'dart:convert';


void main() {
  var connectionStringRedis = "127.0.0.1:6379/0";
  
  RedisClient.connect(connectionStringRedis)
          .then((RedisClient client) {
            var categories = "{ categories : ['sports', 'travel', 'politics'] }";
            client.set("categories", categories).then((_) => print("categories set"));
          });

  HttpServer.bind(InternetAddress.ANY_IP_V4, 80).then((server) {
    server.listen((HttpRequest request) {

      print(request.uri.path);
      
      if (request.uri.path == "/") {
        request.response.statusCode = 200;
        request.response.write("Ask the Crowds server.");
        request.response.close();
        return;
      }
      
      if ((request.uri.path == "/register") && (request.method == "POST")) {
        request.fold(new BytesBuilder(), (builder, data) => builder..add(data))
         .then((builder) {
           
           var data = builder.takeBytes();
           var json = UTF8.decode(data);
           Map user = JSON.decode(json);
           var userGuid = user["userGuid"];
                      
           RedisClient.connect(connectionStringRedis)
             .then((RedisClient client) {
               client.sismember("users", userGuid).then((bool alreadyExists) {
                 if (alreadyExists)  {
                   request.response.statusCode = 400;
                   request.response.headers.contentType = ContentType.parse("text/json"); 
                   request.response.write("{ result = 'already exists' }");
                   request.response.close();
                 }
                 else {
                   client.sadd("users", userGuid).then((_) {
                     request.response.statusCode = 201;
                     request.response.headers.contentType = ContentType.parse("text/json"); 
                     request.response.write("{ result = 'success' }");
                     request.response.close();
                   });            
                 }
               });
             });        
         });
        
        return;
      }
      
      if (request.uri.path == "/users") {
        RedisClient.connect(connectionStringRedis)
          .then((RedisClient client) {
            client.smembers("users").then((users) {
              request.response.statusCode = 200;
              request.response.write(users);
              request.response.close();
            });
          });
        return;
      }
      
      if (request.uri.path == "/categories") {
        RedisClient.connect(connectionStringRedis)
          .then((RedisClient client) {
            client.get("categories").then((categories) {
              request.response.headers.contentType = ContentType.parse("text/json"); 
              request.response.write(categories);
              request.response.close();
            });
          });        
        return;
      }
      
      if (request.uri.path == "/throw") {
        throw "this is a test exception";
      }
      
      request.response.statusCode = 404;
      request.response.write("404 not found");
      request.response.close();      
      

    });
  }); 
  
  print("listing...."); 
  
}


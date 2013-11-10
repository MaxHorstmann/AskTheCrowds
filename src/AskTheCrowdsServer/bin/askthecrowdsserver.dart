import "package:redis_client/redis_client.dart";
import 'dart:io';

void main() {
  var connectionStringRedis = "127.0.0.1:6379/0";

  HttpServer.bind(InternetAddress.ANY_IP_V4, 80).then((server) {
    server.listen((HttpRequest request) {
      
      request.response.write('Hello, world. Ask the Crowds server here.');
      request.response.close();
      var now = new DateTime.now();
      print(now);
      RedisClient.connect(connectionStringRedis)
        .then((RedisClient client) {
          client.set("last", now.toString())
            .then((_) => client.get("last"))
              .then((value) => print("redis success: $value"));
        });      


      
    });
  }); 
  
  print("listing...."); 
  
}
import "package:redis_client/redis_client.dart";
import 'dart:io';

void main() {
  var connectionStringRedis = "127.0.0.1:6379/37";

  HttpServer.bind(InternetAddress.ANY_IP_V4, 8977).then((server) {
    server.listen((HttpRequest request) {
      request.response.write('Hello, world. Ask the Crowds server here.');
      request.response.close();
      print(new DateTime.now());
      RedisClient.connect(connectionStringRedis)
        .then((RedisClient client) {

          client.set("test", "value")
            .then((_) => client.get("test"))
              .then((value) => print("redis success: $value"));
        });      
      
    });
  }); 
  
  print("listing...."); 
  
}
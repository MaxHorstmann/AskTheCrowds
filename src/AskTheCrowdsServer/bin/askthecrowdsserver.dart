import "package:redis_client/redis_client.dart";
import 'dart:io';

void main() {
  var connectionStringRedis = "127.0.0.1:6397/0";

  RedisClient.connect(connectionStringRedis)
    .then((RedisClient client) {

      client.set("test", "value")
        .then((_) => client.get("test"))
          .then((value) => print("redis success: $value"));
    });      

  
  HttpServer.bind(InternetAddress.ANY_IP_V4, 80).then((server) {
    server.listen((HttpRequest request) {
      
      request.response.write('Hello, world. Ask the Crowds server here.');
      request.response.close();
      print(new DateTime.now());
      
    });
  }); 
  
  print("listing...."); 
  
}
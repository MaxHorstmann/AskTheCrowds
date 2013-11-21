import 'dart:io';
import "controllers/controllers.dart";

void main() {
  String connectionStringRedis = "127.0.0.1:6379/0";
  var controllers = new Controllers(connectionStringRedis);
  HttpServer.bind(InternetAddress.ANY_IP_V4, 800).then(controllers.listen); 
  var now = new DateTime.now();
  print("$now: listing....");
}


import 'dart:io';

void main() {
  HttpServer.bind(InternetAddress.ANY_IP_V4, 80).then((server) {
    server.listen((HttpRequest request) {
      request.response.write('Hello, world. Ask the Crowds server here.');
      request.response.close();
    });
  });
  
  print("listing....");
  
}
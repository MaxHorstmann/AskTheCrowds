import 'dart:io';

void main() {
  HttpServer.bind('127.0.0.1', 80).then((server) {
    server.listen((HttpRequest request) {
      request.response.write('Hello, world. Ask the Crowds server here.');
      request.response.close();
    });
  });
  
  print("listing on 127.0.0.1....");
  
}
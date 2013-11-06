import 'dart:io';

void main() {
  HttpServer.bind('127.0.0.1', 80).then((server) {
    server.listen((HttpRequest request) {
      request.response.write('Hello, world');
      request.response.close();
    });
  });
}
import 'dart:io';
import "controllers/HomeController.dart";
import "controllers/ApiController.dart";

typedef bool Handler(HttpRequest request);

void main() {
  
  String connectionStringRedis = "127.0.0.1:6379/0";
  
  HttpServer.bind(InternetAddress.ANY_IP_V4, 80).then((HttpServer server) {
    
    var routeTable = new Map<String, Handler>();    
    var homeController = new HomeController();
    var apiController = new ApiController(connectionStringRedis);
    
    routeTable["/"] = homeController.Index;
    routeTable["/api/users"] = apiController.Users;
    routeTable["/api/polls"] = apiController.Polls;
    
    server.listen((HttpRequest request) {
      
      var now = new DateTime.now();
      var path = request.uri.path;
      print("$now: $path");
      
      var routeFound = false;
      routeTable.keys.forEach((String pattern) 
      { 
        if ((!routeFound) && (path == pattern)) // TODO check patterns with placeholders 
        {
          routeFound = routeTable[pattern](request);
        }
      });
      
      if (!routeFound) {
        request.response.statusCode = 404;
        request.response.write("404 not found");
        request.response.close();
      }
    });
    
  var now = new DateTime.now();
  print("$now: listing....");
  });
  
  
}


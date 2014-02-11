import 'dart:io';
import "controllers/HomeController.dart";
import "controllers/ApiController.dart";
import "controllers/AdminController.dart";

typedef bool Handler(HttpRequest request);

void main() {
  
  
  HttpServer.bind(InternetAddress.ANY_IP_V4, 8888).then((HttpServer server) {
    
    var routeTable = new Map<String, Handler>();    
    var homeController = new HomeController();
    var apiController = new ApiController();
    var adminController = new AdminController();
    
    routeTable["/"] = homeController.Index;
    routeTable["/pingdom"] = homeController.Pingdom;
    routeTable["/admin"] = adminController.Index;
    routeTable["/addTestData"] = adminController.AddTestData;
    routeTable["/api/polls"] = apiController.Polls;
    routeTable["/api/votes"] = apiController.Votes;
    
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


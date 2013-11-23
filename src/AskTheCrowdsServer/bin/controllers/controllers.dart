library controllers;

import 'dart:io';
import "HomeController.dart";
import "ApiController.dart";

class Controllers 
{
  String _connectionStringRedis;
  
  Controllers(this._connectionStringRedis);
  
  void listen(HttpServer server)
  {
      
      var routeTable = new Map<String, Object>();
      
      var homeController = new HomeController(_connectionStringRedis);
      var apiController = new ApiController(_connectionStringRedis);
      
      routeTable["/"] = (HttpRequest request) => homeController.Index(request);
      routeTable["/api/users"] = (HttpRequest request) => apiController.Users(request);
      routeTable["/api/polls"] = (HttpRequest request) => apiController.Polls(request);
      
      server.listen((HttpRequest request) {
        
        var now = new DateTime.now();
        var path = request.uri.path;
        print("$now: $path");
        
        var routeFound = false;
        routeTable.keys.forEach((String pattern) 
        { 
          if ((!routeFound) && (path.startsWith(pattern))) 
          {
            routeTable[pattern](request);
            routeFound = true;
          }
        });
        
        if (!routeFound) {
          // sendPageNotFound(request);
        }
        

    });
  }
}
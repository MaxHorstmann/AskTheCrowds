import 'dart:io';
import "controllers/HomeController.dart";
import "controllers/ApiController.dart";
import "controllers/AdminController.dart";
import "controllers/ImagesController.dart";

typedef bool Handler(HttpRequest request);

void main() {
  
  
  HttpServer.bind(InternetAddress.ANY_IP_V4, 8977)
    .then((HttpServer server) {
    
    var routeTable = new Map<String, Handler>();    
    var homeController = new HomeController();
    var apiController = new ApiController();
    var adminController = new AdminController();
    var imagesController = new ImagesController();
    
    routeTable["/"] = homeController.Index;
    routeTable["/pingdom"] = homeController.Pingdom;
    routeTable["/admin"] = adminController.Index;
    routeTable["/admin/throw"] = adminController.Throw;
    routeTable["/addTestData"] = adminController.AddTestData;
    routeTable["/api/polls"] = apiController.Polls;
    routeTable["/api/votes"] = apiController.Votes;
    routeTable["/api/img"] = imagesController.Index;
        
    server.listen((HttpRequest request) {
      
      try
      {
        var now = new DateTime.now();
        var path = request.uri.path;
        var ip = request.connectionInfo.remoteAddress.host;
        print("$now|$ip|$path");
        
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
      }
      catch (ex)
      {
        print (ex);
      }
      
    });
    
  var now = new DateTime.now();
  print("$now: listing....");
  });
  
  
  
}


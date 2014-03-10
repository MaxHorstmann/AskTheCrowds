library AdminController;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import "BaseController.dart";
import "../models/Models.dart";
import "../models/Db.dart";

class AdminController extends BaseController
{
  
  Db _users = new Db<User>();
  Db _polls = new Db<Poll>();
  
  bool Index(HttpRequest request)
  {
    request.response.statusCode = 200;
    
    Future<List<User>> users = _users.All();
    Future<List<Poll>> polls = _polls.All();

    users.then((List<User> users) {
      request.response.write("users\n------\n");
      users.forEach((User u) => request.response.write(u.Id + "\n"));          
      
      polls.then((List<Poll> polls) {
        request.response.write("\n\n\npolls\n------\n");
        polls.forEach((Poll p) => request.response.write(JSON.encode(p) +"\n"));         
        request.response.close();
      });
      
    });
    
    return true;  
  }
  
 
  bool AddTestData(HttpRequest request)
  {
    var user = User.CreateNew();
    _users.Save(user).then((_) {
      
      var poll = new Poll()
        ..Created = new DateTime.now()
        ..DurationHours = 5
        ..UserId = user.Id
        ..CategoryId = 1
        ..LanguageCode = "en"
        ..Question = "Which Island is better?"
        ..Options = ["Maui", "Mallorca", "Sylt", "Manhattan"];
      
      _polls.Save(poll).then((_){
        request.response.statusCode = 200;
        request.response.writeln("ok");
        request.response.close();
      });
      
    });
    
    
    return true;
  }
  
  bool Throw(HttpRequest request) {
    throw new Exception("This is a test!");
  }
  
  

  
}

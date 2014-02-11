library AdminController;

import 'dart:io';
import 'dart:async';
import "BaseController.dart";
import "../models/Models.dart";
import "../services/Db.dart";

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
      users.forEach((User u) => request.response.write(u.Uuid + "\n"));          
      
      polls.then((List<Poll> polls) {
        request.response.write("\n\n\npolls\n------\n");
        polls.forEach((Poll p) => request.response.write(p.Uuid + "   " + p.Question + "\n"));          
        request.response.close();
      });
      
    });
    
    return true;  
  }
  
  bool AddTestData(HttpRequest request)
  {
    var user = new User.CreateNew();
    _users.Save(user).then((bool success) {
      
      var poll = new Poll()
        ..Created = new DateTime.now()
        ..DurationHours = 1
        ..UserUuid = user.Uuid
        ..Question = "Which movie is better?"
        ..Options = ["Titanic", "Star Wars"];
      
      _polls.Save(poll).then((bool success){
        request.response.statusCode = 200;
        request.response.writeln("ok");
        request.response.close();
      });
      
    });
    
    
    return true;
  }
  
  

  
}

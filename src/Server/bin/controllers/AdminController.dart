library AdminController;

import 'dart:io';
import 'dart:async';
import "BaseController.dart";
import "../models/Models.dart";
import "../services/Db.dart";

class AdminController extends BaseController
{
  
  Db _users = new Db<User>("user");
  Db _polls = new Db<Poll>("poll");
  
  bool Index(HttpRequest request)
  {
    request.response.statusCode = 200;
    
    Future<List<User>> users = _users.All();
    Future<List<Poll>> polls = _polls.All();

    users.then((List<User> users) {
      request.response.write("users\n------\n");
      users.forEach((User u) => request.response.write(u.UserGuid + "\n"));          
      
      polls.then((List<Poll> polls) {
        request.response.write("\n\n\npolls\n------\n");
        polls.forEach((Poll p) => request.response.write(p.PollGuid + "   " + p.Question + "\n"));          
        request.response.close();
      });
      
    });
    
    return true;  
  }

  
}

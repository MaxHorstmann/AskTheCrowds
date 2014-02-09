library AdminController;

import 'dart:io';
import 'dart:async';
import "BaseController.dart";
import "../models/Models.dart";
import "../services/Db.dart";

class AdminController extends BaseController
{
  
  Db _db = new Db();
  
  bool Index(HttpRequest request)
  {
    request.response.statusCode = 200;
    
    Future<List<User>> users = _db.GetUsers();
    Future<List<Poll>> polls = _db.GetPolls();

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

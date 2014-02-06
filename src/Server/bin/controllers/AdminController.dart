library AdminController;

import 'dart:io';
import 'dart:async';
import "BaseController.dart";
import "../models/models.dart";
import "../services/Db.dart";


class AdminController extends BaseController
{
  
  Db _db;
  
  AdminController(String connectionStringRedis)
  {
    _db = new Db(connectionStringRedis);
  }
  
  bool Index(HttpRequest request)
  {
    request.response.statusCode = 200;
    
    Future<List<String>> userGuids = _db.GetUserGuids();
    Future<List<Poll>> polls = _db.GetPolls();

    userGuids.then((List<String> userGuids) {
      request.response.write("users\n------\n");
      request.response.write(userGuids.join('\n'));
      
      polls.then((List<Poll> polls) {
        request.response.write("\n\n\npolls\n------\n");
        polls.forEach((Poll p) => request.response.write(p.PollGuid));          
        request.response.close();
      });
      
    });
    
    return true;  
  }

  
}

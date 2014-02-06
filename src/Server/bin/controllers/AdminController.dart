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
    Future<List<String>> pollGuids = _db.GetPollGuids();

    userGuids.then((List<String> userGuids) {
      request.response.write("users\n------\n");
      request.response.write(userGuids.join('\n'));
      
      pollGuids.then((List<String> pollGuids) {
        request.response.write("\npolls\n------\n");
        request.response.write(pollGuids.join('\n'));

        var polls = new List<Poll>();
        var futures = new List<Future<Poll>>();
        pollGuids.forEach((String pollGuid) {
          var pollFuture = _db.GetPoll(pollGuid);
          pollFuture.then((Poll p) => polls.add(p));
          futures.add(pollFuture);
        });
        Future.wait(futures).then((_) {
          polls.forEach((Poll p) => request.response.write(p.PollGuid));          
        });
        
        request.response.close();
      });
      
    });
    
    return true;  
  }

  
}

library ApiController;

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http_server/http_server.dart';
import "BaseController.dart";
import "../models/Models.dart";
import "../models/Db.dart";
import "../models/Json.dart";


class ApiController extends BaseController
{
  
  Db _polls  = new Db<Poll>();
  Db _users  = new Db<User>();
  
  bool Polls(HttpRequest request)
  {
    if (request.method == "POST")  
    {
      HttpBodyHandler.processRequest(request).then((HttpBody body) {   
        var poll = (new Json<Poll>()).FromJson(body.body);
        poll.Created = new DateTime.now();        
        var user = _users.Single(poll.UserUuid).then((User user) {          
          if (user == null) {            
            var newUser = new User.CreateNew();
            _users.Save(newUser).then((bool success) {
              poll.UserUuid = newUser.Uuid;              
              _polls.Save(poll).then((bool success) {
                sendJson(request, new ApiResult(poll.Uuid, poll.UserUuid));
              });              
            });
          } else {
            _polls.Save(poll).then((bool success) {
              sendJson(request, new ApiResult(poll.Uuid, poll.UserUuid));
            });
          }          
        });
      });
      return true;                          
    }
    
    if (request.method == "GET")  
    { 
      if (!request.uri.queryParameters.containsKey("uuid"))
      {
        _polls.Where((Poll p) => !p.IsClosed).then((List<Poll> polls) {
          sendJson(request, polls);
        });
      }
      else {
        var pollUuid = request.uri.queryParameters["uuid"];
        _polls.Single(pollUuid).then((Poll poll) {
          if (poll == null) { 
            this.sendPageNotFound(request); 
          }        
          else {
            sendJson(request, poll);
          }
        });
      }
      
      return true;
    }
    
    return false;           
  }
  
  
  bool Votes(HttpRequest request)
  {
    if (request.method == "POST")  
    {
      HttpBodyHandler.processRequest(request).then((HttpBody body) {  
        var vote = (new Json<Vote>()).FromJson(body.body);
        _polls.Single(vote.PollUuid).then((Poll poll) {
          if ((poll != null) && (vote.Option>=0) && (vote.Option<poll.Options.length)) {
            // TODO store votes in separate set
            poll.Votes[vote.Option].add(vote.UserUuid);
            _polls.Save(poll);
          }          
        });        

      });
      return true;                          
    }
    
    return false;           
  }
  
  
}

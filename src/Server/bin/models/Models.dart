library models;

import 'dart:convert';
import 'Serializable.dart';
import '../services/Services.dart';

class Poll extends Object with Serializable
{
  String PollGuid;
  String UserGuid;
  int CategoryId;
  DateTime Created; 
  int DurationHours;
  String Language;
  String Question;
  List<String> Options;
  List<int> Votes;
  
  bool get IsClosed => new DateTime.now().difference(Created).inHours > DurationHours;
  
  Poll();
  Poll.fromJSON(json, [ bool createNew = false ])
  {
    Map pollMap = JSON.decode(json);
    PollGuid = createNew ? Services.NewGuid() : pollMap["PollGuid"];
    Created = createNew ? new DateTime.now() : new DateTime.fromMillisecondsSinceEpoch(pollMap["Created"]);
    DurationHours = pollMap["DurationHours"];
    Question = pollMap["Question"];
    Options = pollMap["Options"];
    UserGuid = pollMap["UserGuid"];
  }
  
  String toJSON()
  {
    return JSON.encode(this);    
  }
  
  
 }

class User extends Object with Serializable
{
  String UserGuid;
  DateTime Created;
  DateTime LastRequest;
  String LastIP;
  
  User();
  
  User.CreateNew()
  {
    var now = new DateTime.now();
    UserGuid = Services.NewGuid();
    Created = now;
    LastRequest = now;
  }
  
  User.fromJSON(json)
  {
    Map userMap = JSON.decode(json);
    UserGuid = userMap["UserGuid"];
    //Created = new DateTime.fromMillisecondsSinceEpoch(userMap["Created"]);
    //LastRequest = new DateTime.fromMillisecondsSinceEpoch(userMap["LastRequest"]);
    //LastIP = userMap["LastIP"];
  }
  
  String toJSON()
  {
    return JSON.encode(this);    
  }

  

}

class Vote extends Object with Serializable
{
  String UserGuid;
  String PollGuid;
  int Option;
  
  Vote();
  Vote.fromJSON(json)
  {
    Map voteMap = JSON.decode(json);
    UserGuid = voteMap["UserGuid"];
    PollGuid = voteMap["PollGuid"];
    Option = voteMap["Option"];
  }
  
  String toJSON()
  {
    return JSON.encode(this);    
  }

}

class ApiResult extends Object with Serializable
{
  String Payload;
  String UserGuid;
  ApiResult(this.Payload, this.UserGuid);  
  
  String toJSON()
  {
    return JSON.encode(this);    
  }

}

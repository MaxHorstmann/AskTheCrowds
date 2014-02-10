library models;

import 'dart:convert';
import 'Serializable.dart';

class Poll extends Object with Serializable
{
  String UserUuid;
  int CategoryId;
  DateTime Created; 
  int DurationHours;
  String Language;
  String Question;
  List<String> Options;
  List<int> Votes;
  
  bool get IsClosed => new DateTime.now().difference(Created).inHours > DurationHours;
  
  Poll();
  Poll.fromJSON(json)
  {
    Map pollMap = JSON.decode(json);
    Created = new DateTime.fromMillisecondsSinceEpoch(pollMap["Created"]);
    DurationHours = pollMap["DurationHours"];
    Question = pollMap["Question"];
    Options = pollMap["Options"];
    UserUuid = pollMap["UserUuid"];
  }
  

 }

class User extends Object with Serializable
{
  DateTime Created;
  DateTime LastRequest;
  String LastIP;
  
  User();
  
  User.CreateNew()
  {
    var now = new DateTime.now();
    Created = now;
    LastRequest = now;
  }
  
  User.fromJSON(json)
  {
    Map userMap = JSON.decode(json);
    Uuid = userMap["Uuid"];
    //Created = new DateTime.fromMillisecondsSinceEpoch(userMap["Created"]);
    //LastRequest = new DateTime.fromMillisecondsSinceEpoch(userMap["LastRequest"]);
    //LastIP = userMap["LastIP"];
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


}

class ApiResult extends Object with Serializable
{
  String Payload;
  String UserGuid;
  ApiResult(this.Payload, this.UserGuid);  

}

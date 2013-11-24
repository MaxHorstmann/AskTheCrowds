library models;

import 'dart:convert';
import 'Serializable.dart';
import '../services/services.dart';

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
  
  Poll();
  Poll.fromJSON(json)
  {
    Map pollMap = JSON.decode(json);
    PollGuid = Services.NewGuid();
    Created = new DateTime.now();
    DurationHours = pollMap["DurationHours"];
    Question = pollMap["Question"];
    Options = pollMap["Options"];
    UserGuid = pollMap["UserGuid"];    
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

}

class Result extends Object with Serializable
{
  String ResultPayload;
}

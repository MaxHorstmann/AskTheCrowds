library models;

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
  
  bool get IsClosed => (Created!=null) && (new DateTime.now().difference(Created).inHours > DurationHours);
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
}

class Vote extends Object with Serializable
{
  String UserUuid;
  String PollUuid;
  int Option;
}

class ApiResult extends Object with Serializable
{
  String Payload;
  String UserUuid;
  ApiResult(this.Payload, this.UserUuid);  
}

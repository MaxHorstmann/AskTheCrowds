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
  
  bool IsValidVote(Vote vote)
  {
    return ((vote != null) 
        && ((vote.Option == Vote.FLAG) || ((Options != null) && (vote.Option>=0) && (vote.Option < Options.length))));
  }
 }

class User extends Object with Serializable
{
  DateTime Created;
  DateTime LastRequest;
  String LastIP;
  
  User();
  
  static User CreateNew()
  {
    var now = new DateTime.now();
    return new User()
      ..Created = now
      ..LastRequest = now;
  }
}

class Vote extends Object with Serializable
{
  String UserUuid;
  String PollUuid;
  int Option;
  
  static const int FLAG = -1;
}

class ApiResult extends Object with Serializable
{
  String Payload;
  String UserUuid;
  ApiResult(this.Payload, this.UserUuid);  
}

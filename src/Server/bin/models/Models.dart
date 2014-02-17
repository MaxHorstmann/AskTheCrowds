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
        && ((vote.Option == Flag.FLAG_VOTE) || ((Options != null) && (vote.Option>=0) && (vote.Option < Options.length))));
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
}

class Flag extends Object with Serializable
{
  DateTime Created;
  String UserUuid;
  String PollUuid;

  static const int FLAG_VOTE = -1;
}

class ApiResult extends Object with Serializable
{
  String Payload;
  String UserUuid;
  ApiResult(this.Payload, this.UserUuid);  
}

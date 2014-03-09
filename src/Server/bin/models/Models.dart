library models;

import 'Serializable.dart';
import 'dart:io';

class Poll extends Object with Serializable
{
  String UserId;
  int CategoryId;
  int TypeId; 
  DateTime Created; 
  int DurationHours;
  String LanguageCode;
  String Question;
  List<String> Options; 
  List<int> Votes;
  
  static const int TYPE_MULTIPLE_CHOICE = 1;
  static const int TYPE_NUMBER = 2;
  
  bool get IsClosed => (Created!=null) && (new DateTime.now().difference(Created).inHours > DurationHours);

  int get NumberPollMin => int.parse(Options[0]);
  int get NumberPollMax => int.parse(Options[1]);
  
  void Validate()
  {
    if ((TypeId != TYPE_MULTIPLE_CHOICE) && (TypeId != TYPE_NUMBER)) {
      throw new Exception("Invalid poll: TypeId $TypeId not valid.");
    }
  }
  
  bool IsValidVote(Vote vote)
  {
    if ((vote==null) || (IsClosed) || (Options==null) || (Options.length==0)) return false;
    
    if ((TypeId == TYPE_NUMBER) && (Options.length==2)) return ((vote.Option>=NumberPollMin) && (vote.Option<=NumberPollMax));
    if ((TypeId == TYPE_MULTIPLE_CHOICE) && (Options.length>0)) return ((vote.Option>=0) && (vote.Option < Options.length));
    
    return false;
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
  
  void UpdateLastRequest(HttpRequest request)
  {
    LastRequest = new DateTime.now();
    LastIP = request.connectionInfo.remoteAddress.address;
  }
  
}

class Vote extends Object with Serializable
{
  String UserId;
  String PollId;
  int Option;
}

class Flag extends Object with Serializable
{
  DateTime Created;
  String UserId;
  String PollId;

  static const int FLAG_VOTE = -999; // TODO different "flag" mechanism
}

class ApiResult extends Object with Serializable
{
  bool ErrorOccured;
  String Payload;
  String UserId;
  ApiResult(this.Payload, this.UserId);
  ApiResult.Error() {
    ErrorOccured = true;
  }
}

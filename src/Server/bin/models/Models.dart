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
  String ImageUrl;
  List<String> Options; 
  Map<String, int> Votes;
  
  static const int TYPE_MULTIPLE_CHOICE = 1;
  static const int TYPE_NUMBER = 2;
  
  static const int MAX_DURATION_HOURS = 24 * 30;
  static const int MAX_NUMBER_OF_OPTIONS = 8;
  
  bool get IsClosed => (Created!=null) && (new DateTime.now().difference(Created).inHours > DurationHours);

  int get NumberPollMin => int.parse(Options[0]);
  int get NumberPollMax => int.parse(Options[1]);
  
  void Validate()
  {
    if ((DurationHours==null) || (DurationHours<=0) || (DurationHours>MAX_DURATION_HOURS))
      throw new Exception("Invalid poll: DurationHours $DurationHours not valid.");

    if ((TypeId==null) || ((TypeId != TYPE_MULTIPLE_CHOICE) && (TypeId != TYPE_NUMBER))) {
      throw new Exception("Invalid poll: TypeId $TypeId not valid.");
    }
    
    if ((Question == null) || (Question.length == 0))
      throw new Exception("Invalid question: $Question");
    
    if ((TypeId == TYPE_MULTIPLE_CHOICE) 
      && ((Options==null) || ((Options.length<2) || (Options.length>MAX_NUMBER_OF_OPTIONS))))
        throw new Exception("Invalid options for multiple choice poll.");
    
    if (TypeId == TYPE_NUMBER) {
      if ((Options==null) || ((Options.length!=2)))
          throw new Exception("Invalid options for number poll. Need to be exactly two (min, max).");

      try {
        NumberPollMin;
        NumberPollMax;
      }
      catch (FormatException) {
        throw new Exception("Invalid options for number poll. Need to be numeric.");
      }
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
  bool IsFlag;
}

class Flag extends Object with Serializable
{
  DateTime Created;
  String UserId;
  String PollId;
}

class ApiResult extends Object with Serializable
{
  String Payload;
  String UserId;
  ApiResult(this.Payload, this.UserId);
}

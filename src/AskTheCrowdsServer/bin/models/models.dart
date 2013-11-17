
library models;

class Poll 
{
  int Id;
  String UserGuid;
  int CategoryId;
  DateTime Created;
  int DurationHours;
  String Language;
  String Question;
  List<String> Options;
  List<int> Results;
  
  Map toJson() { 
    Map map = new Map();
    map["Id"] = Id;
    map["UserGuid"] = UserGuid;
    map["CategoryId"] = CategoryId;
    map["Created"] = Created.millisecondsSinceEpoch;
    map["DurationHours"] = DurationHours;
    map["Language"] = Language;
    map["Question"] = Question;
    map["Options"] = Options;
    map["Results"] = Results;
    return map;
  } 
  
 }

class User
{
  static String Key = "Users";
  
  String UserGuid;
  DateTime Created;
}

class Result
{
  bool Success;
  Map toJson() { 
    Map map = new Map();
    map["Success"] = Success;
    return map;
  } 
}

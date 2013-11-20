library models;

import 'Serializable.dart';

class Poll extends Object with Serializable
{
  int Id;
  String UserGuid;
  int CategoryId;
  int Created; // millisecondsSinceEpoch
  int DurationHours;
  String Language;
  String Question;
  List<String> Options;
  List<int> Results;
 }

class User extends Object with Serializable
{
  String UserGuid;
  DateTime Created;
  DateTime LastRequest;
  String LastIP;
}

class Result extends Object with Serializable
{
  bool Success;
}

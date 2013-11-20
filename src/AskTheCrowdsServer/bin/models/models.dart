library models;

import 'Serializable.dart';

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
  String ResultPayload;
}

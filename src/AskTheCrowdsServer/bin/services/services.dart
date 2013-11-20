library services;

import "../models/models.dart";
import "package:uuid/uuid.dart";

class Services
{
  Uuid _uuid = new Uuid();
  
  String NewGuid()
  {
    return _uuid.v4();
  }
  
  User CreateNewUser()
  {
    var now = new DateTime.now();
    return new User()
      ..UserGuid = NewGuid()
      ..Created = now
      ..LastRequest = now;
  }
  
  
  
}
library services;

import "../models/models.dart";
import "package:uuid/uuid.dart";

class Services
{
  Uuid _uuid = new Uuid();
  
  User CreateNewUser()
  {
    var now = new DateTime.now();
    return new User()
      ..UserGuid = _uuid.v4()
      ..Created = now
      ..LastRequest = now;
  }
  
  
  
}
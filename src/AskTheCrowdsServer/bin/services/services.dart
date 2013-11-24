library services;

import "package:uuid/uuid.dart";

class Services
{
  static Uuid _uuid = new Uuid();
  
  static String NewGuid()
  {
    return _uuid.v4();
  } 
  
  
  
}
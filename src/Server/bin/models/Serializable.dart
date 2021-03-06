library Serializable;

import 'dart:mirrors';
import '../common/Util.dart';

// http://stackoverflow.com/questions/20024298/add-json-serializer-to-every-model-class

abstract class Serializable {

  String Id;
  
  Map toJson() { 
    Map map = new Map();
    map["Id"] = Id;
    
    InstanceMirror im = reflect(this);
    ClassMirror cm = im.type;
    var decls = cm.declarations.values.where((dm) => dm is VariableMirror);
    decls.forEach((VariableMirror vm) {
      if (vm.isStatic) 
        return;
      
      var key = MirrorSystem.getName(vm.simpleName);
      var val = im.getField(vm.simpleName).reflectee;
      
      // TODO deal with DateTime - then file a bug with Dart team 
      if (val == null) {
        val = ""; // workaround - Redis client's hmset doesn't handle null values  
      }
      if (val is DateTime) {
        map[key] = Util.DateTimeToIso8601(val);
      } else {
        map[key] = val;
      }
        
    });    

    return map;
  }  
  
}
library Serializable;

import 'dart:mirrors';

// http://stackoverflow.com/questions/20024298/add-json-serializer-to-every-model-class

abstract class Serializable {

  String Uuid;
  
  Map toJson() { 
    Map map = new Map();
    map["Uuid"] = Uuid;
    
    InstanceMirror im = reflect(this);
    ClassMirror cm = im.type;
    var decls = cm.declarations.values.where((dm) => dm is VariableMirror);
    decls.forEach((dm) {
      var key = MirrorSystem.getName(dm.simpleName);
      var val = im.getField(dm.simpleName).reflectee;
      
      // TODO deal with DateTime - then file a bug with Dart team 
      if (!(val is DateTime)) {
        map[key] = val;
      }
    });    

    return map;
  }  
  
  
}
library Json;

import 'dart:convert';
import 'dart:mirrors';
import 'Serializable.dart';



class Json<T extends Serializable>
{  
 
  T FromJson(String json)
  {
    if (json == null) {
      return null;
    }
    Map map = JSON.decode(json);
    return FromMap(map);    
  }
  
  
  T FromMap(Map map)
  {
    if (map == null) {
      return null;
    }
    
    ClassMirror cm = reflect(this).type;
    ClassMirror cm2 = cm.typeArguments[0] as ClassMirror;
    
    InstanceMirror instanceMirror = cm2.newInstance(const Symbol(""), []);
    T newInstance =  instanceMirror.reflectee;
    
    map.forEach((String K, Object V) {
      Symbol symbol = new Symbol(K);
      VariableMirror vm = cm2.declarations[symbol];
      if (vm != null) {
        TypeMirror tm = vm.type;
        if (V!=null) {
          if ((tm.simpleName == const Symbol("DateTime")) && (V is String)) {
            if (V.length > 0) {
              instanceMirror.setField(symbol, DateTime.parse(V));
            }
          } else if ((tm.simpleName == const Symbol("int")) && (V is String)) {
            if (V.length > 0) {
              instanceMirror.setField(symbol, int.parse(V));
            }
          } else if ((tm.simpleName == const Symbol("List")) && (V is String)) {
            if (V.length > 0) {
              instanceMirror.setField(symbol, JSON.decode(V));
            }
          } else if ((tm.simpleName == const Symbol("Map")) && (V is String)) {
            if (V.length > 0) {
              instanceMirror.setField(symbol, JSON.decode(V));
            }
          } else if ((tm.simpleName == const Symbol("String"))) {
            instanceMirror.setField(symbol, V.toString());
          } 
          else {
            instanceMirror.setField(symbol, V);
          }
        }
      }
    });
    
    return newInstance;
  }
  
}

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
    
    ClassMirror cm = reflect(this).type;
    ClassMirror cm2 = cm.typeArguments[0] as ClassMirror;
    
    InstanceMirror instanceMirror = cm2.newInstance(const Symbol(""), []);
    T newInstance =  instanceMirror.reflectee;
    
    Map pollMap = JSON.decode(json);
    pollMap.forEach((String K, Object V) {
      Symbol symbol = new Symbol(K);
      VariableMirror vm = cm2.declarations[symbol];
      if (vm != null) {
        TypeMirror tm = vm.type;
        if ((V != null) && (tm.simpleName == const Symbol("DateTime"))) {
          var dt = DateTime.parse(V);
          instanceMirror.setField(symbol, dt);
        } else {
          instanceMirror.setField(symbol, V);
        }
      }
    });
    
    return newInstance;
  }
  
}

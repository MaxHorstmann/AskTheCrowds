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
      DeclarationMirror dm = cm2.declarations[symbol];
      instanceMirror.setField(symbol, V);
    });
    
    return newInstance;
  }
  
}

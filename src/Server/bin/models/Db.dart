library Db;

import "package:redis_client/redis_client.dart";
import 'dart:async';
import 'dart:convert';
import 'dart:mirrors';
import "package:uuid/uuid.dart";
import '../common/Config.dart';
import 'Serializable.dart';


// --- make this a package at some point, something like redis_orm ----


class Db<T extends Serializable>
{  
  static Uuid _uuid = new Uuid();

  String _entityName;
  
  Db()
  {
    ClassMirror cm = reflect(this).type;
    var symbol = cm.typeArguments[0].qualifiedName;
    _entityName = symbol.toString();
  }
  
  Future<List<T>> All()
  {
    return Where((_) => true);
  }

  Future<List<T>> Where(bool Filter(T x))
  {
    Completer<List<T>> completer = new Completer<List<T>>();
    AllUuids().then((Set<String> uuids) {      
      var entities = new List<T>();
      var futures = new List<Future<T>>();
      uuids.forEach((String uuid) {
        var future = Single(uuid);
        future.then((T entity) {
          if ((entity != null) && (Filter(entity))) {
            entities.add(entity); 
          }
        });
        futures.add(future);
      });
      Future.wait(futures).then((_) {
        completer.complete(entities);        
      });      
    });    
    return completer.future;    
  }
  
  Future<Set<String>> AllUuids()
  { 
    Completer<Set<String>> completer = new Completer<Set<String>>();
    RedisClient.connect(Config.connectionStringRedis)
      .then((RedisClient redisClient) { 
        redisClient.exists(GetKey()).then((bool exists) {
          if (!exists) {
            completer.complete(new Set<String>()); // empty set
            return;
          }
          redisClient.smembers(GetKey()).then((Set<String> pollUuids) {
            completer.complete(pollUuids);
          });
        });
     });
    return completer.future;
  }
  
  Future<T> Single(String uuid)
  {
    Completer<T> completer = new Completer<T>();
    
    RedisClient.connect(Config.connectionStringRedis)
      .then((RedisClient redisClient) {
        return redisClient.get(uuid).then((String json) {   
          if (json == null) {
            completer.complete(null);
            return;
          }
          T fromJson = FromJson(json);
          fromJson.Uuid = uuid;
          completer.complete(fromJson);
        });
      });
    
    return completer.future;
    
  }
  
  T FromJson(String json)
  {
    if (json == null) {
      return null;
    }
    
    ClassMirror cm = reflect(this).type;
    ClassMirror cm2 = cm.typeArguments[0] as ClassMirror;
    InstanceMirror instanceMirror = cm2.newInstance(const Symbol("fromJSON"), [ json ]);
    T newInstance =  instanceMirror.reflectee;
    return newInstance;
    
       
    
  }
  
  Future<bool> Save(T entity) {

    Completer<bool> completer = new Completer<bool>();
    
    if (entity.Uuid == null) {
      entity.Uuid = _uuid.v4();
    }
        
    var json = JSON.encode(entity);
    
    RedisClient.connect(Config.connectionStringRedis)
      .then((RedisClient redisClient) {
        var key = GetKey();
        redisClient.sadd(key, entity.Uuid).then((int elementsAdded) {
          redisClient.set(entity.Uuid, json).then((_) {
            completer.complete(true);
          });
        });
      });
    
    return completer.future;    
  }
  
  String GetKey()
  {
    return "idx:" + _entityName;
  }
  
 
}

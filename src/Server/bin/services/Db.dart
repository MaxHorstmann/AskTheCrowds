library Db;

import "package:redis_client/redis_client.dart";
import 'dart:async';
import "../common/Config.dart";
import "../models/Serializable.dart";
import "../services/Services.dart";


class Db<T extends Serializable>
{
  String _entityName;
  Db(this._entityName);
  
  Future<List<T>> All()
  {
    Completer<List<T>> completer = new Completer<List<T>>();
    AllGuids().then((Set<String> guids) {      
      var entities = new List<T>();
      var futures = new List<Future<T>>();
      guids.forEach((String guid) {
        var future = Single(guid);
        future.then((T entity) {
          if (entity != null) {
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
  
  Future<Set<String>> AllGuids()
  { 
    Completer<Set<String>> completer = new Completer<Set<String>>();
    RedisClient.connect(Config.connectionStringRedis)
      .then((RedisClient redisClient) { 
        var key = "idx:" + _entityName;
        redisClient.exists(key).then((bool exists) {
          if (!exists) {
            completer.complete(new Set<String>()); // empty set
            return;
          }
          redisClient.smembers(key).then((Set<String> pollGuids) {
            completer.complete(pollGuids);
          });
        });
     });
    return completer.future;
  }
  
  Future<T> Single(String guid)
  {
    Completer<T> completer = new Completer<T>();
    
    RedisClient.connect(Config.connectionStringRedis)
      .then((RedisClient redisClient) {
        return redisClient.get(guid).then((String json) {          
          completer.complete(json == null ? null : Serializable.fromJSON(json));
        });
      });
    
    return completer.future;
    
  }
  
  T FromJson(String json)
  {
    return null;
  }
  
  Future<bool> Save(T entity) {

    Completer<bool> completer = new Completer<bool>();
    
    if (entity.Guid == null) {
      entity.Guid = Services.NewGuid();
    }
        
    var json = entity.toJson();
    
    RedisClient.connect(Config.connectionStringRedis)
      .then((RedisClient redisClient) {
        var key = "idx:" + _entityName;
        redisClient.sadd(key, entity.Guid).then((int elementsAdded) {
          redisClient.set(key, json).then((_) {
            completer.complete(true);
          });
        });
      });
    
    return completer.future;    
  }
  

  
  
 
}

library Db;

import "package:redis_client/redis_client.dart";
import 'dart:async';
import 'dart:mirrors';
import "package:uuid/uuid.dart";
import '../common/Config.dart';
import 'Serializable.dart';
import 'Json.dart';


// --- make this a package at some point, something like redis_orm ----


class Db<T extends Serializable>
{  
  static Uuid _uuid = new Uuid();  

  String _entityName;
  Json<T> _json;
  
  Db()
  {
    ClassMirror cm = reflect(this).type;
    var symbol = cm.typeArguments[0].qualifiedName;
    _entityName = symbol.toString();
    _json = new Json<T>();
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
        redisClient.exists(GetIndexKey()).then((bool exists) {
          if (!exists) {
            completer.complete(new Set<String>()); // empty set
            return;
          }
          redisClient.smembers(GetIndexKey()).then((Set<String> pollUuids) {
            completer.complete(pollUuids);
          });
        });
     });
    return completer.future;
  }
  
  Future<T> Single(String uuid)
  {
    Completer<T> completer = new Completer<T>();    
    if (uuid == null) {
      completer.complete(null);
    } else {
      RedisClient.connect(Config.connectionStringRedis)
        .then((RedisClient redisClient) {
          return redisClient.hgetall(uuid).then((Map map) {   
            if (map == null) {
              completer.complete(null);
              return;
            }
            T fromJson = _json.FromMap(map);
            fromJson.Uuid = uuid;
            completer.complete(fromJson);
          });
        });
    }
    return completer.future;
  }
  
  Future<T> SingleOrNew(String uuid, T createNew())
  {
    Completer<T> completer = new Completer<T>();
    Single(uuid).then((T existingEntity) {
      if (existingEntity != null) {
        completer.complete(existingEntity);
        return;
      }
      
      T newEntity = createNew();
      Save(newEntity).then((_) => completer.complete(newEntity)); // TODO handle save failure      
      
    });
    return completer.future;
  }
  
  
  Future Save(T entity) {
    if (entity.Uuid == null) {
      entity.Uuid = _uuid.v4();
    }

    var map = entity.toJson();
    RedisClient redisClient = null;
    
    return RedisClient.connect(Config.connectionStringRedis)
      .then((RedisClient newRedisClient) {
          redisClient = newRedisClient;
          return redisClient.sadd(GetIndexKey(), entity.Uuid); 
        })
      .then((int elementsAdded) => redisClient.hmset(entity.Uuid, map));
  }
  
  Future<List<int>> GetSetCounts(T entity, String setName, int numberOfSets)
  {
    Completer<List<int>> completer = new Completer<List<int>>();
    
    if (numberOfSets<=0) {
      completer.complete(null);
    } else {      
      List<int> setCounts = new List<int>(numberOfSets);
      var futures = new List<Future<T>>();
      for (int i=0;i<numberOfSets;i++) {
        var future = RedisClient.connect(Config.connectionStringRedis)
            .then((RedisClient redisClient) => redisClient.scard(GetSetKey(entity, setName, i)))
            .then((int cnt) => setCounts[i] = cnt);
        futures.add(future);
      }
      Future.wait(futures).then((_) {
        completer.complete(setCounts);        
      });
      
    }
    return completer.future;    
  }
  
  Future<int> AddToSet(T entity, String setName, int setIndex, String value)
  {
    return RedisClient.connect(Config.connectionStringRedis)
        .then((RedisClient redisClient) => redisClient.sadd(GetSetKey(entity, setName, setIndex), value));
  }
  
  String GetIndexKey()
  {
    return "idx:" + _entityName;
  }
  
  String GetSetKey(T entity, String setName, int setIndex)
  {
    return entity.Uuid + ":" + setName + ":" + setIndex.toString();
  }
  
 
}

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
    AllIds().then((Set<String> ids) {      
      var entities = new List<T>();
      var futures = new List<Future<T>>();
      ids.forEach((String id) {
        var future = Single(id);
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
  
  Future<Set<String>> AllIds()
  { 
    RedisClient redisClient = null;
    return RedisClient.connect(Config.connectionStringRedis)
      .then((RedisClient redisClientFound) {
        redisClient = redisClientFound;
        return redisClient.exists(GetIndexKey()); 
        })
      .then((bool exists) => exists ?
            redisClient.smembers(GetIndexKey()).then((Set<Object> pollIds) => pollIds.map((oId) => oId.toString()).toSet()) :
            new Future<Set<String>>.value(new Set<String>()));
  }
  
  Future<T> Single(String id)
  {
    Completer<T> completer = new Completer<T>();    
    if (id == null) {
      completer.complete(null);
    } else {
      RedisClient.connect(Config.connectionStringRedis)
        .then((RedisClient redisClient) {
          redisClient.exists(GetEntityKey(id))
          .then((bool exists){
            if (!exists) {
              completer.complete(null);
            }
            else
            return redisClient.hgetall(GetEntityKey(id)).then((Map map) {   
              if (map == null) {
                completer.complete(null);
                return;
              }
              T fromJson = _json.FromMap(map);
              fromJson.Id = id;
              completer.complete(fromJson);
            });
          });
        });
    }
    return completer.future;
  }
  
  Future<T> SingleOrNew(String id, T createNew())
  {
    Completer<T> completer = new Completer<T>();
    Single(id).then((T existingEntity) {
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
    RedisClient redisClient = null;    
    return RedisClient.connect(Config.connectionStringRedis)
      .then((RedisClient newRedisClient) {
          redisClient = newRedisClient;
          return entity.Id == null ?
              redisClient.incr(GetEntitySequenceKey()) :
              new Future<int>.value(int.parse(entity.Id));
      })
      .then((int id) {
          entity.Id = id.toString();
          return redisClient.sadd(GetIndexKey(), entity.Id); 
        })
      .then((_) => redisClient.hmset(GetEntityKey(entity.Id), entity.toJson()));
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
  
  Future<int> GetSequenceValue()
  {
    return RedisClient.connect(Config.connectionStringRedis)
        .then((RedisClient redisClient) => redisClient.get(GetEntitySequenceKey()))
        .then((String sequenceKey) => new Future.value(sequenceKey == null ? 0 : int.parse(sequenceKey)));
  }
  
  String GetEntityKey(String id)
  {
    return _entityName + ":" + id;
  }
  
  String GetEntitySequenceKey()
  {
    return "seq:" + _entityName;
  }
  
  String GetIndexKey()
  {
    return "idx:" + _entityName;
  }
  
  String GetSetKey(T entity, String setName, int setIndex)
  {
    return entity.Id + ":" + setName + ":" + setIndex.toString();
  }
  
 
}

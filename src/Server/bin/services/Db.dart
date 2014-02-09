library Db;

import "package:redis_client/redis_client.dart";
import 'dart:async';
import "../models/Models.dart";
import "../common/Config.dart";
import "../services/Services.dart";

class Db<T>
{
  RedisClient redisClient = null;
  
  Db()
  {
    RedisClient.connect(Config.connectionStringRedis)
      .then((RedisClient redisClientNew) { redisClient = redisClientNew; });    
  }
  
  Future<Set<String>> GetEntityGuids()
  {
    var key = "idx:" + entityName;
    Completer<Set<String>> completer = new Completer<Set<String>>();
    redisClient.exists(key).then((bool exists) {
      if (!exists) {
        completer.complete(new Set<String>()); // empty set
      }
      redisClient.smembers(key).then((Set<String> pollGuids) {
        completer.complete(pollGuids);
      });
    });
    return completer.future;
  }
  
  Future<List<T>> GetEntity()
  {
    Completer<List<Poll>> completer = new Completer<List<Poll>>();
    GetEntityGuids("polls").then((Set<String> pollGuids) {  
      var polls = new List<Poll>();
      var futures = new List<Future<Poll>>();
      pollGuids.forEach((String pollGuid) {
        var pollFuture = GetPoll(pollGuid);
        pollFuture.then((Poll p) => polls.add(p));
        futures.add(pollFuture);
      });
      Future.wait(futures).then((_) {
        completer.complete(polls);        
      });      
    });    
    return completer.future;    
  }
  
  Future<Poll> GetPoll(String key)
  {
    return redisClient.get(key).then((String value) {
      var poll = new Poll.fromJSON(value);
      poll.Votes=new List<int>.filled(poll.Options.length, 0);
      var futures = new List<Future<int>>();
      for (var i=0;i<poll.Options.length; i++) {
        var voteKey = key + ":votes:" + i.toString();
        var votesFuture = redisClient.scard(voteKey);
        futures.add(votesFuture);
        votesFuture.then((int card) {
          poll.Votes[i]=card; 
        });
      }
      return Future.wait(futures).then((_) => poll);      
    });
  }
  
  Future<bool> SavePoll(Poll poll) {
    
    if (poll.PollGuid == null) {
       poll.PollGuid = Services.NewGuid();
    }
    
    Completer<bool> completer = new Completer<bool>();
    
    var key = "pollGuid:" + poll.PollGuid;
    var json = poll.toJson();
    
    redisClient.sadd("idx:users", poll.PollGuid).then((int elementsAdded) {
      redisClient.set(key, json).then((_) {
        completer.complete(true);
      });
    });
    
    
    return completer.future;    
  }
  
  Future<List<User>> GetUsers()
  {
    Completer<List<User>> completer = new Completer<List<User>>();
    GetUserGuids().then((Set<String> userGuids) {      
      var users = new List<User>();
      var futures = new List<Future<User>>();
      userGuids.forEach((String userGuid) {
        var userFuture = GetUser(userGuid);
        userFuture.then((User u) {
          if (u != null) {
            users.add(u); 
          }
        });
        futures.add(userFuture);
      });
      Future.wait(futures).then((_) {
        completer.complete(users);        
      });      
    });    
    return completer.future;    
  }
  
  
  Future<User> GetUser(String userGuid)
  {
    var userKey = "userGuid:" + userGuid.toString();
    return redisClient.get(userKey).then((String value) {
      return value == null ? null : new User.fromJSON(value);      
    });      
  }
  
  Future<bool> SaveUser(User user) {
    if (user.UserGuid == null) {
      user.UserGuid = Services.NewGuid();
    }
    
    var key = "userGuid:" + user.UserGuid;
    var json = user.toJson();
    
    Completer<bool> completer = new Completer<bool>();
    
    redisClient.sadd("idx:users", user.UserGuid).then((int elementsAdded) {
      redisClient.set(key, json).then((_) {
        completer.complete(true);
      });
    });
    
    return completer.future;    
  }
    
}

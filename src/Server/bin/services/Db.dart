library Db;

import "package:redis_client/redis_client.dart";
import 'dart:async';
import "../models/models.dart";

class Db
{
  String connectionStringRedis;  
  RedisClient redisClient = null;
  
  Db(this.connectionStringRedis)
  {
    RedisClient.connect(connectionStringRedis)
      .then((RedisClient redisClientNew) { redisClient = redisClientNew; });    
  }
  
  Future<List<String>> GetPollGuids()
  {
    return redisClient.keys("pollGuid:*:poll");
  }
  
  Future<List<Poll>> GetPolls()
  {
    Completer<List<Poll>> completer = new Completer<List<Poll>>();
    GetPollGuids().then((List<String> pollGuids) {      
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
  
  Future<List<String>> GetUserGuids()
  {
    return redisClient.keys("userGuid:*");    
  }
  
  Future<List<User>> GetUsers()
  {
    Completer<List<User>> completer = new Completer<List<User>>();
    GetUserGuids().then((List<String> userGuids) {      
      var users = new List<User>();
      var futures = new List<Future<User>>();
      userGuids.forEach((String userGuid) {
        var userFuture = GetUser(userGuid);
        userFuture.then((User u) => users.add(u));
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
      return new User.fromJSON(value);      
    });      
  }
    
}

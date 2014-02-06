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
  
  Future<List<String>> GetUserGuids()
  {
    return redisClient.keys("userGuid:*");    
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
  

    
}

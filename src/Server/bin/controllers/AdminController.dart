library AdminController;

import 'dart:io';
import 'dart:async';
import "BaseController.dart";
import "package:redis_client/redis_client.dart";


class AdminController extends BaseController
{
  
  String connectionStringRedis;  
  RedisClient redisClient = null;
  
  AdminController(this.connectionStringRedis)
  {
    RedisClient.connect(connectionStringRedis)
      .then((RedisClient redisClientNew) { redisClient = redisClientNew; });    
  }
  
  bool Index(HttpRequest request)
  {
    request.response.statusCode = 200;
    
    // users
    request.response.write("users\n");
    redisClient.keys("userGuid:*").then((List<String> userGuids){
      request.response.write(userGuids.join('\n'));
      request.response.close();
    });
    
    return true;  
  }

  
}

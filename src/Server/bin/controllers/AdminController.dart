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
    sendContent(request, "Admin controller");
    return true;  
  }

  
}

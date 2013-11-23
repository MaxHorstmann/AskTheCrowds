library HomeController;

import 'dart:io';
import "BaseController.dart";


class HomeController extends BaseController
{
  
  HomeController(String _redisConnectionString) : super(_redisConnectionString);
  
  // Route = '/'
  void Index(HttpRequest request)
  {
    sendContent(request, "Ask the Crowds server");
  }

  
}

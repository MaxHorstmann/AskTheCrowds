library HomeController;

import 'dart:io';
import "BaseController.dart";


class HomeController extends BaseController
{
  
  // Route = '/'
  bool Index(HttpRequest request)
  {
    sendContent(request, "Ask the Crowds server. 4/27/2014 imgfolder");
    return true;
  }

  // Route = '/pingdom'
  bool Pingdom(HttpRequest request)
  {
    sendContent(request, "hello pingdom - all good.");
    return true;
  }
}

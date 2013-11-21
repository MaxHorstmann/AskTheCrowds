library HomeController;

import 'dart:io';
import "BaseController.dart";


class HomeController extends BaseController
{
  // Route = '/'
  void Index(HttpRequest request)
  {
    sendContent(request, "Ask the Crowds server");
  }

  
}

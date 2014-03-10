library BaseController;

import 'dart:io';
import 'dart:convert';

abstract class BaseController
{
  

  void sendContent(HttpRequest request, String content, [ int statusCode = 200 ])
  {
    request.response.statusCode = statusCode;
    request.response.write(content);
    request.response.close();
  }
  
  void sendJson(HttpRequest request, Object payload, [ int statusCode = 200 ])
  {
    sendJsonRaw(request,JSON.encode(payload),statusCode);
  }  
  
  void sendJsonRaw(HttpRequest request, String json, [ int statusCode = 200 ])
  {
    request.response.statusCode = statusCode;
    request.response.headers.contentType = ContentType.parse("text/json");
    request.response.write(json);        
    request.response.close();
  }  
  
  
  void sendServerError(HttpRequest request, [e])
  {
    if (e != null) {
      print(e.toString());
    }
    request.response.statusCode = 500;
    request.response.close();
  }
  
  void sendPageNotFound(HttpRequest request)
  {
    sendContent(request, "404 not found", 404);
  }
  

}
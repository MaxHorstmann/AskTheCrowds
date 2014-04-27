library BaseController;

import 'dart:io';
import 'dart:convert';

abstract class BaseController
{
  

  void sendContent(HttpRequest request, String content, [ int statusCode = HttpStatus.OK ])
  {
    request.response.statusCode = statusCode;
    request.response.write(content);
    request.response.close();
  }
  
  void sendJson(HttpRequest request, Object payload, [ int statusCode = HttpStatus.OK ])
  {
    sendJsonRaw(request,JSON.encode(payload),statusCode);
  }  
  
  void sendJsonRaw(HttpRequest request, String json, [ int statusCode = HttpStatus.OK ])
  {
    request.response.statusCode = statusCode;
    request.response.headers.contentType = ContentType.parse("text/json");
    request.response.write(json);        
    request.response.close();
  }  
  
  
  void sendServerError(HttpRequest request, [e])
  {
    request.response.statusCode = HttpStatus.INTERNAL_SERVER_ERROR;
    if (e != null) {
      print(e.toString());
      request.response.headers.contentType = ContentType.parse("text/plain");
      request.response.write(e.toString());
    }
    request.response.close();
  }
  
  void sendPageNotFound(HttpRequest request)
  {
    sendContent(request, "404 not found", 404);
  }
  

}
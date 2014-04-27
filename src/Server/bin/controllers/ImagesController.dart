library ImagesController;

import 'dart:io';
//import 'dart:async';
import 'package:http_server/http_server.dart';
import "BaseController.dart";
//import "../models/Models.dart";
//import "../models/Json.dart";
//import "../common/Util.dart";

class ImagesController extends BaseController
{
  //String imagesFolder = "c:\images";
  
  bool Index(HttpRequest request)
  {
    if (request.method == "POST")  
    {
      // TODO
      HttpBodyHandler.processRequest(request)
        .then((HttpBody body) {   
          var foo = body.body;
          
        });

    }
    
    if (request.method == "GET")  
    {
      request.response.statusCode = HttpStatus.OK;
      request.response.headers.contentType = ContentType.parse("image/jpg");
      var file = new File("C:\\images\\20140328_174533.jpg");
      file.readAsBytes().then((List<int> bytes) {
        bytes.forEach((int b) => request.response.writeCharCode(b));
        request.response.close();       
      });     
      
      return true;
    }
    
    return false;           
  }
  
  
 
  
  
}

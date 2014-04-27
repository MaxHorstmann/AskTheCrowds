library ImagesController;

import 'dart:io';
import "BaseController.dart";

class ImagesController extends BaseController
{
  //String imagesFolder = "c:\images";
  
  bool Index(HttpRequest request)
  {
    if (request.method == "POST")  
    {
      if ((request.headers.contentType != null) && (request.headers.contentType.mimeType == 'image/jpg'))
      {
        var builder = new BytesBuilder();      
        request.listen((List<int> buffer) => builder.add(buffer),
            onDone: () =>
              new File("c:\\images\\test.jpg")
                .writeAsBytes(builder.takeBytes(), mode: FileMode.WRITE)
                .then((_) {
                  request.response.statusCode = HttpStatus.OK;
                  request.response.close();
                })
            );       
      }
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

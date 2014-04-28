library ImagesController;

import 'dart:io';
import "package:uuid/uuid.dart";
import "package:path/path.dart" as path;
import "BaseController.dart";
import '../common/Config.dart';


class ImagesController extends BaseController
{
  static Uuid _uuid = new Uuid();  
  
  bool Index(HttpRequest request)
  {
    if (request.method == "GET")  
    {
      var uuid = request.uri.queryParameters["uuid"];
      var file = new File(GetFilePath(uuid));
      if (!file.existsSync()) {
        return false;
      }
      
      request.response.statusCode = HttpStatus.OK;
      request.response.headers.contentType = ContentType.parse("image/jpg");
      var future = file.readAsBytes();
      request.response.addStream(future.asStream()).whenComplete(() {
        request.response.close();
      });
      
      return true;
    }
    
    if (request.method == "POST")  
    {
      if ((request.headers.contentType != null) && (request.headers.contentType.mimeType == 'image/jpg'))
      {
        var uuid = _uuid.v4();        
        var builder = new BytesBuilder();      
        request.listen((List<int> buffer) { 
          builder.add(buffer);
          },
            onDone: () =>
              new File(GetFilePath(uuid))
                .writeAsBytes(builder.takeBytes(), mode: FileMode.WRITE)
                .then((_) {
                  sendJson(request, uuid);
                })
            );
        
        return true;
      }
    }
    
    return false;           
  }
  
  String GetFilePath(String uuid) {
    return path.join(Config.imagesFolder, uuid + ".jpg");
  } 
  
  
}

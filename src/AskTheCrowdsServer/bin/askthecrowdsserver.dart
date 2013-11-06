import "package:express/express.dart";

void main() {
  print("Starting up server...");
  
  var app = new Express()
    ..get('/', (ctx){
      ctx.render('index', {'title': 'Home'});
    });
  
  app.listen("127.0.0.1", 8000);
  
}

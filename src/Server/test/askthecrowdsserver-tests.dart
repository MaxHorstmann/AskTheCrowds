import 'package:unittest/unittest.dart';

import '../bin/models/Models.dart';
import 'dart:convert';


void main() {
   
  Poll p = new Poll();

  p.Question = "test question";
  p.Options = ["foo", "bar"];
  
  String json1 = JSON.encode(p);
  print(json1);
  test('json1', () => expect(json1.length, greaterThan(0)));
  
  var map = new Map<String, int>();
  map["17"] = 1223;
  
  var foo = JSON.encode(map);
  
  test('json2', () => expect(JSON.encode(p).length, greaterThan(0)));
  
  
}
import 'package:unittest/unittest.dart';

import '../bin/models/Models.dart';
import 'dart:convert';


void main() {
   
  Poll p = new Poll();
  String json = JSON.encode(p);  
  
  test('json', () => expect(json.length, greaterThan(0)));
  
  
  
  
}
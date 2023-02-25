import 'dart:math';

import 'package:faker/faker.dart';

class LoremIpsumGenerator {
  Faker faker = Faker();

  LoremIpsumGenerator._internal();
  static final LoremIpsumGenerator _singleton = LoremIpsumGenerator._internal();
  factory LoremIpsumGenerator() =>_singleton;

  String generateLoremIpsumName() {
    List<String> loremIpsumName = faker.lorem.words(Random().nextInt(2) + 1);
    for (int i = 0; i < loremIpsumName.length; i++) {
      loremIpsumName[i] =
          loremIpsumName[i][0].toUpperCase() + loremIpsumName[i].substring(1);
    }
    return loremIpsumName.join(' ');
  }
  
  String generateLoremIpsumMessage(){
    String message = '';
    for (int i = 0; i < Random().nextInt(3) + 1; i++) {
       message+= faker.lorem.sentence();
    }
    return message;
  }
}

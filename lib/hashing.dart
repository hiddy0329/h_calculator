import 'package:crypto/crypto.dart';
import 'dart:convert';

class Hashing {
  static main(password) {
    var bytes = utf8.encode(password); 

    var digest = sha512.convert(bytes);

    return digest.toString();
  }
}

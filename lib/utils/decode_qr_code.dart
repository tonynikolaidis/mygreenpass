import 'dart:io';
import 'package:dart_base45/dart_base45.dart';
import 'package:dart_cose/dart_cose.dart';

class DecodeQrCode {
  static Map decodeQrCode(String code) {
    var base45Decoded = Base45.decode(code.substring(4));
    var inflated = zlib.decode(base45Decoded);
    final result = Cose.decodeAndVerify(inflated, {'kid': '''pem'''});

    return result.payload;
  }
}
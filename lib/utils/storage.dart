import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static late SharedPreferences _storage;
  static late int numberOfCertificates;
  static late List<String>? certificates;

  static Future<void> initLocalStorage() async {
    Future<SharedPreferences> _p = SharedPreferences.getInstance();
    _storage = await _p;

    if (!_storage.containsKey('codes')) {
      await _storage.setStringList('codes', []);
      certificates = [];
      numberOfCertificates = 0;
    } else {
      updateCertificates();
    }
  }

  static Future<void> updateCertificates() async {
    List<String>? codes = _storage.getStringList('codes');
    certificates = codes;
    numberOfCertificates = certificates!.length;
    // print('Storage class: ' + certificates.toString());
    // print('Number of certificates: ' + numberOfCertificates.toString());
  }

  static List<String>? getItem(String key) {
    return _storage.getStringList(key);
  }

  static Future<void> setItem(String key, List<String> value) async {
    await _storage.setStringList(key, value);
    updateCertificates();
  }

  static Future<void> clear() async {
    _storage.clear();
  }
}

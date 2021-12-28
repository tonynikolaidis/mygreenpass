import 'dart:convert';

import 'package:localstorage/localstorage.dart';

class Storage {
  static late LocalStorage _storage;
  static late int numberOfCertificates;
  static late List certificates;

  static Future<void> initLocalStorage() async {
    _storage = new LocalStorage('certificates.json');

    if (await _storage.ready) {
      print('!!!!! STORAGE IS READY: ' + _storage.ready.toString());
      // await _storage.deleteItem('codes');
      print('!!!! STORAGE TO STRING: ' + _storage.toString());

      if (await _storage.getItem('codes') == null) {
        await _storage.setItem('codes', []);
        certificates = [];
        numberOfCertificates = 0;
      } else {
        // await _storage.clear();
        updateCertificates();
      }

    } else {
      print('!!!!! STORAGE IS NOT READY');
    }
  }

  static Future<void> updateCertificates() async {
    final codes = await _storage.getItem('codes');
    certificates = codes;
    numberOfCertificates = certificates.length;
    print('Storage class: ' + (await _storage.getItem('codes')).toString());
  }

  static Future<List> getItem(String key) async {
    return _storage.getItem(key);
  }

  static Future<void> setItem(String key, Object value) async {
    await _storage.setItem(key, value);
    updateCertificates();
  }

  static Future<void> clear() async {
    _storage.clear();
  }

}

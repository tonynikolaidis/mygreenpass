import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:barcode_finder/barcode_finder.dart';

import 'constants.dart';

class ScanQrCodeFromFile {
  static AlertDialog importFailed(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Import failed',
        style: TextStyle(color: COLOR_BLUE, fontSize: 24.0),
      ),
      content: Text(
        'The file either contains an invalid QR code or the QR code could not be recognised.',
        style: TextStyle(fontSize: 16.0),
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          style: ButtonStyle(
            overlayColor: MaterialStateColor.resolveWith(
                    (states) => COLOR_BLACK_SPLASH),
          ),
          child: Text('OK',
              style:
              TextStyle(color: Colors.black, fontSize: 16.0)),
        ),
      ],
    );
  }

  static AlertDialog certificateAlreadyExists(BuildContext context) {
    return AlertDialog(
      // title: Text(
      //   'Certificate exists',
      //   style: TextStyle(color: COLOR_BLUE, fontSize: 24.0),
      // ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_rounded, size: 32, color: COLOR_BLUE,),
          // Text(
          //   'Certificate exists',
          //   style: TextStyle(color: COLOR_BLUE, fontSize: 24.0),
          // )
        ],
      ),
      content: Text(
        'This certificate is already saved in the app.',
        style: TextStyle(fontSize: 16.0),
      ),
      backgroundColor: Colors.white,
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          style: ButtonStyle(
            overlayColor: MaterialStateColor.resolveWith(
                    (states) => COLOR_BLACK_SPLASH),
          ),
          child: Text('OK',
              style:
              TextStyle(color: Colors.black, fontSize: 16.0)),
        ),
      ],
    );
  }

  static Future<FilePickerResult?> pickFile() async {
    // Pick an image
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false
    );

    return result;
  }

  static Future<String> scan(FilePickerResult? result) async {
    if (result == null) {
      return 'NOT_FOUND';
    }

    String? path = result.files.single.path; // result.path;

    if (path == null) {
      return 'NOT_FOUND';
    }

    String? code = await BarcodeFinder.scanFile(path: path);

    if (code == null) {
      return 'NOT_FOUND';
    }

    return code;
  }
}
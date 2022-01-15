import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';

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
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false
    );

    return result;
  }

  static Future<String> scan(FilePickerResult? result) async {
    if (result == null) {
      return 'NOT_FOUND';
    }

    final String extension = result.files.first.extension.toString();

    // print('FILE TYPE: ' + extension);

    String? path = result.files.single.path; // result.path;

    if (path == null) {
      return 'NOT_FOUND';
    }

    File file = File(path);

    if (extension == 'pdf') {
      final doc = await PdfDocument.openFile(path);
      // final pages = doc.pageCount;

      // print('Pages: ' + pages.toString());

      // get images from all the pages
      var page = await doc.getPage(1);
      const scale = 300.0 / 72.0;
      var fullWidth = page.width * scale;
      var fullHeight = page.height * scale;
      var imgPdf = await page.render(
          x: 0,
          y: 0,
          width: fullWidth.toInt(),
          height: fullHeight.toInt(),
          fullWidth: 1000,
          fullHeight: 5000
      );

      var img = await imgPdf.createImageDetached();
      var bytes = await img.toByteData(format: ImageByteFormat.png);

      final documentDirectory = await getExternalStorageDirectory();

      if (documentDirectory == null) {
        // print('DocumentDirectory is null');
        return 'NOT_FOUND';
      }

      File imgFile = new File('${documentDirectory.path}/temp.jpg');

      // print('imgFile exists: ' + imgFile.existsSync().toString());

      if (bytes == null) {
        // print('bytes is null');
        return 'NOT_FOUND';
      }

      List<int> listOfBytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes).map((eachUint8) => eachUint8.toInt()).toList();
      file = await new File(imgFile.path).writeAsBytes(listOfBytes);
      // print('PDF as image exists: ' + file.existsSync().toString());
    }

    final inputImage = InputImage.fromFile(file);

    final barcodeScanner = GoogleMlKit.vision.barcodeScanner();

    final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);

    barcodeScanner.close();

    if (barcodes.isEmpty) {
      // print('NO QR CODE FOUND');
      barcodeScanner.close();
      return 'NOT_FOUND';
    }

    final String? code = barcodes[0].value.rawValue;

    if (code == null) {
      return 'NOT_FOUND';
    }

    // print(code);

    return code;
  }
}
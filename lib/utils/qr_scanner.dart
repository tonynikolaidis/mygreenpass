import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycovidpass/certificate_details_page.dart';

import 'package:mycovidpass/certificates_page.dart';
import 'package:mycovidpass/how_it_works_page.dart';
import 'package:mycovidpass/main.dart';
import 'package:mycovidpass/utils/decode_qr_code.dart';
import 'package:mycovidpass/utils/storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:country_codes/country_codes.dart';

import 'package:mycovidpass/utils/call_to_action_button.dart';
import 'package:mycovidpass/utils/extract_qr_code_data.dart';
import 'package:mycovidpass/utils/white_background_painter.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'blue_curve_painter.dart';
import 'constants.dart';
import 'navigation_bar_color.dart';

final cameraController = StateProvider((ref) => QRViewController);

class QrScanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  Barcode? result;
  QRViewController? controller;

  bool showErrorMessage = false;
  bool errorMessageIsVisible = false;

  bool flashIsEnabled = false;
  IconData flashIcon = Icons.flash_off_rounded;

  // bool saveButtonIsDisabled = false;
  bool saveButtonIsDisabled = true;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  void initState() {
    super.initState();
    // context.read(cameraController).state = controller;
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    var paddingBottom = MediaQuery.of(context).padding.bottom;
    var insetsBottom = MediaQuery.of(context).viewInsets.bottom;

    if (shouldSetBottomOffset) {
      shouldSetBottomOffset = false;
      if (paddingBottom > insetsBottom) bottomOffset = paddingBottom;
      else bottomOffset = insetsBottom;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 3.3 / 4,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Expanded(flex: 4, child: _buildQrView(context)),
                    ],
                  ),
                ),
              ]),
          CustomPaint(
            painter: BlueCurvePainter(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 1.17 / 4,
                  // decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.red)
                  // ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Spacer(),
                        Container(
                          height: 45,
                          width: 45,
                          child: FittedBox(
                            child: FloatingActionButton(
                              onPressed: () {
                                controller!.toggleFlash();
                                flashIsEnabled = !flashIsEnabled;

                                if (flashIsEnabled) {
                                  setState(() {
                                    flashIcon = Icons.flash_on_rounded;
                                  });
                                } else {
                                  setState(() {
                                    flashIcon = Icons.flash_off_rounded;
                                  });
                                }
                              },
                              child: Icon(
                                flashIcon,
                                size: 30,
                              ),
                              heroTag: 'flash',
                              elevation: 0,
                              highlightElevation: 0,
                              backgroundColor: COLOR_GLASS_WHITE,
                            ),
                          ),
                        ),
                        // SizedBox(height: MediaQuery.of(context).size.height * 0.2 / 10),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70),
                          child: Text(
                            'Scan the QR code on your COVID certificate.',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // SizedBox(height: MediaQuery.of(context).size.height * 0.15 / 10),
                        Spacer(),
                        MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HowItWorks()));
                          },
                          child: Text(
                            'How it works',
                            style: TextStyle(
                                color: Color.fromRGBO(182, 211, 255, 1),
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        Spacer(),
                        Container(
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.red)
                          // ),
                          child: SizedBox(
                            height: bottomOffset,
                          ),
                        )
                      ]),
                ),
              ],
            ),
          ),
          Visibility(
            visible: errorMessageIsVisible,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 1.75 / 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: COLOR_RED),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Text(
                      'Invalid QR code',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'RobotoMono',
                          fontSize: 16,
                          color: COLOR_RED),
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = MediaQuery.of(context).size.width * 6.5 / 10;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: COLOR_BLUE,
          borderRadius: 20,
          borderLength: 30,
          borderWidth: 15,
          overlayColor: Color.fromRGBO(255, 255, 255, 0.6),
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      processQr(scanData);
      setState(() {
        result = scanData;
      });
    });
  }

  processQr(Barcode qrcode) async {
    if (qrcode.format == BarcodeFormat.qrcode &&
        qrcode.code.substring(0, 4) == 'HC1:') {
      errorMessageIsVisible = false;

      controller!.pauseCamera();

      final data = ExtractQrCodeData.extract(qrcode.code);

      NavigationBarColor.changeTo('white');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CertificateDetailsPage(
                  title: 'Add certificate',
                  code: qrcode.code,
                  data: data,
                  save: true)));

      controller!.resumeCamera();

      // this.dispose();
    } else {
      // errorMessageIsVisible = true;

      // Timer(Duration(seconds: 2), () {
      //   context.read(errorMessageIsVisible).state = false;
      // });

      if (!showErrorMessage) {
        setState(() {
          showErrorMessage = true;
        });
        errorMessageIsVisible = true;

        Future.delayed(Duration(milliseconds: 2000), () {
          errorMessageIsVisible = false;
          setState(() {
            showErrorMessage = false;
          });
        });
      }

      return false;
    }
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class CertificateInfo extends StatelessWidget {
  final String header;
  final String body;

  const CertificateInfo({Key? key, required this.header, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 9 / 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'RobotoMono',
                color: COLOR_GRAY),
          ),
          Text(
            body,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

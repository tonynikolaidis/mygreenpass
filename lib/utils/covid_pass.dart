import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:mycovidpass/certificate_details_page.dart';
import 'package:mycovidpass/utils/extract_qr_code_data.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../certificates_page.dart';
import 'constants.dart';
import 'covid_pass_item.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CovidPass extends StatefulWidget {
  final String code;

  const CovidPass({Key? key, required this.code}) : super(key: key);

  @override
  _CovidPassState createState() => _CovidPassState();
}

class _CovidPassState extends State<CovidPass> {
  final GlobalKey globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var width = 8.5 / 10;
    var height = 0.7;

    final data = ExtractQrCodeData.extract(widget.code);

    var qrCodeSize = 170.0;
    var transformScale = 1.0;

    String header = 'EMPTY';

    String validUntil = '${data['expiresAt']}';

    String h0 = '';
    String c0 = '';
    String h1 = '';
    String c1 = '';
    String h2 = '';
    String c2 = '';

    bool isVisible = true;

    if (data.containsKey('v')) {
      header = 'VACCINATION';

      h0 = 'DATE OF VACCINATION';
      c0 = '${data['v']['dt']}';

      h1 = 'DOSES';
      c1 = '${data['v']['dn']}/${data['v']['sd']}';

      h2 = 'VACCINE';
      c2 = '${data['v']['mp']}';
    }
    else if (data.containsKey('t')) {
      header = 'TEST';

      h0 = 'DATE OF TEST';
      c0 = '${data['t']['sc'][0]}';

      h1 = 'RESULT';
      c1 = '${data['t']['tr'][0]}';

      h2 = 'TEST';
      c2 = '${data['t']['tt'][0]}';

      transformScale = 1.05;
    }
    else if (data.containsKey('r')) {
      header = 'RECOVERY';

      h0 = 'VALID FROM';
      c0 = '${data['r']['df']}';

      h1 = 'DATE OF TEST';
      c1 = '${data['r']['fr']}';

      validUntil = '${data['r']['du']}';

      isVisible = false;

      transformScale = 1.05;
    }

    var aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double spacing = 15;
    double qrPadding = 12;
    double qrPaddingRadius = 20;

    if (aspectRatio >= 9/16) {
      qrCodeSize = 128;
      spacing = 6;
      qrPadding = 8;
      qrPaddingRadius = 12;
    }

    double qrCodeEnlargedSize = 256;
    double transformScaleEnlarged = MediaQuery.of(context).size.width * 0.75 / 256;
    double qrPaddingEnlarged = 16; // MediaQuery.of(context).size.width * 0.05;

    return FractionallySizedBox(
      heightFactor: 0.7, // 0.70,
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 5,
              blurRadius: 30,
              offset: Offset(0, 15),
            ),
          ],
          // border: Border.all(color: Colors.red)
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CertificateDetailsPage(
                        title: 'Details',
                        code: widget.code,
                        data: ExtractQrCodeData.extract(widget.code),
                        save: false)));
          },
          child: GlassmorphicContainer(
            height: MediaQuery.of(context).size.height, // * height,
            width: MediaQuery.of(context).size.width,
            blur: 10, // 15,
            linearGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [COLOR_GLASS_WHITE, COLOR_GLASS_WHITE]),
            borderGradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [COLOR_BORDER_WHITE, COLOR_BORDER_WHITE]),
            border: 1,
            borderRadius: 30,
            child: Center(
              child: FractionallySizedBox(
                alignment: Alignment.center,
                heightFactor: 0.90,
                widthFactor: 0.95,
                child: Container(
                  // height: MediaQuery.of(context).size.height * height * 2.5 / 3, // - 44,
                  // width: MediaQuery.of(context).size.width * width - 20,
                  decoration: BoxDecoration(
                      // border: Border.all(color: Colors.red, width: 1)
                      ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.blue)
                            ),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: COLOR_YELLOW,
                                      borderRadius:
                                          BorderRadius.circular(30)),
                                  // width: double.infinity,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                              // height: 30,
                                              // width: 30,
                                              child: SvgPicture.asset('assets/european_union_logo.svg', height: 30),
                                              // child: Image(
                                              //   image: AssetImage(
                                              //       'assets/european_union_logo.png'),
                                              // )
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              header + ' CERTIFICATE',
                                              softWrap: true,
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'RobotoMono',
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.blue)
                                  ),
                              child: CovidPassItem(
                                  header: 'STATE',
                                  body: '${data['country']}',
                                  alignment: CrossAxisAlignment.center,
                                  textAlign: TextAlign.center),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: spacing, // 15
                      ),
                      Container(
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.blue)
                            ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CovidPassItem(
                                header: 'SURNAME/NAME',
                                body:
                                    '${data['lastNameT']} ${data['firstNameT']}',
                                alignment: CrossAxisAlignment.start,
                                textAlign: TextAlign.start),
                            Spacer(),
                            CovidPassItem(
                              header: 'DATE OF BIRTH',
                              body: '${data['dateOfBirth']}',
                              alignment: CrossAxisAlignment.end,
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: spacing,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.blue)
                            ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CovidPassItem(
                                header: h0,
                                body: c0,
                                alignment: CrossAxisAlignment.start,
                                textAlign: TextAlign.start),
                            Spacer(),
                            CovidPassItem(
                                header: 'VALID UNTIL',
                                body: validUntil,
                                alignment: CrossAxisAlignment.end,
                                textAlign: TextAlign.end),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: spacing,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.blue)
                            ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CovidPassItem(
                                header: h1,
                                body: c1,
                                alignment: CrossAxisAlignment.start,
                                textAlign: TextAlign.start),
                            Spacer(),
                            Visibility(
                              visible: isVisible,
                              child: CovidPassItem(
                                  header: h2,
                                  body: c2,
                                  alignment: CrossAxisAlignment.end,
                                  textAlign: TextAlign.end),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(qrPaddingRadius)), // 20
                                child: Padding(
                                  padding: EdgeInsets.all(qrPadding), // 12.0
                                  child: InkWell(
                                    onTap: () {
                                      showCupertinoDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoPopupSurface(
                                                isSurfacePainted: false,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Transform.scale(
                                                      scale: transformScaleEnlarged,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(qrPaddingEnlarged),
                                                          child: Transform.scale(
                                                            scale: transformScale,
                                                            child: QrImage(
                                                              data: widget.code,
                                                              version: QrVersions.auto,
                                                              size: qrCodeEnlargedSize,
                                                              padding: const EdgeInsets.all(0.0),
                                                              // backgroundColor: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                        barrierDismissible: true,
                                      );
                                    },
                                    child: Transform.scale(
                                      scale: transformScale,
                                      child: QrImage(
                                        data: widget.code,
                                        version: QrVersions.auto,
                                        // size: (MediaQuery.of(context).size.height * height - 80) * 0.350, // 0.51
                                        errorCorrectionLevel: QrErrorCorrectLevel.L,
                                        size: qrCodeSize, // 0.51 170
                                        padding: const EdgeInsets.all(0.0),
                                      ),
                                    ),
                                    // child: FutureBuilder<Uint8List>(
                                    //   future: imageBytes,
                                    //   builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
                                    //     if (!snapshot.hasData) {
                                    //       // while data is loading:
                                    //       return Center(
                                    //         child: CircularProgressIndicator(),
                                    //       );
                                    //     } else {
                                    //       // data loaded:
                                    //       final data = snapshot.data;
                                    //       return RepaintBoundary(
                                    //         child: Container(
                                    //           width: 170,
                                    //           height: 170,
                                    //           child: Image.memory(data!),
                                    //       ));
                                    //     }
                                    //   },
                                    // ),
                                  ),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

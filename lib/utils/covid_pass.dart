import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:mycovidpass/certificate_details_page.dart';
import 'package:mycovidpass/utils/extract_qr_code_data.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../certificates_page.dart';
import 'constants.dart';
import 'covid_pass_item.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// final qrCodeIsEnlarged = StateProvider((ref) => false);
// final qrCodeEnlargedStreamProvider =
//     StreamProvider.autoDispose<bool>((ref) async* {
//   yield ref.read(qrCodeIsEnlarged).state;
// });

class CovidPass extends StatefulWidget {
  final String code;

  const CovidPass({Key? key, required this.code}) : super(key: key);

  @override
  _CovidPassState createState() => _CovidPassState();
}

class _CovidPassState extends State<CovidPass> {
  @override
  Widget build(BuildContext context) {
    var width = 8.5 / 10;
    var height = context.read(heightModifier).state;

    final data = ExtractQrCodeData.extract(widget.code);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 30,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: Stack(children: [
        InkWell(
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
            height: MediaQuery.of(context).size.height * height,
            width: MediaQuery.of(context).size.width * width,
            blur: 10,
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
            child: Container(
              height: MediaQuery.of(context).size.height * height,
              width: MediaQuery.of(context).size.width * width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * height - 40,
                    width: MediaQuery.of(context).size.width * width - 20,
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
                                                height: 30,
                                                width: 30,
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/european_union_logo.png'),
                                                )),
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
                                                'VACCINATION CERTIFICATE',
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
                          height: 15,
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
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              // border: Border.all(color: Colors.blue)
                              ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CovidPassItem(
                                  header: 'DATE OF VACCINATION',
                                  body: '${data['v']['dt']}',
                                  alignment: CrossAxisAlignment.start,
                                  textAlign: TextAlign.start),
                              Spacer(),
                              CovidPassItem(
                                  header: 'VALID UNTIL',
                                  body: '${data['expiresAt']}',
                                  alignment: CrossAxisAlignment.end,
                                  textAlign: TextAlign.end),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              // border: Border.all(color: Colors.blue)
                              ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CovidPassItem(
                                  header: 'DOSES',
                                  body: '${data['v']['dn']}/${data['v']['sd']}',
                                  alignment: CrossAxisAlignment.start,
                                  textAlign: TextAlign.start),
                              Spacer(),
                              CovidPassItem(
                                  header: 'VACCINE',
                                  body: '${data['v']['mp']}',
                                  alignment: CrossAxisAlignment.end,
                                  textAlign: TextAlign.end),
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
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
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
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                                                          child: QrImage(
                                                            data: widget.code,
                                                            version: QrVersions.auto,
                                                            size: MediaQuery.of(context).size.width * 0.75,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          barrierDismissible: true,
                                        );
                                      },
                                      child: QrImage(
                                        data: widget.code,
                                        version: QrVersions.auto,
                                        // size: (MediaQuery.of(context).size.width - 20) * 0.5, // 0.51
                                        size: 170, // 0.51
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Visibility(
        //   visible: context.read(qrCodeIsEnlarged).state,
        //   child: Container(
        //     width: MediaQuery.of(context).size.width * width,
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         InkWell(
        //           onTap: () {
        //             // translationController.reverse();
        //             // scalingController.reverse().whenComplete(() {
        //             // });
        //             context.read(qrCodeIsEnlarged).state = false;
        //           },
        //           child: Container(
        //             height: 300,
        //             width: 300,
        //             decoration: BoxDecoration(
        //                 border: Border.all(color: Colors.transparent),
        //                 borderRadius: BorderRadius.circular(30)),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // )
      ]),
    );
  }
}

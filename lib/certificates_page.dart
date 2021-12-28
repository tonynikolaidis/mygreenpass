import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:mycovidpass/scan_qr_code_page.dart';
import 'package:mycovidpass/utils/blue_curve_white_background_painter.dart';
import 'package:mycovidpass/utils/call_to_action_button.dart';
import 'package:mycovidpass/utils/covid_pass.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:mycovidpass/utils/storage.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mycovidpass/utils/white_background_painter.dart';

import 'about_page.dart';
import 'main.dart';
import 'utils/constants.dart';
import 'utils/navigation_bar_color.dart';

import 'package:url_launcher/url_launcher.dart';

final heightModifier = StateProvider((ref) => 0.7);

class CertificatesPage extends StatefulWidget {
  const CertificatesPage({Key? key}) : super(key: key);

  @override
  _CertificatesPageState createState() => _CertificatesPageState();
}

class _CertificatesPageState extends State<CertificatesPage> {
  @override
  Widget build(BuildContext context) {
    NavigationBarColor.changeTo('blue');

    var height = context.read(heightModifier).state;

    var topOffset = MediaQuery.of(context).padding.top;

    var paddingBottom = MediaQuery.of(context).padding.bottom;
    var insetsBottom = MediaQuery.of(context).viewInsets.bottom;

    if (shouldSetBottomOffset) {
      shouldSetBottomOffset = false;
      if (paddingBottom > insetsBottom)
        bottomOffset = paddingBottom;
      else
        bottomOffset = insetsBottom;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomPaint(
        painter: BlueCurveWhiteBackgroundPainter(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SafeArea(
            top: true,
            bottom: true,
            child: Stack(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height -
                          (topOffset + bottomOffset),
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.red)
                      // ),
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          enlargeCenterPage: false,
                          enableInfiniteScroll: false,
                          viewportFraction: 0.88,
                          height: MediaQuery.of(context).size.height * height,
                        ),
                        itemCount: Storage.numberOfCertificates,
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            CovidPass(code: Storage.certificates![itemIndex]),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height -
                    (topOffset + bottomOffset),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 18, top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/app_icon_white.png'),
                            height: 45, // previously 60
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 9),
                            child: Text(
                              'myCovidPass',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 25), // previously 35
                              textScaleFactor: 1.0,
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 45,
                            width: 45,
                            child: FittedBox(
                              child: FloatingActionButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage(),
                                  ));
                                },
                                heroTag: 'info',
                                child:
                                    Icon(Icons.info_outline_rounded, size: 30),
                                backgroundColor: Colors.white,
                                foregroundColor: COLOR_BLACK,
                                // splashColor: Color.fromRGBO(0, 0, 0, 0),
                                elevation: 0,
                                highlightElevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16, bottom: 16),
                          child: Container(
                            // height: MediaQuery.of(context).size.width, // 65
                            // width: MediaQuery.of(context).size.width, // 65
                            child: FittedBox(
                              child: CallToActionButton(
                                extended: false,
                                icon: Icon(
                                  Icons.add_rounded,
                                  // size: 30,
                                ),
                                heroTag: 'add_certificate',
                                label: 'Add',
                                disabled: false,
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ScanQrCodePage()));
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
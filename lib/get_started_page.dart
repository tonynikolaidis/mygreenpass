import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycovidpass/utils/call_to_action_button.dart';
import 'package:mycovidpass/utils/blue_curve_white_background_painter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'about_page.dart';
import 'utils/constants.dart';
import 'scan_qr_code_page.dart';
import 'utils/navigation_bar_color.dart';

class GetStartedPage extends StatefulWidget {
  GetStartedPage({Key? key}) : super(key: key);

  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  Widget build(BuildContext context) {
    NavigationBarColor.changeTo('blue');

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Container(
          height: 45,
          width: 45,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutPage()));
              },
              heroTag: 'info',
              child: Icon(Icons.info_outline_rounded, size: 30),
              backgroundColor: Colors.white,
              foregroundColor: COLOR_BLACK,
              // splashColor: Color.fromRGBO(0, 0, 0, 0),
              elevation: 0,
              highlightElevation: 0,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      resizeToAvoidBottomInset: false,
      body: CustomPaint(
        painter: BlueCurveWhiteBackgroundPainter(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 2.5 / 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/app_icon_white.png'),
                  height: 55, // previously 80
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    'myCovidPass',
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 30), // previously 35
                    textScaleFactor: 1.0,
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 1.5 / 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Add certificate',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: COLOR_BLUE),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Add your Digital Covid Certificate to myCovidPass by scanning its QR code.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Spacer(),
            CallToActionButton(
                extended: true,
                disabled: false,
                heroTag: 'scan_qr_code',
                label: 'Scan QR code',
                icon: Icon(Icons.qr_code_scanner_rounded),
                onPressed: () async {
                  var status = await Permission.camera.request();
                  print(status.toString());

                  if (status.isGranted) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ScanQrCodePage()));
                  }
                }),
            SizedBox(
              height: MediaQuery.of(context).size.height * 2.6 / 10,
            ),
          ],
        ),
      ),
    );
  }
}

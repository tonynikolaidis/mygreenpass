import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mygreenpass/utils/scan_qr_code_from_file.dart';
import 'certificate_details_page.dart';
import 'utils/call_to_action_button.dart';
import 'utils/blue_curve_white_background_painter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'about_page.dart';
import 'utils/constants.dart';
import 'scan_qr_code_page.dart';
import 'utils/extract_qr_code_data.dart';
import 'utils/navigation_bar_color.dart';
import 'package:flutter_svg/flutter_svg.dart';


class GetStartedPage extends StatefulWidget {
  GetStartedPage({Key? key}) : super(key: key);

  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    NavigationBarColor.changeTo('blue');

    return LoadingOverlay(
      isLoading: loading,
      color: Colors.black,
      opacity: 0.4,
      progressIndicator: CircularProgressIndicator(color: Colors.white,),
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            height: 56,
            width: 56,
            child: FittedBox(
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutPage()));
                },
                heroTag: 'info',
                child: Icon(Icons.info_outline_rounded, size: 25),
                backgroundColor: Colors.transparent,
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
                  SvgPicture.asset('assets/logo.svg', semanticsLabel: 'App logo', width: MediaQuery.of(context).size.width * 0.6,),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 1.5 / 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.17),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                      'Add your Digital Green Certificate to myGreenPass by scanning its QR code or by importing it from the file system.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                height: MediaQuery.of(context).size.height * 3.1 / 10,
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.red, width: 1)
                // ),
                child: Column(
                  children: [
                    CallToActionButton(
                        extended: true,
                        disabled: false,
                        heroTag: 'scan_qr_code',
                        label: 'Scan QR code',
                        icon: Icon(Icons.qr_code_scanner_rounded),
                        onPressed: () async {
                          var status = await Permission.camera.request();
                          // print(status.toString());

                          if (status.isGranted) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ScanQrCodePage()));
                          }
                        }),
                    Spacer(),
                    Text('OR', style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w500),),
                    Spacer(),
                    CallToActionButton(
                        extended: true,
                        disabled: false,
                        heroTag: 'import_file',
                        label: 'Import file',
                        icon: Icon(Icons.insert_drive_file_outlined),
                        onPressed: () async {
                          FilePickerResult? result = await ScanQrCodeFromFile.pickFile();

                          if (result == null) {
                            return;
                          }

                          setState(() {
                            loading = true;
                          });

                          String code = await ScanQrCodeFromFile.scan(result);

                          setState(() {
                            loading = false;
                          });

                          if (code.substring(0, 4) == 'HC1:') {
                            final data = ExtractQrCodeData.extract(code);

                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    CertificateDetailsPage(
                                        title: 'Add certificate',
                                        code: code,
                                        data: data,
                                        save: true)));
                          } else {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => ScanQrCodeFromFile.importFailed(context),
                            );
                          }
                        }),
                    Spacer(),
                    Spacer(),
                    Spacer(),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 1.8 / 10, // 2.6
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

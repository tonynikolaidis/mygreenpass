import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'utils/navigation_bar_color.dart';
import 'utils/recovery_details.dart';
import 'utils/test_details.dart';
import 'utils/vaccination_details.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'certificates_page.dart';
import 'get_started_page.dart';
import 'main.dart';
import 'utils/call_to_action_button.dart';
import 'utils/constants.dart';
import 'utils/qr_scanner.dart';
import 'utils/storage.dart';
import 'utils/white_background_painter.dart';

import 'package:flutter_linkify/flutter_linkify.dart';

class CertificateDetailsPage extends ConsumerWidget {
  final title;
  final code;
  final data;
  final bool save;

  CertificateDetailsPage(
      {Key? key,
      required this.title,
      required this.code,
      required this.data,
      required this.save})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late Widget button;
    NavigationBarColor.changeTo('white');

    List<String>? codes = Storage.getItem('codes');

    if (save) {
      button = CallToActionButton(
          extended: true,
          disabled: codes!.contains(code),
          heroTag: 'save',
          label: 'Save',
          icon: Icon(Icons.check_rounded),
          onPressed: () async {
            if (!codes.contains(code)) {
              codes.add(code);
              await Storage.setItem('codes', codes);

              ref.refresh(certificates);

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => CertificatesPage()),
                  (route) => route.isCurrent);

              NavigationBarColor.changeTo('blue');
            }
          });
    } else {
      button = CallToActionButton(
          extended: true,
          disabled: false,
          heroTag: 'delete',
          label: 'Delete',
          icon: Icon(Icons.clear_rounded),
          onPressed: () => {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(
                      'Delete certificate',
                      style: TextStyle(color: COLOR_BLUE, fontSize: 24.0),
                    ),
                    content: Text(
                      'Are you sure you want to delete this certificate?',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    backgroundColor: Colors.white,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => COLOR_BLACK_SPLASH),
                        ),
                        child: Text('Cancel',
                            style:
                                TextStyle(color: Colors.black, fontSize: 16.0)),
                      ),
                      TextButton(
                        onPressed: () async {
                          List<String>? codes = Storage.getItem('codes');

                          if (codes!.contains(code)) {
                            codes.remove(code);
                            await Storage.setItem('codes', codes);

                            if (codes.length == 0) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GetStartedPage()),
                                  (route) => route.isCurrent);

                              NavigationBarColor.changeTo('blue');
                            } else {
                              // Navigator.pushAndRemoveUntil(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => CertificatesPage()),
                              //     (route) => route.isCurrent);

                              Navigator.pop(context);
                              Navigator.pop(context);
                            }

                            ref.refresh(certificates);
                          }
                        },
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => COLOR_RED_SPLASH_LIGHT),
                        ),
                        child: Text('Delete',
                            style: TextStyle(color: COLOR_RED, fontSize: 16.0)),
                      ),
                    ],
                  ),
                )
              });
    }

    String header = 'EMPTY';
    var scaleFactor = 1.0;

    if (data.containsKey('v')) {
      header = 'VACCINATION';
    } else if (data.containsKey('t')) {
      header = 'TEST';
      scaleFactor = 1.05;
    } else if (data.containsKey('r')) {
      header = 'RECOVERY';
      scaleFactor = 1.05;
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        NavigationBarColor.changeTo('blue');

        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: COLOR_BLUE),
          leading: new IconButton(
              onPressed: () {
                Navigator.pop(context);
                NavigationBarColor.changeTo('blue');
              },
              icon: Icon(Icons.arrow_back)),
          bottom: PreferredSize(
            child: Container(
              color: COLOR_BLUE,
              height: 1,
            ),
            preferredSize: Size.fromHeight(1),
          ),
        ),
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false,
        body: CustomPaint(
          painter: WhiteBackgroundPainter(),
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                primary: false,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Transform.scale(
                          scale: scaleFactor,
                          child: QrImage(
                            data: code,
                            version: QrVersions.auto,
                            size: 170,
                            padding: const EdgeInsets.all(0.0),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        data['lastNameT'] +
                            ' ' +
                            data['firstNameT'],
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: COLOR_BLUE),
                      ),
                      Text(
                        data['dateOfBirth'],
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ColoredBox(
                        color: COLOR_YELLOW,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 15),
                                Text(
                                  header + ' CERTIFICATE',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'RobotoMono',
                                      color: Colors.white),
                                ),
                                SizedBox(height: 15),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildCertificateDetails(data),
                      Container(
                        width: MediaQuery.of(context).size.width * 90 / 100,
                        decoration: BoxDecoration(
                            color: COLOR_GLASS_PURPLE,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 5 / 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'This certificate is not a travel document.\n',
                                  style: TextStyle(fontSize: 16)),
                              // Text(
                              //     'The scientific evidence on COVID-19 vaccination, testing and recovery continues to evolve, including with regard to new virus variants of concern.\n',
                              //     style: TextStyle(fontSize: 16)),
                              Text(
                                  'Before travelling, please check the applicable public health measure and related restrictions applicable at the point of destination.\n',
                                  style: TextStyle(fontSize: 16)),
                              Linkify(
                                onOpen: (link) async {
                                  if (await canLaunch(link.url)) {
                                    await launch(link.url);
                                  } else {
                                    throw 'Could not launch $link';
                                  }
                                },
                                text: "Relevant information can be found here:\nhttps://reopen.europa.eu/en",
                                style: TextStyle(fontSize: 16),
                                linkStyle: TextStyle(fontSize: 16, color: COLOR_BLUE),
                                options: LinkifyOptions(humanize: false),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      SizedBox(height: 32 // bottomOffset,
                          ),
                    ],
                  )
                ],
              )),
        ),
        floatingActionButton: button,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget buildCertificateDetails(Map data) {
    if (data.containsKey('v')) {
      return VaccinationDetails(data: data);

    } else if (data.containsKey('t')) {
      return TestDetails(data: data);

    } else if (data.containsKey('r')) {
      return RecoveryDetails(data: data);
    }

    return Column();
  }
}

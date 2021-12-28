import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycovidpass/utils/navigation_bar_color.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'certificates_page.dart';
import 'get_started_page.dart';
import 'utils/call_to_action_button.dart';
import 'utils/constants.dart';
import 'utils/qr_scanner.dart';
import 'utils/storage.dart';
import 'utils/white_background_painter.dart';

class CertificateDetailsPage extends StatefulWidget {
  final title;
  final code;
  final data;
  final bool save;

  const CertificateDetailsPage(
      {Key? key,
      required this.title,
      required this.code,
      required this.data,
      required this.save})
      : super(key: key);

  @override
  _CertificateDetailsPageState createState() => _CertificateDetailsPageState();
}

class _CertificateDetailsPageState extends State<CertificateDetailsPage> {
  bool saveButtonIsDisabled = false;
  late Widget button;

  @override
  Widget build(BuildContext context) {
    NavigationBarColor.changeTo('white');

    List<String>? codes = Storage.getItem('codes');
    setState(() {
      saveButtonIsDisabled = codes!.contains(widget.code);
    });

    if (widget.save) {
      button = CallToActionButton(
          extended: true,
          disabled: saveButtonIsDisabled,
          heroTag: 'save',
          label: 'Save',
          icon: Icon(Icons.check_rounded),
          onPressed: () async {
            if (!codes!.contains(widget.code)) {
              codes.add(widget.code);
              await Storage.setItem('codes', codes);

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
          onPressed: () async {
            List<String>? codes = Storage.getItem('codes');

            if (codes!.contains(widget.code)) {
              codes.remove(widget.code);
              await Storage.setItem('codes', codes);

              if (codes.length == 0) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => GetStartedPage()),
                    (route) => route.isCurrent);

                NavigationBarColor.changeTo('blue');
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => CertificatesPage()),
                    (route) => route.isCurrent);
              }
            }
          });
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
            widget.title,
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
                      QrImage(
                        data: widget.code,
                        version: QrVersions.auto,
                        size: 200,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.data['lastNameT'] +
                            ' ' +
                            widget.data['firstNameT'],
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: COLOR_BLUE),
                      ),
                      Text(
                        widget.data['dateOfBirth'],
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
                                  'VACCINATION CERTIFICATE',
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
                      CertificateInfo(
                        header: 'DISEASE OR AGENT TARGETED',
                        body: widget.data['v']['tg'],
                      ),
                      CertificateInfo(
                        header: 'COVID-19 VACCINE OR PROPHYLAXIS',
                        body: widget.data['v']['vp'],
                      ),
                      CertificateInfo(
                        header: 'COVID-19 VACCINE MEDICINAL PRODUCT',
                        body: widget.data['v']['mp'],
                      ),
                      CertificateInfo(
                        header:
                            'COVID-19 VACCINE MARKETING AUTHORISATION HOLDER OR MANUFACTURER',
                        body: widget.data['v']['ma'],
                      ),
                      CertificateInfo(
                        header: 'DOSES',
                        body:
                            widget.data['v']['dn'] + '/' + widget.data['v']['sd'],
                      ),
                      CertificateInfo(
                        header: 'DATE OF VACCINATION',
                        body: widget.data['v']['dt'],
                      ),
                      CertificateInfo(
                        header:
                            'MEMBER STATE IN WHICH THE VACCINE WAS ADMINISTERED',
                        body: CountryCodes.detailsForLocale(Locale.fromSubtags(
                                countryCode: widget.data['v']['co']))
                            .localizedName
                            .toString(),
                      ),
                      CertificateInfo(
                        header: 'CERTIFICATE ISSUER',
                        body: widget.data['v']['iss'],
                      ),
                      CertificateInfo(
                        header: 'UNIQUE CERTIFICATE IDENTIFIER',
                        body: widget.data['v']['ci'],
                      ),
                      SizedBox(
                        height: 60,
                      )
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
}

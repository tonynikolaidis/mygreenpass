import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';

import 'qr_scanner.dart';

class TestDetails extends StatelessWidget {
  final Map data;

  const TestDetails({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(data);

    bool testName = true;
    if (data['t']['nm'] == null) {
      testName = false;
      data['t']['nm'] = '';
    }

    bool testManufacturer = true;
    if (data['t']['ma'] == null) {
      testManufacturer = false;
      data['t']['ma'] = '';
    }

    bool testPlace = true;
    if (data['t']['tr'] == null) {
      testName = false;
      data['t']['tr'] = '';
    }

    return Column(
      children: [
        CertificateInfo(
          header: 'DISEASE OR AGENT TARGETED',
          body: data['t']['tg'],
        ),
        CertificateInfo(
          header: 'TYPE OF TEST',
          body: data['t']['tt'][1],
        ),
        Visibility(
          visible: testName,
          child: CertificateInfo(
            header: 'TEST NAME',
            body: data['t']['nm'],
          ),
        ),
        Visibility(
          visible: testManufacturer,
          child: CertificateInfo(
            header:
            'TEST MANUFACTURER',
            body: data['t']['ma'],
          ),
        ),
        CertificateInfo(
          header: 'DATE AND TIME OF THE TEST SAMPLE COLLECTION',
          body: data['t']['sc'][1],
        ),
        CertificateInfo(
          header: 'RESULT OF THE TEST',
          body: data['t']['tr'][1],
        ),
        Visibility(
          visible: testPlace,
          child: CertificateInfo(
            header: 'TESTING CENTRE OR FACILITY',
            body: data['t']['tc'],
          ),
        ),
        CertificateInfo(
          header: 'MEMBER STATE IN WHICH THE TEST WAS CARRIED OUT',
          body: CountryCodes.detailsForLocale(
              Locale.fromSubtags(countryCode: data['t']['co']))
              .localizedName
              .toString(),
        ),
        CertificateInfo(
          header: 'CERTIFICATE ISSUER',
          body: data['t']['is'],
        ),
        CertificateInfo(
          header: 'DATE OF ISSUE',
          body: data['issuedAt'],
        ),
        CertificateInfo(
          header: 'UNIQUE CERTIFICATE IDENTIFIER',
          body: data['t']['ci'],
        ),
      ],
    );
  }
}

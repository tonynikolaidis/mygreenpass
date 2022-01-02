import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';

import 'qr_scanner.dart';

class RecoveryDetails extends StatelessWidget {
  final Map data;

  const RecoveryDetails({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CertificateInfo(
          header: 'DISEASE OR AGENT FROM WHICH THE HOLDER HAS RECOVERED',
          body: data['r']['tg'],
        ),
        CertificateInfo(
          header: 'DATE OF THE HOLDER\'S POSITIVE NAAT TEST RESULT',
          body: data['r']['fr'],
        ),
        CertificateInfo(
          header: 'MEMBER STATE IN WHICH THE TEST WAS CARRIED OUT',
          body: CountryCodes.detailsForLocale(
              Locale.fromSubtags(countryCode: data['r']['co']))
              .localizedName
              .toString(),
        ),
        CertificateInfo(
          header: 'CERTIFICATE ISSUER',
          body: data['r']['is'],
        ),
        CertificateInfo(
          header: 'CERTIFICATE VALID FROM',
          body: data['r']['df'],
        ),
        CertificateInfo(
          header: 'CERTIFICATE VALID UNTIL',
          body: data['r']['du'],
        ),
        CertificateInfo(
          header: 'DATE OF ISSUE',
          body: data['issuedAt'],
        ),
        CertificateInfo(
          header: 'UNIQUE CERTIFICATE IDENTIFIER',
          body: data['r']['ci'],
        ),
      ],
    );
  }
}

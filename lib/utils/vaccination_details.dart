import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';

import 'qr_scanner.dart';

class VaccinationDetails extends StatelessWidget {
  final Map data;

  const VaccinationDetails({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(data);

    return Column(
      children: [
        CertificateInfo(
          header: 'DISEASE OR AGENT TARGETED',
          body: data['v']['tg'],
        ),
        CertificateInfo(
          header: 'COVID-19 VACCINE OR PROPHYLAXIS',
          body: data['v']['vp'],
        ),
        CertificateInfo(
          header: 'COVID-19 VACCINE MEDICINAL PRODUCT',
          body: data['v']['mp'],
        ),
        CertificateInfo(
          header:
          'COVID-19 VACCINE MARKETING AUTHORISATION HOLDER OR MANUFACTURER',
          body: data['v']['ma'],
        ),
        CertificateInfo(
          header: 'DOSES',
          body: data['v']['dn'] + '/' + data['v']['sd'],
        ),
        CertificateInfo(
          header: 'DATE OF VACCINATION',
          body: data['v']['dt'],
        ),
        CertificateInfo(
          header: 'MEMBER STATE IN WHICH THE VACCINE WAS ADMINISTERED',
          body: CountryCodes.detailsForLocale(
              Locale.fromSubtags(countryCode: data['v']['co']))
              .localizedName
              .toString(),
        ),
        CertificateInfo(
          header: 'CERTIFICATE ISSUER',
          body: data['v']['is'],
        ),
        CertificateInfo(
          header: 'DATE OF ISSUE',
          body: data['issuedAt'],
        ),
        CertificateInfo(
          header: 'UNIQUE CERTIFICATE IDENTIFIER',
          body: data['v']['ci'],
        ),
      ],
    );
  }
}

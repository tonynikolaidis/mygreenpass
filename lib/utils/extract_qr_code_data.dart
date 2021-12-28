import 'package:intl/intl.dart';

import 'decode_qr_code.dart';

class ExtractQrCodeData {
  static extract(String qrCode) {
    final Map data = DecodeQrCode.decodeQrCode(qrCode);

    var issuedAt = DateFormat('y-MM-dd')
        .format(DateTime.fromMillisecondsSinceEpoch((data[6] ?? 0) * 1000))
        .toString();
    var expiresAt = DateFormat('y-MM-dd')
        .format(DateTime.fromMillisecondsSinceEpoch((data[4] ?? 0) * 1000))
        .toString();
    var country = data[1];

    Map certificateInfo = data[-260][1];

    var version = certificateInfo['ver'];

    var names = certificateInfo['nam'];
    var firstName = names['gn'];
    var lastName = names['fn'];
    var firstNameT = names['gnt'];
    var lastNameT = names['fnt'];
    var dateOfBirth = certificateInfo['dob'];

    String key = 'none';
    Map details = new Map();

    if (certificateInfo.containsKey('v')) {
      details = decodeVaccine(certificateInfo['v'][0]);
      key = 'v';
    }
    // else if (certificateInfo.containsKey('t')) {
    //   details = decodeTest(certificateInfo['t'][0]);
    //   key = 't';
    // }

    var decodedData = {
      'firstName': firstName,
      'lastName': lastName,
      'firstNameT': firstNameT,
      'lastNameT': lastNameT,
      'dateOfBirth': dateOfBirth,
      'version': version,
      'issuedAt': issuedAt,
      'expiresAt': expiresAt,
      'country': country,
      key: details,
    };

    return decodedData;
  }

  static Map decodeVaccine(Map map) {
    String vp = map['vp'];

    switch (vp) {
      case '1119305005':
        vp = 'SARS-CoV2 antigen vaccine';
        break;
      case '1119349007':
        vp = 'SARS-CoV2 mRNA vaccine';
        break;
      case 'J07BX03':
        vp = 'covid-19 vaccines';
        break;
      case 'CVnCoV':
          vp = 'CVnCoV';
          break;
      case 'NVX-CoV2373':
          vp = 'NVX-CoV2373';
          break;
      case 'Sputnik-V':
          vp = 'Sputnik V';
          break;
      case 'Convidecia':
          vp = 'Convidecia';
          break;
      case 'EpiVacCorona':
          vp = 'EpiVacCorona';
          break;
      case 'BBIBP-CorV':
          vp = 'BBIBP-CorV';
          break;
      case 'Inactivated-SARS-CoV-2-Vero-Cell':
          vp = 'Inactivated SARS-CoV-2 (Vero Cell)';
          break;
      case 'CoronaVac':
          vp = 'CoronaVac';
          break;
      case 'Covaxin':
          vp = 'Covaxin (also known as BBV152 A, B, C)';
          break;
    }

    String mp = map['mp'];

    switch (mp) {
      case 'EU/1/20/1528':
        mp = 'Comirnaty';
        break;
      case 'EU/1/20/1507':
        mp = 'COVID-19 Vaccine Moderna';
        break;
      case 'EU/1/21/1529':
        mp = 'Vaxzevria';
        break;
      case 'EU/1/20/1525':
        mp = 'COVID-19 Vaccine Janssen';
        break;
    }

    String ma = map['ma'];

    switch (ma) {
      case 'ORG-100001699':
        ma = 'AstraZeneca AB';
        break;
      case 'ORG-100030215':
        ma = 'Biontech Manufacturing GmbH';
        break;
      case 'ORG-100001417':
        ma = 'Janssen-Cilag International';
        break;
      case 'ORG-100031184':
        ma = 'Moderna Biotech Spain S.L.';
        break;
      case 'ORG-100006270':
        ma = 'Curevac AG';
        break;
      case 'ORG-100013793':
        ma = 'CanSino Biologics';
        break;
      case 'ORG-100020693':
        ma = 'China Sinopharm International Corp. - Beijing location';
        break;
      case 'ORG-100010771':
        ma = 'Sinopharm Weiqida Europe Pharmaceutical s.r.o. - Prague location';
        break;
      case 'ORG-100024420':
        ma = 'Sinopharm Zhijun (Shenzhen) Pharmaceutical Co. Ltd. - Shenzhen location';
        break;
      case 'Gamaleya-Research-Institute':
        ma = 'Gamaleya Research Institute';
        break;
      case 'Vector-Institute':
        ma = 'Vector Institute';
        break;
      case 'Sinovac-Biotech':
        ma = 'Sinovac Biotech';
        break;
      case 'Bharat-Biotech':
        ma = 'Bharat Biotech';
        break;
    }

    return {
      'tg': map['tg'].toString() == '840539006' ? 'COVID-19' : 'Unknown', // agent targeted
      'vp': vp, // vaccine or prophylaxis
      'mp': mp, // medicinal product
      'ma': ma, // manufacturer
      'dn': map['dn'].toString(), // doses done
      'sd': map['sd'].toString(), // doses required
      'dt': map['dt'], // date of last dose
      'co': map['co'], // country
      'iss': map['is'], // certificate issuer
      'ci': map['ci'], // certificate identifier
    };
  }

// static Map decodeTest(Map map) {
//   return {
//     'tg': map['tg'], // agent targeted
//     'tt': map['cp'], // test type
//     'nm': map['mp'], // test name
//     'ma': map['ma'], // manufacturer
//     'dn': map['dn'], // doses done
//     'sd': map['sd'], // doses required
//     'dt': map['dt'], // date of last dose
//     'co': map['co'], // country
//     'iss': map['is'], // certificate issuer
//     'ci': map['ci'], // certificate identifier
//   };
// }
}

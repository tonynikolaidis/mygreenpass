import 'package:intl/intl.dart';
import 'package:mycovidpass/main.dart';

import 'decode_qr_code.dart';

class ExtractQrCodeData {
  static extract(String qrCode) {
    final Map data = DecodeQrCode.decodeQrCode(qrCode);

    String dateFormat = 'dd.MM.y'; // 'y-MM-dd'

    var issuedAt = DateFormat(dateFormat)
        .format(DateTime.fromMillisecondsSinceEpoch((data[6] * 1000 ?? 0)))
        .toString();
    var expiresAt = DateFormat(dateFormat)
        .format(DateTime.fromMillisecondsSinceEpoch((data[4] ?? 0) * 1000))
        .toString();
    var country = data[1];

    Map certificateInfo = data[-260][1];

    var version = certificateInfo['ver'];

    var names = certificateInfo['nam'];
    var firstName = names['gn'];
    var lastName = names['fn'];
    var firstNameT = names['gnt'];
    var firstNameTList = firstNameT.split('<');
    firstNameT = '';
    for (var i = 0; i < firstNameTList.length; i++) {
      firstNameT += firstNameTList[i];
      if (i < firstNameTList.length - 1) {
        firstNameT += ' ';
      }
    }
    var lastNameT = names['fnt'];
    var dateOfBirth = formatDate(certificateInfo['dob']);

    String key = 'none';
    Map details = new Map();

    if (certificateInfo.containsKey('v')) {
      details = decodeVaccine(certificateInfo['v'][0]);
      key = 'v';
    } else if (certificateInfo.containsKey('t')) {
      details = decodeTest(certificateInfo['t'][0]);
      key = 't';
    } else if (certificateInfo.containsKey('r')) {
      details = decodeRecovery(certificateInfo['r'][0]);
      key = 'r';
    }

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
    }

    String mp = map['mp'];

    switch (mp) {
      case 'EU/1/20/1528':
        mp = 'Comirnaty';
        break;
      case 'EU/1/20/1507':
        mp = 'Spikevax (previously COVID-19 Vaccine Moderna)';
        break;
      case 'EU/1/21/1529':
        mp = 'Vaxzevria';
        break;
      case 'EU/1/20/1525':
        mp = 'COVID-19 Vaccine Janssen';
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
      case 'Covishield':
        vp = 'Covishield (ChAdOx1_nCoV-19)';
        break;
      case 'Covid-19-recombinant':
        vp = 'Covid-19 (recombinant)';
        break;
      case 'R-COVI':
        vp = 'R-COVI';
        break;
      case 'CoviVac':
        vp = 'CoviVac';
        break;
      case 'Sputnik-Light':
        vp = 'Sputnik Light';
        break;
      case 'Hayat-Vax':
        vp = 'Hayat-Vax';
        break;
      case 'Abdala':
        vp = 'Abdala';
        break;
      case 'WIBP-CorV':
        vp = 'WIBP-CorV';
        break;
      case 'MVC-COV1901':
        vp = 'MVC COVID-19 vaccine';
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
        ma =
            'Sinopharm Zhijun (Shenzhen) Pharmaceutical Co. Ltd. - Shenzhen location';
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
      case 'ORG-100001981':
        ma = 'Serum Institute Of India Private Limited';
        break;
      case 'Fiocruz':
        ma = 'Fiocruz';
        break;
      case 'ORG-100007893':
        ma = 'R-Pharm CJSC';
        break;
      case 'Chumakov-Federal-Scientific-Center':
        ma =
            'Chumakov Federal Scientific Center for Research and Development of Immune-andBiological Products';
        break;
      case 'ORG-100023050':
        ma = 'Gulf Pharmaceutical Industries';
        break;
      case 'CIGB':
        ma = 'Center for Genetic Engineering and Biotechnology (CIGB)';
        break;
      case 'Sinopharm-WIBP':
        ma = 'Sinopharm - Wuhan Institute of Biological Products';
        break;
      case 'ORG-100033914':
        ma = 'Medigen Vaccine Biologics Corporation';
        break;
    }

    var dateOfLastDoseList = map['dt'].split('-');
    var dateOfLastDose = dateOfLastDoseList[2] +
        '.' +
        dateOfLastDoseList[1] +
        '.' +
        dateOfLastDoseList[0];

    return {
      // agent targeted
      'tg': map['tg'].toString() == '840539006' ? 'COVID-19' : 'Unknown',
      // vaccine or prophylaxis
      'vp': vp,
      // medicinal product
      'mp': mp,
      // manufacturer
      'ma': ma,
      // doses done
      'dn': map['dn'].toString(),
      // doses required
      'sd': map['sd'].toString(),
      // date of last dose
      'dt': dateOfLastDose,
      // country
      'co': map['co'],
      // certificate issuer
      'is': map['is'],
      // certificate identifier
      'ci': map['ci'],
    };
  }

  static Map decodeTest(Map map) {
    var tr = map['tr'];

    switch (tr) {
      case '260415000':
        tr = ['Negative', 'Negative (Not detected)'];
        break;
      case '260373001':
        tr = ['Positive', 'Positive (Detected)'];
        break;
    }

    var tt = map['tt'];

    switch (tt) {
      case 'LP6464-4':
        tt = ['PCR', 'PCR (NAAT)']; // Nucleic Acid Amplification Test
        break;
      case 'LP217198-3':
        tt = ['Antigen', 'Rapid Antigen Test (RAT)'];
        break;
    }

    var ma = map['ma'];

    if (ma != null) {
      var id = ma;
      ma = testDatabase.where(
              (test) => test['id_device'] == id
      ).toList()[0]['manufacturer']['name'];
    }

    var datetime = DateTime.parse(map['sc']);
    var date = formatDate(map['sc'].split('T')[0]);

    String time = '';
    String hour = datetime.hour.toString();
    String minute = datetime.minute.toString();

    if (hour.length == 1) {
      hour = '0' + hour;
    }

    if (minute.length == 1) {
      minute = '0' + minute;
    }

    time = hour + ':' + minute + ' (' + datetime.timeZoneName + ')';

    var sc = date + ', ' + time;

    return {
      // agent targeted
      'tg': map['tg'].toString() == '840539006' ? 'COVID-19' : 'Unknown',
      // test type
      'tt': tt,
      // test name
      'nm': map['nm'],
      // manufacturer - test device identifier (rapid antigen tests only)
      'ma': ma,
      // date and time of the test sample collection
      'sc': [date, sc],
      // test result
      'tr': tr,
      // testing centre or facility
      'tc': map['tc'],
      // country
      'co': map['co'],
      // certificate issuer
      'is': map['is'],
      // certificate identifier
      'ci': map['ci'],
    };
  }

  static Map decodeRecovery(Map map) {
    return {
      // agent targeted
      'tg': map['tg'].toString() == '840539006' ? 'COVID-19' : 'Unknown',
      // date of positive test result
      'fr': formatDate(map['fr']),
      // valid from
      'df': formatDate(map['df']),
      // valid until
      'du': formatDate(map['du']),
      // country
      'co': map['co'],
      // certificate issuer
      'is': map['is'],
      // certificate identifier
      'ci': map['ci'],
    };
  }

  static String formatDate(String date) {
    var dt = DateTime.parse(date);
    var day = dt.day.toString();
    var month = dt.month.toString();

    if (day.length == 1) {
      day = '0' + day;
    }

    if (month.length == 1) {
      month = '0' + month;
    }

    var year = dt.year.toString();

    return day + '.' + month + '.' + year;
  }
}

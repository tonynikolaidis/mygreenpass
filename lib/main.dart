import 'package:country_codes/country_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycovidpass/certificates_page.dart';
import 'get_started_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'utils/navigation_bar_color.dart';
import 'utils/storage.dart';

late Widget home;
double bottomOffset = 0;
bool shouldSetBottomOffset = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Storage.initLocalStorage();
  await CountryCodes.init(Locale('en', 'US'));

  List<String>? codes = Storage.getItem('codes');

  if (codes!.isEmpty) {
    home = GetStartedPage();
  } else {
    home = CertificatesPage();
  }

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    // bottomOffset = MediaQuery.of(context).padding.bottom;

    return ProviderScope(
      child: CupertinoApp(
        localizationsDelegates: <LocalizationsDelegate<dynamic>>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        title: 'myCovidPass',
        home: home,
      ),
    );
  }
}

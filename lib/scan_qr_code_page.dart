import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mycovidpass/utils/custom_app_bar.dart';
import 'package:mycovidpass/utils/qr_scanner.dart';

import 'utils/constants.dart';
import 'utils/navigation_bar_color.dart';

class ScanQrCodePage extends StatefulWidget {
  const ScanQrCodePage({Key? key}) : super(key: key);

  @override
  _ScanQrCodePageState createState() => _ScanQrCodePageState();
}

class _ScanQrCodePageState extends State<ScanQrCodePage> {
  @override
  Widget build(BuildContext context) {
    NavigationBarColor.changeTo('blue');

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add certificate',
        onPressed: () {
          Navigator.pop(context);
          NavigationBarColor.changeTo('blue');
        },
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: QrScanner()
    );
  }
}

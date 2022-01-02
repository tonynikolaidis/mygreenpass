import 'package:flutter/material.dart';
import 'package:mycovidpass/main.dart';

import 'utils/how_it_works_item.dart';
import 'utils/navigation_bar_color.dart';
import 'utils/constants.dart';
import 'utils/white_background_painter.dart';

import 'package:simple_shadow/simple_shadow.dart';

class HowItWorks extends StatelessWidget {
  const HowItWorks({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double spacing = 48;

    if (aspectRatio >= 9/16) {
      spacing = 32;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "How it works",
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
                      height: spacing,
                    ),
                    SimpleShadow(
                      child: Image(
                        image: AssetImage('assets/phone_over_certificate.png'),
                        width: MediaQuery.of(context).size.width * 1.5 / 3,
                      ),
                      opacity: 0,
                      color: COLOR_SHADOW,
                      offset: Offset(0, 12),
                      sigma: 32,
                    ),
                    SizedBox(
                      height: spacing,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Add certificate',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                            color: COLOR_BLUE,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8 // MediaQuery.of(context).size.height * 3 / 100,
                    ),
                    HowItWorksItem(
                        number: 1,
                        text: 'Hold your smartphone camera over the QR code on your Digital Covid Certificate to scan it.'
                    ),
                    SizedBox(
                      height: 18 // MediaQuery.of(context).size.height * 2 / 100,
                    ),
                    HowItWorksItem(
                        number: 2,
                        text: 'A preview of the Covid certificate will appear. Tap ‘Save’ to add the certificate to the app.'
                    ),
                    SizedBox(
                      height: 18 // MediaQuery.of(context).size.height * 2 / 100,
                    ),
                    HowItWorksItem(
                        number: 3,
                        text: 'Done! If you want to add more certificates, press ‘Add’ in the certificates page located at the bottom right.'
                    ),
                    SizedBox(
                      height: bottomOffset,
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
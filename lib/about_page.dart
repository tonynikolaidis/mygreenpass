import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';
import 'utils/constants.dart';
import 'utils/navigation_bar_color.dart';
import 'utils/white_background_painter.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "About",
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
                child: ListView(primary: false, children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 5 / 100,
                      ),
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
                                  'Digital Covid Certificates are not travel documents.\n',
                                  style: TextStyle(fontSize: 16)),
                              Text(
                                  'Always check the public health measures and restrictions that apply before travelling.',
                                  style: TextStyle(fontSize: 16))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Development',
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
                        height: 8,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 80 / 100,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'myCovidPass is an open-source project created with Flutter. Its code can be found on GitHub by clicking the button below.',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FloatingActionButton.extended(
                                    onPressed: () async {
                                      await launch('https://github.com/tonynikolaidis/mycovidpass');
                                    },
                                    heroTag: 'view_on_github',
                                    label: Text(
                                      'View on GitHub',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    icon: Image(
                                      image: AssetImage('assets/github.png'),
                                      height: 24,
                                      color: Colors.white,
                                    ),
                                    backgroundColor: COLOR_BLUE,
                                    foregroundColor: Colors.white,
                                    splashColor: COLOR_BLUE_SPLASH,
                                    elevation: 0,
                                    highlightElevation: 5,
                                  ),
                                ],
                              )
                            ]),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Author',
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
                        height: 8,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 80 / 100,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'The app was written by Tony Nikolaidis to store Digital Covid Certificates on mobile phones.',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FloatingActionButton(
                                      onPressed: () async {
                                        await launch('https://github.com/tonynikolaidis');
                                      },
                                      heroTag: 'github',
                                      child: Image(
                                        image: AssetImage('assets/github.png'),
                                        height: 24,
                                        color: Colors.white,
                                      ),
                                      backgroundColor:
                                          Color.fromRGBO(20, 25, 30, 1.0),
                                      foregroundColor: Colors.white,
                                      splashColor: COLOR_BLUE_SPLASH,
                                      elevation: 0,
                                      highlightElevation: 5,
                                    ),
                                    SizedBox(
                                      width: 18,
                                    ),
                                    FloatingActionButton(
                                      onPressed: () async {
                                        await launch('https://twitter.com/tonynikolaidis');
                                      },
                                      heroTag: 'twitter',
                                      child: Image(
                                        image: AssetImage('assets/twitter.png'),
                                        height: 24,
                                        color: Colors.white,
                                      ),
                                      backgroundColor:
                                          Color.fromRGBO(1, 161, 242, 1.0),
                                      foregroundColor: Colors.white,
                                      splashColor: COLOR_BLUE_SPLASH,
                                      elevation: 0,
                                      highlightElevation: 5,
                                    ),
                                    SizedBox(
                                      width: 18,
                                    ),
                                    FloatingActionButton(
                                      onPressed: () async {
                                        await launch('https://www.linkedin.com/in/tony-nikolaidis-a86aba181/');
                                      },
                                      heroTag: 'linkedin',
                                      child: Image(
                                        image:
                                            AssetImage('assets/linkedin.png'),
                                        height: 24,
                                        color: Colors.white,
                                      ),
                                      backgroundColor:
                                          Color.fromRGBO(10, 102, 194, 1.0),
                                      foregroundColor: Colors.white,
                                      splashColor: COLOR_BLUE_SPLASH,
                                      elevation: 0,
                                      highlightElevation: 5,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FloatingActionButton.extended(
                                      onPressed: () async {
                                        await launch('https://www.tonynikolaidis.com');
                                      },
                                      heroTag: 'visit_website',
                                      label: Text(
                                        'Visit website',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      icon: Image(
                                        image: AssetImage('assets/link.png'),
                                        height: 20,
                                        color: Colors.white,
                                      ),
                                      backgroundColor: COLOR_BLUE,
                                      foregroundColor: Colors.white,
                                      splashColor: COLOR_BLUE_SPLASH,
                                      elevation: 0,
                                      highlightElevation: 5,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 64,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image(
                                      image: AssetImage('assets/logo.png'),
                                      width: MediaQuery.of(context).size.width *
                                          50 /
                                          100,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: bottomOffset,
                                ),
                              ])),
                    ],
                  ),
                ]))));
  }
}

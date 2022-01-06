import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'certificates_page.dart';

import 'certificate_details_page.dart';
import 'main.dart';
import 'utils/constants.dart';
import 'utils/extract_qr_code_data.dart';
import 'utils/navigation_bar_color.dart';
import 'utils/storage.dart';
import 'utils/white_background_painter.dart';

import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class ReorderPage extends ConsumerWidget {
  const ReorderPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var codes = ref.watch(certificates);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Reorder certificates",
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
            child: Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: Theme(
                data: ThemeData(
                  canvasColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: ReorderableListView(
                  primary: false,
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.5 / 10),
                  buildDefaultDragHandles: false,
                  children: <Widget>[
                    for (int index = 0; index < codes.length; index++)
                      Container(
                        key: Key('$index'),
                        decoration: BoxDecoration(
                          color: Colors.transparent
                        ),
                        child: InkWell(
                          child: CertificateTile(code: codes[index], index: index,),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CertificateDetailsPage(
                                        title: 'Details',
                                        code: codes[index],
                                        data: ExtractQrCodeData.extract(codes[index]),
                                        save: false)));
                          },
                        ),
                      ),
                  ],
                  onReorder: (int oldIndex, int newIndex) async {
                    if (oldIndex != newIndex) {
                      // var length = Storage.certificates!.length;
                      // if (newIndex > length - 1) {
                      //   newIndex = length;
                      // }

                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final item = Storage.certificates!.removeAt(oldIndex);
                      Storage.certificates!.insert(newIndex, item);

                      ref.refresh(certificates);

                      await Storage.setItem('codes', Storage.certificates!);
                    }
                  },
                ),
              ),
            )
        )
    );
  }
}

class CertificateTile extends StatelessWidget {
  final code;
  final index;

  const CertificateTile({
    Key? key, required this.code, required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = ExtractQrCodeData.extract(code);
    var header = '';

    if (data.containsKey('v')) {
      header = 'VACCINATION';
    } else if (data.containsKey('t')) {
      header = 'TEST';
    } else if (data.containsKey('r')) {
      header = 'RECOVERY';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              // color: COLOR_SHADOW,
              spreadRadius: 5,
              blurRadius: 30,
              offset: Offset(0, 5),
            ),
          ],
          color: COLOR_GLASS_WHITE_2,
          // gradient: LinearGradient(
          //     begin: Alignment.bottomRight,
          //     end: Alignment.topLeft,
          //     colors: [COLOR_GLASS_PURPLE, COLOR_GLASS_WHITE],
          // ),
          // gradient: GRADIENT_GLASS,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          border: Border.all(color: COLOR_GLASS_WHITE)
          // border: Border.all(color: Colors.red)
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: COLOR_YELLOW,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Container(
                                  child: SvgPicture.asset('assets/european_union_logo.svg', height: 30),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    header + ' CERTIFICATE',
                                    softWrap: true,
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'RobotoMono',
                                        color: Colors.white),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.9 - 50.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['lastNameT'] + ' ' + data['firstNameT'], style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500),),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReorderableDragStartListener(
                          child: Icon(Icons.drag_handle),
                          index: index
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

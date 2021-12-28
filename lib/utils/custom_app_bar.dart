import 'package:flutter/material.dart';

import 'constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final void Function() onPressed;

  const CustomAppBar({Key? key, required this.title, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: COLOR_BLUE),
      leading: new IconButton(
          onPressed: onPressed,
          icon: Icon(Icons.arrow_back)),
      bottom: PreferredSize(
        child: Container(
          color: COLOR_BLUE,
          height: 1,
        ),
        preferredSize: Size.fromHeight(1),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}

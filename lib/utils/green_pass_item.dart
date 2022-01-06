import 'package:flutter/material.dart';

import 'constants.dart';

class GreenPassItem extends StatelessWidget {
  final String header;
  final String body;
  final CrossAxisAlignment alignment;
  final TextAlign textAlign;

  const GreenPassItem({
    Key? key,
    required this.header,
    required this.body,
    required this.alignment,
    required this.textAlign
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Row(
          children: [
            Text(
              header,
              softWrap: true,
              textScaleFactor: 1.0,
              style: TextStyle(
                  color: COLOR_GRAY,
                  fontSize: 14,
                  fontFamily: 'RobotoMono'),
            )
          ],
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.red)
              ),
              constraints: BoxConstraints(maxWidth: (MediaQuery.of(context).size.width - 20) * 1/2),
              child: Text(
                body,
                softWrap: true,
                textScaleFactor: 1.0,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
                textAlign: textAlign,
              ),
            )
          ],
        )
      ],
    );
  }
}

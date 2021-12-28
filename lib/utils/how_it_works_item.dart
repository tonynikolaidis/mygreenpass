import 'package:flutter/cupertino.dart';

import 'constants.dart';

class HowItWorksItem extends StatelessWidget {
  final int number;
  final String text;

  const HowItWorksItem({
    Key? key,
    required this.number,
    required this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal:
          MediaQuery.of(context).size.width * 7 / 100),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 7 / 100,
                  height: MediaQuery.of(context).size.width * 7 / 100,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: COLOR_GLASS_PURPLE
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        number.toString(),
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.0,
                      ),
                    ],
                  )
              ),
              SizedBox(
                width:
                MediaQuery.of(context).size.width * 4 / 100,
              ),
              Container(
                width: MediaQuery.of(context).size.width *
                    75 /
                    100,
                child: Column(
                  children: [
                    Text(
                      text,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}



import 'package:buzz_app/constants.dart';
import 'package:flutter/cupertino.dart';

class AddVideoIcon extends StatelessWidget {
  const AddVideoIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 45,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: green,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Image.asset('assets/icon/buzzicon.png')
      ),
    );
  }
}

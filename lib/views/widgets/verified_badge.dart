import 'package:flutter/material.dart';

import '../../constants.dart';

class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: green,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 10,
      ),
    );
  }
}

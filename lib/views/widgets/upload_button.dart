import 'package:flutter/material.dart';

import '../../constants.dart';

class UploadButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isLoading;

  UploadButton({required this.onTap, required this.isLoading});

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  blue,
                  green,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: green,
                width: 3,
              )),
          padding: const EdgeInsets.all(15),
          child: widget.isLoading
              ? CircularProgressIndicator(

            color: white,
          )
              : const Text(
            "Upload",
            style: TextStyle(
              color: black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

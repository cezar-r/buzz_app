import 'package:flutter/material.dart';

import '../../constants.dart';

class ExpandableCaption extends StatefulWidget {
  final TextStyle textStyle;
  final String caption;

  ExpandableCaption({required this.textStyle, required this.caption});

  @override
  _ExpandableCaptionState createState() => _ExpandableCaptionState();
}

class _ExpandableCaptionState extends State<ExpandableCaption> {
  bool _showFullCaption = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _showFullCaption ? widget.caption : widget.caption.substring(0, 100),
          style: widget.textStyle,
          maxLines: _showFullCaption ? 8 : null,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 3,),
        InkWell(
          onTap: () {
            setState(() {
              _showFullCaption = !_showFullCaption;
            });
          },
          child: Text(
            _showFullCaption ? "Less" : "More",
            style: TextStyle(color: white, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
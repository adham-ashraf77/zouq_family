import 'package:flutter/material.dart';

class UICard extends StatefulWidget {
  final Widget cardContent;
  UICard({this.cardContent});

  @override
  _UICardState createState() => _UICardState();
}

class _UICardState extends State<UICard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
          child: widget.cardContent,
        ),
      ),
    );
  }
}

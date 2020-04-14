import 'package:flutter/material.dart';
import 'package:zouqadmin/theme/common.dart';

class AppBtn extends StatefulWidget {
  final String label;
  final Function onClick;
  final Widget anotherChild;

  // used as [anotherChild] default valuse when [anotherChild] == null
  final Widget defaultChild = Container();

  AppBtn({this.label = "", this.onClick, this.anotherChild});

  @override
  _AppBtnState createState() => _AppBtnState();
}

class _AppBtnState extends State<AppBtn> {
  @override
  Widget build(BuildContext context) {
    //List of children placed inside button
    Widget contentList = Row(
      mainAxisAlignment: widget.anotherChild == null
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          "${widget.label}",
          style: buttonStyleMain,
        ),
        widget.anotherChild == null ? widget.defaultChild : widget.anotherChild
      ],
    );

    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
      ),
      color: accent,
      child: InkWell(
        splashColor: splash,
        borderRadius: new BorderRadius.circular(18.0),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.width * 0.7,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            alignment: Alignment.center,
            child: contentList),
        onTap: widget.onClick,
      ),
    );
  }
}

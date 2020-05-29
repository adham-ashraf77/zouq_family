import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoadingDialog extends StatefulWidget {
  String mss;

  LoadingDialog({this.mss});

  @override
  _LoadingDialogState createState() => _LoadingDialogState(mss);
}

class _LoadingDialogState extends State<LoadingDialog> {
  String mss;

  _LoadingDialogState(this.mss);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          height: 250,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Stack(
            children: <Widget>[
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width * 0.85,
                color: Colors.transparent,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 225,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  backgroundColor: Colors.greenAccent,
                  radius: 35,
                  child: Icon(
                    FontAwesomeIcons.exclamation,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(
                        "$mss",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

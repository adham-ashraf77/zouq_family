import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class DialogWorning extends StatefulWidget {
  String mss;
  DialogWorning({this.mss});
  @override
  _DialogWorningState createState() => _DialogWorningState(mss);
}

class _DialogWorningState extends State<DialogWorning> {
  String mss;
  _DialogWorningState(this.mss);
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
                  backgroundColor: Color(0xFFF96D7E),
                  radius: 35,
                  child: Icon(
                    FontAwesomeIcons.exclamation,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            "$mss",
                            style: TextStyle(color: Colors.black, fontSize:13),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child:                           RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          color: Color(0xFF1DAED1),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 7),
                            child: Text(
                              'تراجع',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 22.0),
                            ),
                          ),
                        ),
                      )
                    ],
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

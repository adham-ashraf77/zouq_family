import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zouqadmin/theme/common.dart';

class AccountFrozenDialog extends StatefulWidget {
  @override
  _AccountFrozenDialogState createState() => _AccountFrozenDialogState();
}

class _AccountFrozenDialogState extends State<AccountFrozenDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          height: 450,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Stack(
            children: <Widget>[
              Container(
                height: 450,
                width: MediaQuery.of(context).size.width * 0.85,
                color: Colors.transparent,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 425,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  backgroundColor: Color(0xFFF96D7E),
                  radius: 35,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Icon(
                          FontAwesomeIcons.userAlt,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40, left: 40),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFF96D7E)),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Center(
                      child: Text(
                        'حسابك معطل',
                        style: TextStyle(color: accent, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'تم تعطيل حسابك لانك ……….',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'يمكنك التواصل مع الادارة لمعرفة المزيد',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    ListTile(
                      leading: Text(
                        'ايميل',
                        style: moreTextStyle1,
                      ),
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'support@zoq.com',
                          style: paragarph1,
                        ),
                      ),
                      trailing: CircleAvatar(
                        radius: 15.0,
                        backgroundColor: accent,
                        child: Icon(
                          Icons.alternate_email,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Divider(
                      color: iconsFaded,
                      indent: 25,
                    ),
                    ListTile(
                      leading: Text(
                        'رقم هاتف',
                        style: moreTextStyle1,
                      ),
                      title: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '543-649-3478',
                          style: paragarph1,
                        ),
                      ),
                      trailing: CircleAvatar(
                        radius: 15.0,
                        backgroundColor: accent,
                        child: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Divider(
                      color: iconsFaded,
                      indent: 25,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Center(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          color: Color(0xFF1DAED1),
                          onPressed: () {
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
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

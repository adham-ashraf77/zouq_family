import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';
import 'package:zouqadmin/widgets/AppButton.dart';

import '../../home.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({this.title});

  final String title;

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(' انشاء كلمة المرور ', style: headers4),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? 50
                  : 20,
            ),
            Center(
              child: CircleAvatar(
                backgroundImage: AssetImage(resetPassword2),
                backgroundColor: Colors.white,
                radius: 60.0,
              ),
            ),
            SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 70
                        : 30),
            TextFormField(
              decoration: InputDecoration(hintText: 'كلمة المرور الجديدة'),
              obscureText: true,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              obscureText: true,
              decoration:
                  InputDecoration(hintText: 'تأكيد كلمة المرور الجديدة '),
            ),
            SizedBox(
              height: 50,
            ),
            AppButton(
              text: 'حــفــظ',
              onClick: () {
                pushPage(context, Home());
              },
            ),
          ],
        ),
      ),
    );
  }
}

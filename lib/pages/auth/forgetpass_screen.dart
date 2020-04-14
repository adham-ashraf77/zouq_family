import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/pages/auth/ResetPasswordPage.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';
import 'package:zouqadmin/widgets/AppButton.dart';

class Forgetpass extends StatefulWidget {
  Forgetpass({this.title});

  final String title;

  @override
  _ForgetpassState createState() => _ForgetpassState();
}

class _ForgetpassState extends State<Forgetpass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(' نسيت كلمة المرور ', style: headers4),
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Center(
            child: CircleAvatar(
              backgroundImage: AssetImage(resetPassword1),
              backgroundColor: Colors.white,
              radius: 60.0,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? 100
                : 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 7,
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'رقم الهاتـف'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  height: 54,
                  child: CountryCodePicker(
                    onChanged: print,
                    initialSelection: 'SA',
                    favorite: ['+966', 'SA'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      //                   <--- left side
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  )),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          AppButton(
            text: 'إرسال كـود التحقق',
            onClick: () {
              pushPage(context, ResetPasswordPage());
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zouqadmin/pages/auth/ResetPasswordPage.dart';
import 'package:zouqadmin/services/registeration.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';
import 'package:zouqadmin/widgets/AppButton.dart';
import 'package:zouqadmin/services/checkpasswordresettingcode.dart';
import '../../home.dart';
import '../dialogWorning.dart';
import '../productsPage.dart';

class VerificationcodePage extends StatefulWidget {
  String phone;
  int flag; //1 for activate user for verification, 2 for resetting password
  VerificationcodePage({this.phone, @required this.flag});

  @override
  _VerificationcodePageState createState() =>
      _VerificationcodePageState(phone, flag);
}

class _VerificationcodePageState extends State<VerificationcodePage> {
  String _phone;
  int flag;
  _VerificationcodePageState(this._phone, this.flag);
  bool hasError = false;
  String _currentText = "";
  String _codeAlert = "";

  validation() {
    if (_currentText.length < 4) {
      setState(() {
        _codeAlert = "Confirmation code is short";
      });
    } else {
      setState(() {
        _codeAlert = "";
      });
      flag == 1 ? activate(_currentText) : checkToResetPassword(_currentText);
    }
  }

  activate(String code) async {
    String response = await Registeration().activateRegistered(_phone, code);
    if (response != "success") {
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogWorning(
                mss: response,
              ));
    } else {
      pushPage(context, Home());
    }
  }

  checkToResetPassword(String code) async {
    CheckPasswordResettingCode()
        .resetPassword(phone: _phone, code: code)
        .then((onValue) {
      if (onValue.data['message'] ==
              'now you can reset the password in 3600 sec' ||
          onValue.statusCode == 200) {
        pushPage(
            context,
            ResetPasswordPage(
              phone: _phone,
            ));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) => DialogWorning(
                  mss: onValue.data['message'],
                ));
      }
    }).catchError((onError) {
      print('Error : ' + onError.toString());
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogWorning(
                mss: 'Something went wrong please try again later',//onError.toString(),
              ));
    });
  }

  resendCode() async {
    String response = await Registeration().resendConfirmCode(_phone);
    if (response != "success") {
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogWorning(
                mss: response,
              ));
    } else {
      print("success");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(' رمز التحقق', style: headers4),
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
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Image.asset('assets/images/mobileMsg.png'),
              ),
            ),
            // SizedBox(
            //   height: 5,
            // ),
            Text('أدخل رمز OTP الخاص بك هنا', style: paragarph2),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 280,
              child: PinCodeTextField(
                inactiveColor: Colors.grey[350],
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                ),
                length: 4,
                obsecureText: false,
                animationType: AnimationType.scale,
                shape: PinCodeFieldShape.circle,
                animationDuration: Duration(milliseconds: 300),
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 50,
                activeFillColor: Colors.grey[350],
                activeColor: Colors.grey[350],
                inactiveFillColor: Colors.grey[350],
                enableActiveFill: true,
                selectedFillColor: Colors.grey[200],
                selectedColor: Colors.grey[200],
                onChanged: (value) {
                  setState(() {
                    _currentText = value;
                  });
                },
              ),
            ),
            Text(
              "$_codeAlert",
              style: TextStyle(color: Colors.red, fontSize: 12),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 30,
            ),
            AppButton(
              text: "تحقق",
              onClick: () {
                validation();
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'لم تتلقى أي رمز؟ ',
                  style: paragarph4,
                ),
                InkWell(
                  onTap: () {
                    resendCode();
                  },
                  child: Text(
                    '  إعادة إرسال رمز جديد ',
                    style: paragarph4.copyWith(color: accent),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

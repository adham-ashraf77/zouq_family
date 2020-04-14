import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';
import 'package:zouqadmin/widgets/AppButton.dart';

import '../../home.dart';

class VerificationcodePage extends StatefulWidget {
  VerificationcodePage();

  @override
  _VerificationcodePageState createState() => _VerificationcodePageState();
}

class _VerificationcodePageState extends State<VerificationcodePage> {
  bool hasError = false;
  String currentText = "";

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
                    currentText = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            AppButton(
              text: "تحقق",
              onClick: () {
                pushPage(context, Home());
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
                  onTap: () {},
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

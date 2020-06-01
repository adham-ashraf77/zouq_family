import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:zouqadmin/I10n/app_localizations.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/pages/setnewphonenumber_screen.dart';
import 'package:zouqadmin/services/editphone.dart';
import 'package:zouqadmin/services/updatephoneconfirmcode.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';
import 'package:zouqadmin/widgets/AppButton.dart';

import '../../I10n/app_localizations.dart';


class PhoneUpdatingCOnfirmationCode extends StatefulWidget {
  final String phone;
  PhoneUpdatingCOnfirmationCode({this.phone});

  @override
  _PhoneUpdatingCOnfirmationCode createState() =>
      _PhoneUpdatingCOnfirmationCode(phone);
}

class _PhoneUpdatingCOnfirmationCode
    extends State<PhoneUpdatingCOnfirmationCode> {
  final String _phone;
  _PhoneUpdatingCOnfirmationCode(this._phone);
  bool hasError = false;
  String _currentText = "";
  String _codeAlert = "";

  validation() {
    if (_currentText.length < 4) {
      setState(() {
        _codeAlert = AppLocalizations.of(context).translate('shortCode');
      });
    } else {
      setState(() {
        _codeAlert = "";
      });
      UpdatePhoneConfirmCode()
          .updatePhoneConfirmCode(_currentText)
          .then((onValue) {
        if (onValue == 'success') {
          //TODO push new phone page
          // print('Success');
          pushPage(
              context,
              SetNewPhoneNumberScreen(
                phone: _phone,
              ));
        } else {
          if (onValue.toString().contains('confirm code is not valid')) {
            showDialog(
                context: context,
                builder: (BuildContext context) => DialogWorning(
                      mss: AppLocalizations.of(context).translate('otpError'),
                    ));
          } else if (onValue
              .toString()
              .contains('confirm code does not exists or expired')) {
            showDialog(
                context: context,
                builder: (BuildContext context) => DialogWorning(
                  mss: AppLocalizations.of(context).translate('deleteSuccess'),
                    ));
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) => DialogWorning(
                  mss: AppLocalizations.of(context).translate('deleteSuccess'),
                    ));
          }
        }
      });
    }
  }

  resendCode() {
    UpdatePhone().updatePhone(_phone).then((onValue) {
      if (onValue.toString() == 'success') {
        showDialog(
            context: context,
            builder: (BuildContext context) => DialogWorning(
              mss: AppLocalizations.of(context).translate('otpSuccess'),
                ));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) => DialogWorning(
              mss:
              AppLocalizations.of(context).translate('deleteFailed'),
                ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('phone ' + _phone);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            AppLocalizations.of(context).translate(
                'verifyCode'), //AppLocalizations.of(context).translate('verifyCode')
            style: headers4),
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
            Text(AppLocalizations.of(context).translate('enterOTPCode'),
                //AppLocalizations.of(context).translate('enterOTPCode')
                style: paragarph2),
            SizedBox(
              height: 20,
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
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
              text: AppLocalizations.of(context).translate(
                  'check'), //AppLocalizations.of(context).translate('check'),
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
                  AppLocalizations.of(context).translate('noOTPCode'),
                  // AppLocalizations.of(context).translate('noOTPCode'),
                  style: paragarph4,
                ),
                SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    //TODO
                    resendCode();
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('resendCode'),
                    // AppLocalizations.of(context).translate('resendCode'),
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

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/pages/auth/ResetPasswordPage.dart';
import 'package:zouqadmin/pages/auth/verificationcode_screen.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';
import 'package:zouqadmin/widgets/AppButton.dart';
import 'package:zouqadmin/services/resetpassword.dart';
class Forgetpass extends StatefulWidget {
  Forgetpass({this.title});

  final String title;

  @override
  _ForgetpassState createState() => _ForgetpassState();
}

class _ForgetpassState extends State<Forgetpass> {
  final phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _countryCode = "+966";

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    phoneController.dispose();
    super.dispose();
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      _countryCode = countryCode.toString();
    });
    print("New Country selected: " + countryCode.toString());
  }

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
      body: Form(
        key: _formKey,
        child: ListView(
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
                    controller: phoneController,
                    validator: (value) {
                      if (value.trim().length < 9) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
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
if (_formKey.currentState.validate()) {
                  ResetPassword()
                      .resetPassword(
                          phone: _countryCode.replaceAll("+", "") +
                              phoneController.text)
                      .then((response) {
                        print('here' + response.toString());
                    if (response.data['message'] ==
                            ('confirmation code has been sent successfully') ||
                        response.statusCode == 200 ||
                        response.statusCode == 201) {
                      pushPage(
                          context,
                          VerificationcodePage(
                            phone:_countryCode.replaceAll("+", "") + phoneController.text,
                            flag: 2,
                          ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => DialogWorning(
                                mss: response.data['message'],
                              ));
                    }
                  }).catchError((onError) {
                    if(onError.toString().contains('Http status error [404]'))
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => DialogWorning(
                              mss: "Phone number isn't valid, please check your input",
                            ));else showDialog(
                        context: context,
                        builder: (BuildContext context) => DialogWorning(
                          mss: "$onError",
                        ));

                  });
                }              },
            ),
          ],
        ),
      ),
    );
  }
}

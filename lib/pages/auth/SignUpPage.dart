import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/pages/appInfo/TermsAndConditionsPage.dart';
import 'package:zouqadmin/pages/auth/verificationcode_screen.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';
import 'package:zouqadmin/widgets/AppButton.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({this.title});

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _string = true;
  int _radioValue1 = -1;

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;
      print(_radioValue1);
      switch (_radioValue1) {
        case 0:
          break;
        case 1:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        title: Text(
          'تسجيل جديد',
          style: headers4,
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            children: <Widget>[
              // Center(
              //   child: Container(
              //     width: 100,
              //     height: 100,
              //     child: CircleAvatar(
              //       backgroundColor: Colors.white,
              //       backgroundImage: AssetImage(profileImg),
              //       radius: 50.0,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'اسم المشترك'),
              ),
              SizedBox(
                height: 20,
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
                height: 20,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "البريد الإلكتروني"),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Radio(
                    value: 0,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange1,
                  ),
                  Text(
                    'ذكر',
                    style: paragarph1,
                  ),
                  SizedBox(
                    width: 35,
                  ),
                  Radio(
                    value: 1,
                    groupValue: _radioValue1,
                    onChanged: _handleRadioValueChange1,
                  ),
                  Text('انثى', style: paragarph1),
                ],
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "كلمة المرور"),
              ),
              SizedBox(
                height: 40,
              ),
              AppButton(
                text: "تسجيل",
                onClick: () {
                  pushPage(context, VerificationcodePage(flag: 1,));
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _string = !_string;
                            });
                          },
                          child: _string
                              ? Icon(
                                  Icons.radio_button_unchecked,
                                  size: 25.0,
                                  color: Colors.grey,
                                )
                              : Icon(
                                  Icons.check_circle,
                                  size: 25.0,
                                  color: accent,
                                ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          pushPage(context, TermsAndConditionsPage());
                        },
                        child: Text(
                          'الموافقة على الشروط والأحكام',
                          style: paragarph4,
                        ),
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

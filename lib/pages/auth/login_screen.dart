import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/pages/auth/SignUpPage.dart';
import 'package:zouqadmin/pages/auth/forgetpass_screen.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';
import 'package:zouqadmin/widgets/AppButton.dart';
import 'package:zouqadmin/widgets/roundedAppBar.dart';

import '../../home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.title});

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              pushPage(context, Home());
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Text(
                  'تخطى',
                  style: headers4,
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
          title: Text(
            ' تسجيل دخول',
            style: headers4,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  RoundedAppBar(),
                  Padding(
                    padding: const EdgeInsets.only(top: 70.0),
                    // (preferredSize - image half size (to center image) = 120 - 50)
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          child: Image.asset(
                            'assets/images/profilePlaceHolder.png',
                            fit: BoxFit.fill,
                          ),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.3,
              //   height: MediaQuery.of(context).size.height * 0.3,
              //   decoration: BoxDecoration(
              //       image: DecorationImage(image: AssetImage(appLogo))),
              // ),
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 50
                        : 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 50,
                // height: 50,
                child: Row(
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
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width - 50,
                child: TextFormField(
                  decoration: InputDecoration(hintText: 'كلمة المرور'),
                  obscureText: true,
                ),
              ),

              // AppBtn(
              //   label: "تسجيل الدخول",
              //   onClick: () {
              //     pushPage(context, Home());
              //   },
              // ),
              SizedBox(
                height: 40,
              ),
              AppButton(
                text: 'تسجيل الدخول',
                onClick: () {
                  pushPage(context, Home());
                },
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  pushPage(context, Forgetpass());
                },
                child: Center(
                  child: Container(
                    child: Text(
                      'نسيت كلمة المرور',
                      style: paragarph3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  //TODO
                },
                child: Center(
                  child: Container(
                    child: Text(
                      'شاشة التسجيل كأسرة منتجة',
                      style: TextStyle(
                        color: Colors.blue[200],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'لا تملك حسابا مسبقا ؟ ',
                    style: paragarph3,
                  ),
                  InkWell(
                    onTap: () {
                      pushPage(context, SignUpPage());
                    },
                    child: Text(
                      'قم بالاشتراك الان ',
                      style: paragarph3.copyWith(color: accent),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ));
  }
}

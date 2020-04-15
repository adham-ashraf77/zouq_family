import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/I10n/app_localizations.dart';
import 'package:zouqadmin/pages/auth/SignUpPage.dart';
import 'package:zouqadmin/pages/auth/forgetpass_screen.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';
import 'package:zouqadmin/widgets/AppButton.dart';
import 'package:zouqadmin/widgets/roundedAppBar.dart';

import '../../home.dart';
import '../adminRegistrationPage.dart';

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
                  AppLocalizations.of(context).translate('skip'),
                  style: headers4,
                  textAlign: TextAlign.end,
                ),
              ),
            ),
          ),
          title: Text(
            AppLocalizations.of(context).translate('sign in'),
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
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate('telephone')),
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
                  decoration: InputDecoration(
                      hintText:
                      AppLocalizations.of(context).translate('password')),
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
                text: AppLocalizations.of(context).translate('sign in'),
                onClick: () {
//                  pushPage(context, Home());
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
                      AppLocalizations.of(context).translate('forgot password'),
                      style: paragarph3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AdminRegistration()));
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

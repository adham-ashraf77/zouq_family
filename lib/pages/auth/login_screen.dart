import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/I10n/app_localizations.dart';
import 'package:zouqadmin/pages/auth/forgetpass_screen.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/pages/productsPage.dart';
import 'package:zouqadmin/services/login.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';
import 'package:zouqadmin/widgets/AppButton.dart';
import 'package:zouqadmin/widgets/roundedAppBar.dart';
import 'package:zouqadmin/services/getuser.dart';
import '../../I10n/app_localizations.dart';
import '../../I10n/app_localizations.dart';
import '../../I10n/app_localizations.dart';
import '../../I10n/app_localizations.dart';
import '../../home.dart';
import '../adminRegistrationPage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.title});

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phoneNumberTextFieldController = TextEditingController();
  final passwordTextFieldController = TextEditingController();
  String _countryCode = '966';
  bool isLoading = true;
  SharedPreferences prefs;
  final _formKey = GlobalKey<FormState>();
  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      this._countryCode = countryCode.toString();
    });
    // print("New Country selected: " + countryCode.toString());
  }

  Future<dynamic> getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var user;

    String token = prefs.getString('token');
    if (token != null)
      await GetUser().getUser(token: token).then((onValue) {
        setState(() {
          user = onValue;
        });
      }).catchError((onError) {
        print('Error ' + onError.toString());
        showDialog(
            context: context,
            builder: (BuildContext context) => DialogWorning(
                  mss: onError.toString(),
                ));
        user = 'failure';
      });
    else
      return 'failure'; //No exception, token is just not found
    return user;
  }

  @override
  void initState() {
    Future.delayed(Duration(seconds: 1)).then((_) {
      getSharedPrefs().then((onValue) {
        if (onValue != 'failure')
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
                settings: RouteSettings(
                  arguments: onValue,
                ),
              ));
        else
          setState(() {
            this.isLoading = false;
          });
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    phoneNumberTextFieldController.dispose();
    passwordTextFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey[400],
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.grey[300]),
                      strokeWidth: 2,
                    ),
                  ),
                  Text(
                    'Loading...',
                    textDirection: TextDirection.ltr,
                    style:
                        paragarph4.copyWith(color: Colors.grey[400], height: 2),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[200],
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context).translate('sign in'),
                style: headers4,
              ),
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
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
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
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
                              maxLength: 12,
                              controller: phoneNumberTextFieldController,
                              validator: (value) {
                                if (value.trim().length < 9) {
                                  return AppLocalizations.of(context)
                                      .translate('phoneError');
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  counterText: "",
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
                      height: 20,
                    ),
                    Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width - 50,
                      child: TextFormField(
                        validator: (value) {
                          if (value.trim().length < 6) {
                            return AppLocalizations.of(context)
                                .translate('shortPassword');
                          }
                          return null;
                        },
                        controller: passwordTextFieldController,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate('password')),
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
                      height: 25,
                    ),
                    AppButton(
                      text: AppLocalizations.of(context).translate('sign in'),
                      onClick: () {
                        if (_formKey.currentState.validate()) {
                          Login()
                              .login(
                                  password: passwordTextFieldController.text,
                                  phone: (
                                    this._countryCode +//  TODO uncomment this
                                          phoneNumberTextFieldController.text)
                                      .replaceAll("+", ''))
                              .then((onValue) {
                            if (onValue != 'success') if (onValue
                                .toString()
                                .contains('authentication failure')) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      DialogWorning(
                                        mss:
                                            "phone number or password isn't correct, please check your unput and try again",
                                      ));
                            } else if (onValue.toString().contains(
                                    "your account is not activated yet by the admins") ||
                                onValue
                                    .toString()
                                    .contains("not-active-by-admins")) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      DialogWorning(
                                        mss:
                                            'This account is not activated yet by the admins, try again later',
                                      ));
                            } else if (onValue
                                .toString()
                                .contains("this isn't an family"))
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      DialogWorning(
                                        mss: 'This user is not family',
                                      ));
                            else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      DialogWorning(
                                        mss: onValue.toString(),
                                      ));
                            }
                            else
                              getSharedPrefs().then((onValue) {
                                if (onValue != 'failure')
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Home(),
                                        settings: RouteSettings(
                                          arguments: onValue,
                                        ),
                                      ));
                                else {
                                  print('Err' + onValue.toString());
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          DialogWorning(
                                            mss:
                                                'Something went wrong please try again later', //onValue.toString(),
                                          ));
                                }
                              });
                          }).catchError((onError) {
                            print('onError' + onError.toString());
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    DialogWorning(
                                      mss:
                                          'Something went wrong please try again later', //onError.toString(),
                                    ));
                          });
                        }
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
                            AppLocalizations.of(context).translate('forgot'),
                            style: paragarph3,
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
                          AppLocalizations.of(context).translate('noAccount'),
                          style: paragarph3,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminRegistration()));
                          },
                          child: Text(
                            AppLocalizations.of(context).translate('signUpNow'),
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
              ),
            ));
  }
}

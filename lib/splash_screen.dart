import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/pages/auth/login_screen.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/services/getuser.dart';

import 'I10n/AppLanguage.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String token;
  bool isLoading = true;

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.get('token') ?? "";
    setState(() {
      isLoading = false;
    });
    if (token.isNotEmpty)
      getUserData().then((onValue) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
              settings: RouteSettings(
                arguments: onValue,
              ),
            ));
      });
  }

  changeLang(bool isArabic) async {
    var appLanguage = Provider.of<AppLanguage>(context);
    isArabic ? appLanguage.changeLanguage(Locale("ar")) : appLanguage.changeLanguage(Locale("en"));
    navTo();
  }

  navTo() async {
    if (token.isEmpty)
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    else
      getUserData().then((onValue) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
              settings: RouteSettings(
                arguments: onValue,
              ),
            ));
      });
  }

  Future<dynamic> getUserData() async {
    var user;
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
    // TODO: implement initState
    super.initState();
    checkToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo.png',
                    scale: 3,
                  ),
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
                  token.isEmpty
                      ? InkWell(
                          onTap: () => changeLang(true),
                          child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: Colors.cyan)),
                            alignment: Alignment.center,
                            child: Text("عربى "),
                          ),
                        )
                      : Container(),
                  Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
                  token.isEmpty
                      ? InkWell(
                          onTap: () => changeLang(false),
                          child: Container(
                            width: 200,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(color: Colors.cyan)),
                            alignment: Alignment.center,
                            child: Text("english"),
                          ),
                        )
                      : Container(),
                ],
              ),
      ),
    );
  }
}

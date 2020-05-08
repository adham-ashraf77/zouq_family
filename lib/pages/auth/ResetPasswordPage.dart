import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/pages/auth/login_screen.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';
import 'package:zouqadmin/widgets/AppButton.dart';
import 'package:zouqadmin/services/settingnewpassword.dart';
import '../../I10n/app_localizations.dart';
import '../../home.dart';

class ResetPasswordPage extends StatefulWidget {
  final String phone;
  final String title;
  ResetPasswordPage({this.title, this.phone});
  @override
  _ResetPasswordPageState createState() =>
      _ResetPasswordPageState(phone: this.phone);
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String phone;
  _ResetPasswordPageState({this.phone});

  final pass1 = TextEditingController();
  final pass2 = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    pass1.dispose();
    pass2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('createPassword'),
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? 50
                        : 20,
              ),
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage(resetPassword2),
                  backgroundColor: Colors.white,
                  radius: 60.0,
                ),
              ),
              SizedBox(
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 70
                          : 30),
              TextFormField(
                controller: pass1,
                validator: (value) {
                  if (value.trim().length < 6) {
                    return AppLocalizations.of(context)
                        .translate('shortPassword');
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context).translate('newPassword')),
                obscureText: true,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: pass2,
                validator: (value) {
                  if (value.trim().length < 6) {
                    return AppLocalizations.of(context)
                        .translate('shortPassword');
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)
                        .translate('confirmPassword')),
              ),
              SizedBox(
                height: 50,
              ),
              AppButton(
                text: AppLocalizations.of(context).translate('save'),
                onClick: () {
                  if (_formKey.currentState
                      .validate()) if (pass1.text.trim().length > 5) {
                    //TODO
                    pass1.text == pass2.text
                        ? SetNewPassword()
                            .setNewPassword(
                                phone: phone, newPassword: pass1.text)
                            .then((onValue) {
                            print('onVal ' + onValue.toString());
                            if (onValue.data['message'] ==
                                'password has been reset successfully')
                              pushPage(context, LoginPage());
                            else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      DialogWorning(
                                        mss: onValue.data['message'],
                                      ));
                            }
                          }).catchError((onError) {
                            print('Error ->' + onError);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    DialogWorning(
                                      mss:
                                          'Something went wrong please try again later', // onError.toString(),
                                    ));
                          })
                        : showDialog(
                            context: context,
                            builder: (BuildContext context) => DialogWorning(
                                  mss: "Passwords doesn't match",
                                ));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

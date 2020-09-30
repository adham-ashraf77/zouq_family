import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:zouqadmin/I10n/app_localizations.dart';
import 'package:zouqadmin/theme/common.dart';

class ContactPage extends StatefulWidget {
  var data;

  ContactPage({this.data});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  String _email;
  String _phone;
  String _message;
  String _countryCode = "+966";

  validation() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      final Email email = Email(
        body: '$_message',
        subject: ' $_phone ' + 'رساله تواصل من عميل',
        recipients: ['${widget.data['email']}'],
        cc: ['$_email'],
        bcc: ['$_email'],
        isHTML: false,
      );

      await FlutterEmailSender.send(email);
    }
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
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('contactUs'),
          style: moreTextStyle.copyWith(fontSize:18),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          children: <Widget>[

//            Center(
//              child: Text(
//                AppLocalizations.of(context).translate('appInfo'),
//                style: moreTextStyle1,
//              ),
//            ),

            Center(
              child: Text(
                AppLocalizations.of(context).translate('contactManagement'),
                style: moreTextStyle1.copyWith(fontSize:15),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
//            ListTile(
//              leading: Text(
//                AppLocalizations.of(context).translate('email'),
//                style: moreTextStyle1,
//              ),
//              title: Align(
//                alignment: Alignment.centerLeft,
//                child: Text(
//                  widget.data['email'],
//                  style: paragarph1,
//                ),
//              ),
//              trailing: CircleAvatar(
//                radius: 15.0,
//                backgroundColor: accent,
//                child: Icon(
//                  Icons.alternate_email,
//                  color: Colors.white,
//                ),
//              ),
//            ),
//            Divider(
//              color: iconsFaded,
//              indent: 25,
//            ),
            ListTile(
              leading: Text(
                AppLocalizations.of(context).translate('telephone'),
                style: moreTextStyle1.copyWith(fontSize:15),
              ),
              title: Text(
                widget.data['phone'],
                style: paragarph1.copyWith(fontSize:15),
              ),
              trailing: CircleAvatar(
                radius: 15.0,
                backgroundColor: accent,
                child: Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
              ),
            ),
//            Divider(
//              color: iconsFaded,
//              indent: 25,
//            ),
//            SizedBox(
//              height: 15.0,
//            ),
//            Center(
//              child: Text(
//                AppLocalizations.of(context).translate('contactManagement'),
//                style: moreTextStyle1,
//              ),
//            ),
//            Form(
//              key: _formKey,
//              child: Padding(
//                padding: const EdgeInsets.symmetric(horizontal: 15),
//                child: Column(
//                  children: <Widget>[
//                    TextFormField(
//                      decoration: InputDecoration(
//                          hintText: AppLocalizations.of(context).translate('name'), hintStyle: hintTextStyle),
//                      onSaved: (value) {
//                        _name = value;
//                      },
//                      validator: (value) {
//                        if (value.trim().length < 3) {
//                          return AppLocalizations.of(context).translate('nameError');
//                        }
//                        return null;
//                      },
//                    ),
//                    TextFormField(
//                      decoration: InputDecoration(
//                          hintText: AppLocalizations.of(context).translate('email'), hintStyle: hintTextStyle),
//                      onSaved: (value) {
//                        _email = value;
//                      },
//                      validator: (value) {
//                        bool isValid = EmailValidator.validate(value);
//                        if (value.isEmpty || isValid == false) {
//                          return AppLocalizations.of(context).translate('emailError');
//                        }
//                        return null;
//                      },
//                    ),
//                    Row(
//                      children: <Widget>[
//                        Expanded(
//                          child: TextFormField(
//                            maxLength: 12,
//                            decoration: InputDecoration(
//                                counterText: "",
//                                hintText: AppLocalizations.of(context).translate('telephone'),
//                                hintStyle: hintTextStyle),
//                            onSaved: (value) {
//                              _phone = value;
//                            },
//                            validator: (value) {
//                              if (value.trim().length == 0 || ((_countryCode + value).trim()).length < 11) {
//                                return AppLocalizations.of(context).translate('phoneError');
//                              }
//                              return null;
//                            },
//                          ),
//                        ),
//                        SizedBox(
//                          width: 10,
//                        ),
//                        Container(
//                          height: 55,
//                          child: CountryCodePicker(
//                            onChanged: _onCountryChange,
//                            initialSelection: 'SA',
//                            favorite: ['+966', 'SA'],
//                          ),
//                          decoration: BoxDecoration(
//                            border: Border(
//                              bottom: BorderSide(width: 1),
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                    SizedBox(
//                      height: 25,
//                    ),
//                    Container(
//                        height: 150.0,
//                        padding: EdgeInsets.all(10.0),
//                        decoration: BoxDecoration(border: Border.all(width: 0.5), borderRadius: BorderRadius.circular(15.0)),
//                        child: TextFormField(
//                          decoration: InputDecoration(
//                              border: InputBorder.none,
//                              hintText: AppLocalizations.of(context).translate('message'),
//                              hintStyle: hintTextStyle),
//                          onChanged: (value) {
//                            _message = value;
//                          },
//                          validator: (value) {
//                            if (value.trim().length < 3 || value.trim().length > 500) {
//                              return AppLocalizations.of(context).translate('messageError');
//                            }
//                            return null;
//                          },
//                        )),
//                    SizedBox(
//                      height: 15,
//                    ),
//                    AppButton(
//                      text: AppLocalizations.of(context).translate('send'),
//                      onClick: () {
//                        validation();
//                      },
//                    )
//                  ],
//                ),
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}

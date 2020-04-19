import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/I10n/app_localizations.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/services/setnewphonenumber.dart';
import 'package:zouqadmin/theme/common.dart';

class SetNewPhoneNumberScreen extends StatefulWidget {
  final String phone;

  const SetNewPhoneNumberScreen({this.phone});

  @override
  _SetNewPhoneNumberScreenState createState() =>
      _SetNewPhoneNumberScreenState(phone: this.phone);
}

class _SetNewPhoneNumberScreenState extends State<SetNewPhoneNumberScreen> {
  final String phone;

  _SetNewPhoneNumberScreenState({this.phone});
  final _formKey = GlobalKey<FormState>();
  final phoneTextFieldController = TextEditingController();
  String _countryCode = '966';
  @override
  void dispose() {
    phoneTextFieldController.dispose();
    super.dispose();
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      this._countryCode = countryCode.toString();
    });
    // print("New Country selected: " + countryCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    print('Phone ' + this.phone);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'كــود التحقق', //AppLocalizations.of(context).translate('verifyCode'),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        'رقم الهاتف الجديد',
                        style: moreTextStyle,
                      ),
                    ),
                    SizedBox(
                      height: 70.0,
                    ),
                    ListTile(
                      title: Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: TextFormField(
                                controller: phoneTextFieldController,
                                validator: (value) {
                                  if (value.trim().length < 9) {
                                    return 'please enter a valid phone number';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    // border: InputBorder.none,
                                    hintText: 'رقم الهاتف الجديد',
                                    hintStyle: hintTextStyle),
                              ),
                              // decoration: BoxDecoration(
                              //   border: Border(
                              //     bottom:
                              //         BorderSide(color: iconsFaded, width: 1),
                              //   ),
                              // ),
                            ),
                          ),
                        ],
                      ),
                      trailing: Container(
                        height: 55,
                        child: CountryCodePicker(
                          initialSelection: 'SA',
                          favorite: ['+966', 'SA'],
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: iconsFaded, width: 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 65,
                      child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          color: accent,
                          child: Text(
                            'تعديل',
                            // AppLocalizations.of(context).translate('edit'),
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              SetNewPhoneNumber()
                                  .setNewPhoneNumber(
                                      _countryCode.replaceAll('+', '') +
                                          phoneTextFieldController.text)
                                  .then((onValue) {
                                if (onValue.toString() == 'success') {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          DialogWorning(
                                            mss:
                                                'Phone has been updated successfully',
                                          ));
                                } else {
                                  print(onValue.toString());
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          DialogWorning(
                                            mss:
                                                'Something went wrong please check your input and try again',
                                          ));
                                }
                              });
                            }
                          }),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

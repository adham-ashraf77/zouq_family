import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/I10n/app_localizations.dart';
import 'package:zouqadmin/pages/auth/phoneupdatingconfirmationcode.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/services/editphone.dart';
import 'package:zouqadmin/services/getuser.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';

class EditPhoneNumberPage extends StatefulWidget {
  @override
  _EditPhoneNumberPageState createState() => _EditPhoneNumberPageState();
}

class _EditPhoneNumberPageState extends State<EditPhoneNumberPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneTextFieldController = TextEditingController();
  String phone;
      SharedPreferences prefs;

  @override
  void dispose() {
    phoneTextFieldController.dispose();
    super.dispose();
  }

  
  
  @override
  void didChangeDependencies() {
     SharedPreferences.getInstance().then((onValue){
       var token = onValue.getString('token');
          GetUser().getUser(token: token).then((onValue){
              var user = jsonDecode(onValue.toString());
              setState(() {
                phone = user['user']['phone'].toString();
                phoneTextFieldController.text = phone;
              });
          });

     });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'ذوق',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
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
                        'تعديل رقم الهاتف',
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
                                enabled: false,
                                controller: phoneTextFieldController,
                                validator: (value) {
                                  if (value.trim().length < 9) {
                                    return 'please enter a valid phone number';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    // border: InputBorder.none,
                                    hintText: phone == null ? 'رقم الهاتف' : phone,
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
                            'send',
                            style:
                                TextStyle(color: Colors.white, fontSize: 25.0),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              UpdatePhone()
                                  .updatePhone(
                                      phoneTextFieldController.text)
                                  .then((onValue) {
                                if (onValue.toString() == 'success') {
                                  pushPage(
                                      context,
                                      PhoneUpdatingCOnfirmationCode(
                                        phone:
                                            
                                                phoneTextFieldController.text,
                                      ));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          DialogWorning(
                                            mss:
                                                'Something went wrong or invalid phone number please check your input and try again',
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

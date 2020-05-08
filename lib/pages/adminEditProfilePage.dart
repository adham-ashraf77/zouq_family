import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/pages/editPhoneNumberPage.dart';
import 'package:zouqadmin/services/editprofile.dart';
import 'package:zouqadmin/services/getuser.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';

import '../I10n/app_localizations.dart';

enum DeliveryService { doesDelivery, noDelivery }

class AdminProfileEditor extends StatefulWidget {
  @override
  _AdminProfileEditorState createState() => _AdminProfileEditorState();
}

class _AdminProfileEditorState extends State<AdminProfileEditor> {
  DeliveryService selectedDeliveryService;
  String dropdownValue = 'one';
  final descTextFieldController = TextEditingController();
  final oldPassTextFieldController = TextEditingController();
  final newPassTextFieldController = TextEditingController();
  final newPassConfirmTextFieldController = TextEditingController();
  bool isdeliveryAvailable = false;
  final _formKey = GlobalKey<FormState>();
  void _onisdeliveryAvailableChanged(bool newValue) => setState(() {
        isdeliveryAvailable = newValue;
      });
  @override
  void dispose() {
    descTextFieldController.dispose();
    oldPassTextFieldController.dispose();
    newPassTextFieldController.dispose();
    newPassConfirmTextFieldController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    //  SharedPreferences.getInstance().then((onValue){
    //    GetUser().getUser(token: onValue.getString('token')).then((onValue){

    //    });
    //  });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('editProfile'),
          style: moreTextStyle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(profileImg)),
              ),
            ),
//            SizedBox(
//              height: 25.0,
//            ),
//            ListTile(
//              title: Row(
//                children: <Widget>[
//                  Expanded(
//                    child: TextField(
//                      decoration: InputDecoration(border: InputBorder.none, hintText: 'الاسم', hintStyle: hintTextStyle),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//            Divider(
//              color: Color(0xff888888),
//              indent: 25,
//            ),
//            ListTile(
//              title: Row(
//                children: <Widget>[
//                  Expanded(
//                    //TODO add email verification
//                    child: TextField(
//                      decoration:
//                          InputDecoration(border: InputBorder.none, hintText: 'البريد الاكترونى', hintStyle: hintTextStyle),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//            Divider(
//              color: Color(0xff888888),
//              indent: 25,
//            ),
//            ListTile(
//              title: Row(
//                children: <Widget>[
//                  Expanded(
//                    child: Container(
//                      child: TextField(
//                        decoration:
//                            InputDecoration(border: InputBorder.none, hintText: 'رقم الهاتف', hintStyle: hintTextStyle),
//                      ),
//                      decoration: BoxDecoration(
//                        border: Border(
//                          bottom: BorderSide(color: iconsFaded, width: 1),
//                        ),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//              trailing: Container(
//                height: 55,
//                child: CountryCodePicker(
//                  initialSelection: 'SA',
//                  favorite: ['+966', 'SA'],
//                ),
//                decoration: BoxDecoration(
//                  border: Border(
//                    bottom: BorderSide(color: iconsFaded, width: 1),
//                  ),
//                ),
//              ),
//            ),
//            SizedBox(
//              height: 25.0,
//            ),
            Center(
              child: Text(
                AppLocalizations.of(context).translate('changePassword'),
                style: moreTextStyle,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            TextFormField(
              controller: oldPassTextFieldController,
              validator: (value) {
                // if (value.trim().length < 6) {
                //   //todo translate
                //   return 'Password must be at least 6 characters';
                // }
                // else if(){} TODO check if value is same as old password
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText:
                      AppLocalizations.of(context).translate('oldPassword'),
                  hintStyle: hintTextStyle),
            ),

            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: newPassTextFieldController,
              obscureText: true,
              validator: (value) {
                if (value.trim().length < 6) {
                  //todo translate
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText:
                      AppLocalizations.of(context).translate('newPassword'),
                  hintStyle: hintTextStyle),
            ),

            SizedBox(
              height: 10.0,
            ),

            TextFormField(
              controller: newPassConfirmTextFieldController,
              obscureText: true,
              validator: (value) {
                if (value.trim().length < 6) {
                  //todo translate
                  return 'Password must be at least 6 characters';
                } else if (value != newPassTextFieldController.text) {
                  return "Passwords don't match";
                }
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText:
                      AppLocalizations.of(context).translate('newPassword'),
                  hintStyle: hintTextStyle),
            ),

            SizedBox(
              height: 25,
            ),
            ListTile(
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDeliveryService =
                              DeliveryService.doesDelivery;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedDeliveryService ==
                                      DeliveryService.doesDelivery
                                  ? accent
                                  : Color(0xFF636363),
                            ),
                            borderRadius: BorderRadius.circular(50)),
                        child: CircleAvatar(
                          child: Icon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          radius: 15.0,
                          backgroundColor: selectedDeliveryService ==
                                  DeliveryService.doesDelivery
                              ? accent
                              : Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('delivery'),
                      style: productName1,
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDeliveryService = DeliveryService.noDelivery;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedDeliveryService ==
                                      DeliveryService.noDelivery
                                  ? accent
                                  : Color(0xFF636363),
                            ),
                            borderRadius: BorderRadius.circular(50)),
                        child: CircleAvatar(
                          child: Icon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                          ),
                          radius: 15.0,
                          backgroundColor: selectedDeliveryService ==
                                  DeliveryService.noDelivery
                              ? accent
                              : Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      AppLocalizations.of(context).translate('noDelivery'),
                      style: productName1,
                    ),
                  ],
                ),
              ),
            ),
            DropdownButton(
              isExpanded: true,
              hint: Text(AppLocalizations.of(context).translate('selectCity')),
              value: dropdownValue,
              icon: Icon(
                Icons.arrow_drop_down,
                size: 24,
                color: accent,
              ),
              style: TextStyle(color: Colors.blue),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: <String>['one', 'two', 'three']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              maxLines: 2,
              controller: descTextFieldController,
              validator: (value) {
                if (value.trim().length < 20) {
                  //todo translate
                  return 'Please enter a valid desc, desc must me at least 20 characters';
                }
                return null;
              },
              decoration: InputDecoration(
                  // border: InputBorder.none,
                  hintText:
                      AppLocalizations.of(context).translate('description'),
                  hintStyle: hintTextStyle),
            ),
            SizedBox(
              height: 10,
            ),
            //TODO checkbox
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Checkbox(
                    value: isdeliveryAvailable,
                    onChanged: _onisdeliveryAvailableChanged),
                Text(
                  AppLocalizations.of(context).translate('isDeliveryAvailab/le'),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    //TODO admin phone editing
                    pushPage(context, EditPhoneNumberPage());
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('editPhone'),
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Text(
                  AppLocalizations.of(context).translate('or'),
                  style: TextStyle(color: Colors.black87),
                ),
                GestureDetector(
                  child: Text(
                    AppLocalizations.of(context).translate('changePassword'),
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            ListTile(
              title: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  color: accent,
                  child: Text(
                    AppLocalizations.of(context).translate('edit'),
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      UpdateProfile()
                          .updateProfile(
                              descTextFieldController.text,
                              isdeliveryAvailable ? '1' : '0',
                              newPassTextFieldController.text)
                          .then((onValue) {
                        print(onValue);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => DialogWorning(
                                  mss: onValue.toString() == 'success'
                                      ? 'Profile updated successfully'
                                      : 'Something went wrong please check your inputs and try again',
                                ));
                      });
                    }
                    //TODO admin profile editing code
                  }),
            ),
            SizedBox(
              height: 15,
            ),
            //TODO add last check box
          ],
        ),
      )),
    );
  }
}

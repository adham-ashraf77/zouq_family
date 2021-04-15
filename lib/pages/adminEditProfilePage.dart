import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/models/cities.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/pages/editPhoneNumberPage.dart';
import 'package:zouqadmin/services/editprofile.dart';
import 'package:zouqadmin/services/getData.dart';
import 'package:zouqadmin/services/getuser.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';

import '../I10n/app_localizations.dart';

enum DeliveryService { doesDelivery, noDelivery }

class AdminProfileEditor extends StatefulWidget {
  String avatarImageUrl;

  AdminProfileEditor({this.avatarImageUrl});

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
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTime2 = TimeOfDay.now();
  List<String> _showCity = [];
  String _city;

  int isdeliveryAvailable;
  String desc;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  void _onisdeliveryAvailableChanged(bool newValue) => setState(() {
        newValue == true ? isdeliveryAvailable = 1 : isdeliveryAvailable = 0;
      });

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });

    if (pickedTime != null && pickedTime != selectedTime)
      setState(() {
        selectedTime = pickedTime;
        print("${pickedTime.hour}:${pickedTime.minute}:00");
      });
  }

  Future<void> _selectTime2(BuildContext context) async {
    final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime2,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });

    if (pickedTime != null && pickedTime != selectedTime2)
      setState(() {
        selectedTime2 = pickedTime;
        print("${pickedTime.hour}:${pickedTime.minute}:00");
      });
  }

  List<Cities> _allCity = [];
  bool _isLooding = false;

  save() async {
    await GetData().getCity();
    setState(() {
      _allCity = GetData.arCity;
      _allCity.forEach((d) {
        _showCity.add(d.text);
      });
    });
    setState(() {
      _isLooding = false;
    });
  }

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

  getUserData() {
    SharedPreferences.getInstance().then((onValue) {
      GetUser().getUser(token: onValue.getString('token')).then((value) {
        isdeliveryAvailable = value['user']['is_delivery_available'];
        desc = value['user']['description'] ?? "";
        if (desc.isNotEmpty) descTextFieldController.text = desc;
        isdeliveryAvailable == 1
            ? selectedDeliveryService = DeliveryService.doesDelivery
            : selectedDeliveryService = DeliveryService.noDelivery;
        print(isdeliveryAvailable);
        print(selectedDeliveryService);
      });
    });
  }

  String fileName = '';
  File _image;
  bool _loodingImage = false;

  Future getImage(BuildContext context) async {
    // try {
    setState(() {
      _loodingImage = true;
    });
    var file = await selectImg(context);
    setState(() {
      fileName = path.basename(file.path);
      _image = file;
    });
    setState(() {
      _loodingImage = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('editProfile'),
          style: moreTextStyle.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: _isLooding
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                children: <Widget>[
                  Center(
                    child: Text("تعديل الصوره",
                        style: moreTextStyle.copyWith(fontSize: 15)),
                  ),
                  _loodingImage
                      ? CircularProgressIndicator()
                      : InkWell(
                          onTap: () => getImage(context),
                          child: SizedBox(
                            width: 70,
                            height: 70,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 50,
                                backgroundImage: widget.avatarImageUrl == null
                                    ? AssetImage(profileImg)
                                    : _image == null
                                        ? NetworkImage(
                                            '${widget.avatarImageUrl}')
                                        : FileImage(_image),
                              ),
                            ),
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
                  SizedBox(
                    height: 15.0,
                  ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context).translate('changePassword'),
                      style: moreTextStyle.copyWith(fontSize: 15),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: newPassTextFieldController,
                    obscureText: true,
                    validator: (value) {
                      if (newPassConfirmTextFieldController.text.isNotEmpty) {
                        if (value.trim().length < 6) {
                          //todo translate
                          return AppLocalizations.of(context)
                              .translate('passwordShortError');
                        }
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        // border: InputBorder.none,
                        hintText: AppLocalizations.of(context)
                            .translate('newPassword'),
                        hintStyle: hintTextStyle),
                  ),

                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: newPassConfirmTextFieldController,
                    obscureText: true,
                    validator: (value) {
                      if (newPassConfirmTextFieldController.text.isNotEmpty) {
                        if (value.trim().length < 6) {
                          //todo translate
                          return AppLocalizations.of(context)
                              .translate('passwordShortError');
                        } else if (value != newPassTextFieldController.text) {
                          return AppLocalizations.of(context)
                              .translate('passwordMatchError');
                        }
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        // border: InputBorder.none,
                        hintText: AppLocalizations.of(context)
                            .translate('newPassword'),
                        hintStyle: hintTextStyle),
                  ),

                  SizedBox(
                    height: 25,
                  ),
                  ListTile(
                    title: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDeliveryService =
                                      DeliveryService.doesDelivery;
                                  isdeliveryAvailable = 1;
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
                              width: 3.0,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('delivery'),
                              style: productName1.copyWith(fontSize: 15),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedDeliveryService =
                                      DeliveryService.noDelivery;
                                  isdeliveryAvailable = 0;
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
                              width: 5.0,
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('noDelivery'),
                              style: productName1.copyWith(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
//            DropdownButton(
//              isExpanded: true,
//              hint: Text('select a city'),
//              value: dropdownValue,
//              icon: Icon(
//                Icons.arrow_drop_down,
//                size: 24,
//                color: accent,
//              ),
//              style: TextStyle(color: Colors.blue),
//              onChanged: (String newValue) {
//                setState(() {
//                  dropdownValue = newValue;
//                });
//              },
//              items: <String>['one', 'two', 'three']
//                  .map<DropdownMenuItem<String>>((String value) {
//                return DropdownMenuItem<String>(
//                  value: value,
//                  child: Text(
//                    value,
//                    style: TextStyle(color: Colors.black),
//                  ),
//                );
//              }).toList(),
//            ),
                  GestureDetector(
                    onTap: () => _selectTime(context),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Text("من"),
                          ),
                          Text(
                              "${selectedTime.hour}:${selectedTime.minute}:00"),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _selectTime2(context),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Text("الى"),
                          ),
                          Text(
                              "${selectedTime2.hour}:${selectedTime2.minute}:00"),
                        ],
                      ),
                    ),
                  ),
                  SearchableDropdown.single(
                    items:
                        _showCity.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: _city,
                    hint: AppLocalizations.of(context).translate('chooseCity'),
                    searchHint:
                        AppLocalizations.of(context).translate('chooseCity'),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color.fromRGBO(29, 174, 209, 1),
                      size: 35,
                    ),
                    underline: Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _city = value;
                      });
                    },
                    isExpanded: true,
                  ),
                  TextFormField(
                    maxLines: 2,
                    controller: descTextFieldController,
//                  validator: (value) {
//                    if (desc.isEmpty) {
//                      if (value
//                          .trim()
//                          .length < 20) {
//                        //todo translate
//                        return AppLocalizations.of(context).translate('descValidError');
//                      }
//                    }
//                    return null;
//                  },
                    decoration: InputDecoration(
                      // border: InputBorder.none,
                      labelText:
                          AppLocalizations.of(context).translate('description'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  //TODO checkbox
//            Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                Checkbox(
//                    value: isdeliveryAvailable,
//                    onChanged: _onisdeliveryAvailableChanged),
//                Text(
//                  AppLocalizations.of(context).translate('isDeliveryAvailable'),
//                ),
//              ],
//            ),
//            SizedBox(
//              height: 15,
//            ),
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
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        onPressed: () {
                          int idCity;
                          Cities city =
                              _allCity.firstWhere((c) => c.text == _city);
                          idCity = city.id;
                          if (_formKey.currentState.validate()) {
                            UpdateProfile()
                                .updateProfile(
                                    ida: isdeliveryAvailable == 1 ? '1' : '0',
                                    desc: descTextFieldController
                                                .text.isNotEmpty ==
                                            true
                                        ? descTextFieldController.text
                                        : desc.isEmpty
                                            ? "..."
                                            : desc,
                                    cityID: idCity,
                                    newPassword:
                                        newPassTextFieldController.text,
                                    openingFrom:
                                        "${selectedTime.hour}:${selectedTime.minute}:00",
                                    openingTo:
                                        "${selectedTime2.hour}:${selectedTime2.minute}:00",
                                    image: _image)
                                .then((onValue) {
                              print(onValue);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      DialogWorning(
                                        mss: onValue.toString() == 'success'
                                            ? AppLocalizations.of(context)
                                                .translate('success')
                                            : AppLocalizations.of(context)
                                                .translate('failed'),
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

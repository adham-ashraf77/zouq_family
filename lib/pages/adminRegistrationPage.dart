import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/pages/accountFrozen.dart';
import 'package:zouqadmin/pages/accountNotActivated.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zouqadmin/widgets/filterChipWidget.dart';

enum DeliveryService { doesDelivery, noDelivery }
List<String> tags = ['sweets', 'local', 'pastries'];
List<bool> selected = [false, false, false];

class AdminRegistration extends StatefulWidget {
  @override
  _AdminRegistrationState createState() => _AdminRegistrationState();
}

class _AdminRegistrationState extends State<AdminRegistration> {
  DeliveryService selectedDeliveryService;
  String dropdownValue = 'one';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Center(
              child: Text(
                'تسجيل كأسرة المنتجة',
                style: moreTextStyle,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(profileImg)),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'أسم المشترك',
                          hintStyle: hintTextStyle),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Color(0xff888888),
              indent: 25,
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'رقم الهاتف',
                            hintStyle: hintTextStyle),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: iconsFaded, width: 1),
                        ),
                      ),
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
            ListTile(
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'البريد الاكترونى',
                          hintStyle:
                              hintTextStyle), //TODO email verification logic
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Color(0xff888888),
              indent: 25,
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'كلمة السر',
                          hintStyle: hintTextStyle),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Color(0xff888888),
              indent: 25,
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDeliveryService = DeliveryService.doesDelivery;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF636363),
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
                    'خدمة توصيل',
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
                            color: Color(0xFF636363),
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
                    'لا يقدم الخدمة',
                    style: productName1,
                  ),
                ],
              ),
            ),
            //TODO revise code and add retrive selected item index logic
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: double.infinity,
              child: Wrap(
                spacing: 7,
                runSpacing: 7,
                children: <Widget>[
                  FilterChipWidget(
                    chipName: tags[0],
                    isSelected: selected[0],
                    onSelect: (clicked) {
                      setState(() {
                        selected[0] = clicked;
                      });
                    },
                  ),
                  FilterChipWidget(
                    chipName: tags[1],
                    isSelected: selected[1],
                    onSelect: (clicked) {
                      setState(() {
                        selected[1] = clicked;
                      });
                    },
                  ),
                  FilterChipWidget(
                    chipName: tags[2],
                    isSelected: selected[2],
                    onSelect: (clicked) {
                      setState(() {
                        selected[2] = clicked;
                      });
                    },
                  ),
                ],
              ),
            ),
            //TODO fill dropdown button with data from api
            DropdownButton(
              isExpanded: true,
              hint: Text('select city'),
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
            ListTile(
              title: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  color: accent,
                  child: Text(
                    'تسجيل',
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                  onPressed: () {
                    //TODO admin profile editing code
                    print(selected);
                  }),
            ),
            //TODO remove row testing alert dialogs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    color: accent,
                    child: Text(
                      'test non-active',
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              AccountNotActivatedDialog());
                    }),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0)),
                    color: accent,
                    child: Text(
                      'test frozen',
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              AccountFrozenDialog());
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}

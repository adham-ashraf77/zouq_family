import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:zouqadmin/theme/common.dart';

enum DeliveryService { doesDelivery, noDelivery }

class AdminProfileEditor extends StatefulWidget {
  @override
  _AdminProfileEditorState createState() => _AdminProfileEditorState();
}

class _AdminProfileEditorState extends State<AdminProfileEditor> {
  DeliveryService selectedDeliveryService;
  String dropdownValue = 'one';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_forward,
                color: Color(0xff8c8c8c),
              ),
            ),
          ),
          Center(
            child: Text(
              'تعديل الملف الشخصى',
              style: moreTextStyle,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(profileImg)),
            ),
          ),
          SizedBox(
            height: 25.0,
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'الاسم',
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
                  //TODO add email verification
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'البريد الاكترونى',
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
          SizedBox(
            height: 25.0,
          ),
          Center(
            child: Text(
              'تعديل كلمة المرور',
              style: moreTextStyle,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'كلمة السر القديمة',
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
          SizedBox(
            height: 30.0,
          ),
          ListTile(
            title: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'كلمة السر الجديدة',
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
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'كلمة السر الجديدة',
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
                      backgroundColor:
                          selectedDeliveryService == DeliveryService.noDelivery
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
          SizedBox(
            height: 50.0,
          ),
          ListTile(
            title: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0)),
                color: accent,
                child: Text(
                  'تعديل',
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                ),
                onPressed: () {
                  //TODO admin profile editing code
                }),
          ),
          //TODO add last check box
        ],
      )),
    );
  }
}

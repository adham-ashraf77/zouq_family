import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zouqadmin/pages/adminEditProfilePage.dart';
import 'package:zouqadmin/pages/adminWalletPage.dart';
import 'package:zouqadmin/theme/common.dart';

class AdminOptionsPage extends StatefulWidget {
  @override
  _AdminOptionsPageState createState() => _AdminOptionsPageState();
}

class _AdminOptionsPageState extends State<AdminOptionsPage> {
  bool _isLoggedIn = true;

  IconData trailingIcon = Icons.arrow_forward_ios;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: <Widget>[
          Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 10.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminProfileEditor(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Color(0xff8c8c8c),
                  ),
                ),
              )),
          Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: _isLoggedIn == true
                      ? AssetImage(profileImg)
                      : AssetImage(
                          profileImg)), //TODO add server image if _isLoggedIn is true
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Center(
            child: Text(
              _isLoggedIn == true ? 'أسم الأسرة المنتجة' : 'زائر جديد',
              style: moreTextStyle,
            ),
          ),
          Visibility(
            visible: _isLoggedIn,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminWalletPage()));
              },
              child: ListTile(
                leading: Text("المحفظة", style: moreTextStyle),
                trailing: Text(
                  "450 ريال",
                  style: moreSmallTextStyle,
                ),
              ),
            ),
          ),
          Divider(
            color: iconsFaded,
            indent: 25,
          ),
          ListTile(
            trailing: Icon(
              trailingIcon,
              size: 15.0,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  "العربية",
                  style: moreSmallTextStyle,
                ),
              ],
            ),
            leading: Text("اللغة", style: moreTextStyle),
          ),
          Divider(
            color: iconsFaded,
            indent: 25,
          ),
          GestureDetector(
            onTap: () {
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => ContactPage()));
            },
            child: ListTile(
              trailing: Icon(
                trailingIcon,
                size: 15.0,
              ),
              leading: Text(
                "اتصل بنا",
                style: moreTextStyle,
                textAlign: TextAlign.end,
              ),
            ),
          ),
          Divider(
            color: iconsFaded,
            indent: 25,
          ),
          ListTile(
            trailing: Icon(
              trailingIcon,
              size: 15.0,
            ),
            leading: Text(
              "قيم التطبيق",
              style: moreTextStyle,
              textAlign: TextAlign.end,
            ),
          ),
          Divider(
            color: iconsFaded,
            indent: 25,
          ),
          ListTile(
            trailing: Icon(
              trailingIcon,
              size: 15.0,
            ),
            leading: Text(
              "سياسة الاستخدام",
              style: moreTextStyle,
              textAlign: TextAlign.end,
            ),
          ),
          Divider(
            color: iconsFaded,
            indent: 25,
          ),
          ListTile(
            trailing: Icon(
              trailingIcon,
              size: 15.0,
            ),
            leading: Text(
              "الاسئلة الشائعة",
              style: moreTextStyle,
              textAlign: TextAlign.end,
            ),
          ),
          Divider(
            color: iconsFaded,
            indent: 25,
          ),
          ListTile(
            leading: GestureDetector(
              onTap: () {
//                if (_isLoggedIn == true) {
//                  showDialog(
//                      context: context,
//                      builder: (BuildContext context) => LogoutDialog());
//                } else {
//                  setState(() {
//                    _isLoggedIn = true;
//                  });
//                }
              },
              child: Text(
                _isLoggedIn == true ? 'تسجيل الخروج' : 'تسجيل الدخول',
                style: moreTextStyle.copyWith(
                    color: _isLoggedIn == true ? rejectedColor : doneColor),
                textAlign: TextAlign.end,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: CircleAvatar(
                  backgroundColor: Color(0xffdb4a39),
                  child: IconButton(
                    onPressed: () {
                      //TODO add google+ pageview
                    },
                    icon: Icon(
                      FontAwesomeIcons.googlePlusG,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: CircleAvatar(
                  backgroundColor: Color(0xff4267b2),
                  child: IconButton(
                    onPressed: () {
                      //TODO add facebook pageview
                    },
                    icon: Icon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 60.0,
          ),
        ],
      ),
    );
  }
}

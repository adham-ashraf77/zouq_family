import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zouqadmin/I10n/AppLanguage.dart';
import 'package:zouqadmin/pages/adminEditProfilePage.dart';
import 'package:zouqadmin/pages/adminWalletPage.dart';
import 'package:zouqadmin/pages/auth/login_screen.dart';
import 'package:zouqadmin/services/getuser.dart';
import 'package:zouqadmin/services/userLanguage.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/networking.dart';

import '../I10n/app_localizations.dart';
import 'appInfo/EULAPage.dart';
import 'appInfo/FAQPage.dart';
import 'chat/conversationsLIst.dart';
import 'contactPage.dart';

class AdminOptionsPage extends StatefulWidget {
  @override
  _AdminOptionsPageState createState() => _AdminOptionsPageState();
}

class _AdminOptionsPageState extends State<AdminOptionsPage> {
  IconData trailingIcon = Icons.arrow_forward_ios;
  String name;
  String avatarImageUrl;
  String wallet;
  String token;
  var links;

  getLocation() async {
    try {
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      await Dio().post('https://api.dhuqapp.com/api/family/set-location',
          data: {
            "latitude": "${position.latitude}",
            "longitude": "${position.longitude}",
          },
          options: Options(
              headers: {HttpHeaders.authorizationHeader: "Bearer $token"}));
      print('location success');
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text(
            "${AppLocalizations.of(context).translate('locationSuccess')}"),
      ));
    } on DioError catch (e) {
      print('error in get position');
      print(e.response.data);
    } catch (e) {
      print("no location");
    }
  }

  @override
  void didChangeDependencies() {
    SharedPreferences.getInstance().then((onValue) {
      String token = onValue.getString('token');
      GetUser().getUser(token: token).then((value) {
        var x = value;
        print('X = ' + x['user'].toString());
        setState(() {
          print('[${wallet.toString()}]');
          name = x['user']['name'];
          avatarImageUrl = x['user']['image'];
          wallet = x['user']['wallet'].toString();
          print('[$wallet]');
        });
      });
    });
    super.didChangeDependencies();
  }

  getData() async {
    var data = await NetworkHelper().getSocialMedia();
    links = data;
  }

  launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'could not launch $url';
    }
  }

  Widget popUp() {
    var appLanguage = Provider.of<AppLanguage>(context);
    return CupertinoActionSheet(
      title: new Text(AppLocalizations.of(context).translate('language')),
      message: new Text(AppLocalizations.of(context).translate('chooselang')),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: new Text('English'),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String token = prefs.getString('token');
            UserLanguage().setLang(token: token, lang: "en");
            appLanguage.changeLanguage(Locale("en"));
            Navigator.of(context).pop();
          },
        ),
        CupertinoActionSheetAction(
          child: new Text('العربية'),
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String token = prefs.getString('token');
            UserLanguage().setLang(token: token, lang: "ar");
            appLanguage.changeLanguage(Locale("ar"));
            Navigator.of(context).pop();
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: new Text(AppLocalizations.of(context).translate('cancel')),
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context, 'Cancel');
        },
      ),
    );
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    Response response = await Dio().get("path");
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                          builder: (context) => AdminProfileEditor(
                            avatarImageUrl: avatarImageUrl,
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Color(0xff8c8c8c),
                    ),
                  ),
                )),
            // Container(
            //   height: MediaQuery.of(context).size.height * 0.15,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(50),
            //     image: DecorationImage(
            //         image: avatarImageUrl == null
            //             ? AssetImage(profileImg)
            //             : NetworkImage(
            //                 '$avatarImageUrl')), //TODO add server image if _isLoggedIn is true
            //   ),
            // ),
            CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 50,
                backgroundImage: avatarImageUrl == null
                    ? AssetImage(profileImg)
                    : NetworkImage('$avatarImageUrl')),

            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Text(
                this.name == null
                    ? AppLocalizations.of(context).translate('loading')
                    : this.name,
                style: moreTextStyle,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminWalletPage(wallet)));
              },
              child: ListTile(
                leading: Text(AppLocalizations.of(context).translate('wallet'),
                    style: moreTextStyle),
                trailing: Text(
                  wallet.toString() == 'null' ? 'خطأ' : "$wallet ريال",
                  style: moreSmallTextStyle,
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
                    AppLocalizations.of(context).translate('lang'),
                    style: moreSmallTextStyle,
                  ),
                ],
              ),
              leading: Text(AppLocalizations.of(context).translate('language'),
                  style: moreTextStyle),
              onTap: () => showCupertinoModalPopup(
                  context: context, builder: (BuildContext context) => popUp()),
            ),
            Divider(
              color: iconsFaded,
              indent: 25,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConversationsListScreen()));
              },
              child: ListTile(
                trailing: Icon(
                  trailingIcon,
                  size: 15.0,
                ),
                leading: Text(
                  AppLocalizations.of(context).translate('conversations'),
                  style: moreTextStyle,
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            Divider(
              color: iconsFaded,
              indent: 25,
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
                  AppLocalizations.of(context).translate('storeLocation'),
                  style: moreTextStyle),
              onTap: () => getLocation(),
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
                onTap: () async {
                  var data = await NetworkHelper().getContactInfo();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContactPage(
                                data: data,
                              )));
                },
                trailing: Icon(
                  trailingIcon,
                  size: 15.0,
                ),
                leading: Text(
                  AppLocalizations.of(context).translate('contactUs'),
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
              onTap: () async {
                var data = await NetworkHelper().getEULA();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EULAPage(
                              data: data,
                            )));
              },
              trailing: Icon(
                trailingIcon,
                size: 15.0,
              ),
              leading: Text(
                AppLocalizations.of(context).translate('EULA'),
                style: moreTextStyle,
                textAlign: TextAlign.end,
              ),
            ),
            Divider(
              color: iconsFaded,
              indent: 25,
            ),
            ListTile(
              onTap: () async {
                var data = await NetworkHelper().getFAQ();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FAQPage(
                              data: data,
                            )));
              },
              trailing: Icon(
                trailingIcon,
                size: 15.0,
              ),
              leading: Text(
                AppLocalizations.of(context).translate('FAQ'),
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
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                  AppLocalizations.of(context).translate('signOut'),
                  style: moreTextStyle.copyWith(color: rejectedColor),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: CircleAvatar(
                      backgroundColor: Color(0xff128C7E),
                      child: IconButton(
                        onPressed: () {
                          launchURL(links['whatsapp']);
                        },
                        icon: Icon(
                          FontAwesomeIcons.whatsappSquare,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: CircleAvatar(
                      backgroundColor: Color(0xffc4302b),
                      child: IconButton(
                        onPressed: () {
                          launchURL("${links['youtube']}");
                        },
                        icon: Icon(
                          FontAwesomeIcons.youtubeSquare,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: CircleAvatar(
                      backgroundColor: Color(0xffE1306C),
                      child: IconButton(
                        onPressed: () {
                          launchURL("${links['instagram']}");
                        },
                        icon: Icon(
                          FontAwesomeIcons.instagram,
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
                          launchURL("${links['facebook']}");
                        },
                        icon: Icon(
                          FontAwesomeIcons.facebookSquare,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: IconButton(
                        onPressed: () {
                          launchURL("${links['snapchat']}");
                        },
                        icon: Icon(
                          FontAwesomeIcons.snapchatSquare,
                          color: Color(0xffFFFC00),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: CircleAvatar(
                      backgroundColor: Color(0xff00acee),
                      child: IconButton(
                        onPressed: () {
                          launchURL("${links['twitter']}");
                        },
                        icon: Icon(
                          FontAwesomeIcons.twitterSquare,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 60.0,
            ),
          ],
        ),
      ),
    );
  }
}

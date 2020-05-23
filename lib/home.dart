import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/pages/adminOptionsPage.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/pages/ordersPage.dart';
import 'package:zouqadmin/pages/productsPage.dart';
import 'package:zouqadmin/services/getuser.dart';
import 'package:zouqadmin/services/notifications.dart';
import 'package:zouqadmin/theme/common.dart';

import 'I10n/app_localizations.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  bool isLoading = false;
  var user;
  
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String fcmToken = "";
  Dio dio = new Dio();
  Response response;

  fireBaseNotifications() async {
    _fcm.requestNotificationPermissions(IosNotificationSettings());
    fcmToken = await _fcm.getToken();
    print("device token $fcmToken");
    Notifications().sendFcmToken(fcmToken: fcmToken);

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(
                Platform.isIOS
                    ? message['aps']['alert']['title']
                    : message['notification']['title'],
              ),
              subtitle: Text(
                Platform.isIOS
                    ? message['aps']['alert']['body']
                    : message['notification']['body'],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  final List<Widget> _children = [
    OrdersPage(),
    ProductsPage(),
    AdminOptionsPage()
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    setState(() {
      isLoading = true;
    });
    SharedPreferences.getInstance().then((onValue) {
      String token = onValue.getString('token');
      if (token == null) {
        setState(() {
          isLoading = false;
        });
      } else {
        GetUser().getUser(token: token).then((onValue) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          setState(() {
            user = onValue;
            prefs.setString("userId", "${user["user"]["id"]}");
            print('user info : $user');
            isLoading = false;
          });
        }).catchError((onError) {
          print('Error ' + onError.toString());
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogWorning(
                    mss: onError.toString(),
                  ));
          user = 'failure';
          setState(() {
            isLoading = false;
          });
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    fireBaseNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey[400],
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.grey[300]),
                      strokeWidth: 2,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).translate('loading'),
                    textDirection: TextDirection.ltr,
                    style:
                        paragarph4.copyWith(color: Colors.grey[400], height: 2),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            body: _children[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  title: Text(AppLocalizations.of(context).translate('home')),
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  title: Text(AppLocalizations.of(context).translate('myProducts')),
                  icon: Icon(Icons.shopping_cart),
                ),
                BottomNavigationBarItem(
                  title: Text(AppLocalizations.of(context).translate('more')),
                  icon: Icon(Icons.more_horiz),
                ),
              ],
            ),
          );
  }
}

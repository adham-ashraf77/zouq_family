import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/pages/adminOptionsPage.dart';
import 'package:zouqadmin/pages/adminRegistrationPage.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/pages/ordersPage.dart';
import 'package:zouqadmin/pages/productsPage.dart';
import 'package:zouqadmin/services/getuser.dart';
import 'package:zouqadmin/theme/common.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  bool isLoading = false;
  var user;

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
        GetUser().getUser(token: token).then((onValue) {
          setState(() {
            user = onValue;
            print(user);
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
                    'Loading...',
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
                  title: Text('الرئيسية'),
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  title: Text('منتجاتى'),
                  icon: Icon(Icons.shopping_cart),
                ),
                BottomNavigationBarItem(
                  title: Text('المزيد'),
                  icon: Icon(Icons.more_horiz),
                ),
              ],
            ),
          );
  }
}

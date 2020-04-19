import 'package:flutter/material.dart';
import 'package:zouqadmin/pages/adminOptionsPage.dart';
import 'package:zouqadmin/pages/adminRegistrationPage.dart';
import 'package:zouqadmin/pages/ordersPage.dart';
import 'package:zouqadmin/pages/productsPage.dart';
import 'package:zouqadmin/theme/common.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [OrdersPage(), ProductsPage(), AdminOptionsPage()];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

import 'package:flutter/material.dart';
import 'package:zouqadmin/pages/adminEditProfilePage.dart';
import 'package:zouqadmin/services/editprofile.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';

class BottomNavigationbar extends StatefulWidget {
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: المزيد',
      style: optionStyle,
    ),
    Text(
      'Index 1: التنبيهات',
      style: optionStyle,
    ),
    Text(
      'Index 2: طلباتي',
      style: optionStyle,
    ),
    Text(
      'Index 3: الرئسية',
      style: optionStyle,
    ),
  ];

  @override
  _BottomNavigationbarState createState() => _BottomNavigationbarState();
}

class _BottomNavigationbarState extends State<BottomNavigationbar> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
      if(_selectedIndex == 0){
         pushPage(context, AdminProfileEditor());
        
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft:  Radius.circular(15),
            topRight: Radius.circular(15)
        ),
        child: BottomNavigationBar(

          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),

              title: Text('المزيد'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              title: Text('التنبيهات'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text('طلباتي'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('الرئسية'),
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.black,
          backgroundColor:  accent ,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

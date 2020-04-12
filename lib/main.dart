import 'package:flutter/material.dart';
import 'package:zouqadmin/pages/ordersViewPage.dart';
import 'package:zouqadmin/theme/common.dart';
import './pages/ordersPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zouq Admin',
      theme: appTheme,
      home: OrdersPage(),
      routes: {
        OrdersViewPage.routeName : (context) => OrdersViewPage(),
      }, ///Change this to `Home()` or `OrdersViewPage()` to view other pages!
    );
  }
}

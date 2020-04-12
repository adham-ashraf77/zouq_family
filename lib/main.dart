import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zouqadmin/pages/productsPage.dart';
import 'package:zouqadmin/theme/common.dart';
import 'home.dart';
import 'package:zouqadmin/pages/ordersViewPage.dart';
import 'package:zouqadmin/theme/common.dart';
import './pages/ordersPage.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("en", "US"),
        Locale("ar", "SA"),
      ],
      locale: Locale("ar", "SA"),

      title: 'Zouq Admin',
      theme: appTheme,
      home: OrdersPage(),
      routes: {
        OrdersViewPage.routeName : (context) => OrdersViewPage(),
      }, ///Change this to `Home()` or `OrdersViewPage()` to view other pages!

    );
  }
}

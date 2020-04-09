import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zouqadmin/pages/productsPage.dart';
import 'package:zouqadmin/theme/common.dart';

import 'home.dart';

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
      title: 'Flutter Demo',
      home: ProductsPage(),
      theme: appTheme,
    );
  }
}

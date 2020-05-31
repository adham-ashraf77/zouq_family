import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:zouqadmin/pages/ordersViewPage.dart';
import 'package:zouqadmin/splash_screen.dart';
import 'package:zouqadmin/theme/common.dart';

import 'I10n/AppLanguage.dart';
import 'I10n/app_localizations.dart';

//this app is made by: mohamed hamdy, mostafa, khaled doredar
// supervisor: rami ahmed
// testing and maintain: omar el-sherif, adham al nagar
// backend : abdel aziz

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(
    MyApp(
      appLanguage: appLanguage,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (_) => appLanguage,
      child: Consumer<AppLanguage>(builder: (context, model, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: model.appLocal,
          supportedLocales: [
            Locale('en', 'US'),
            Locale('ar', ''),
          ],
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate
          ],
          title: 'ذوق - تطبيق الاسرة',
          theme: appTheme,
          home: SplashScreen(),
          routes: {
            OrdersViewPage.routeName: (context) => OrdersViewPage(),
          },
        );
      }),
    );
  }
}

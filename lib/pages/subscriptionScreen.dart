import 'package:flutter/material.dart';
import 'package:zouqadmin/I10n/app_localizations.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/widgets/subscriptionCard.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('subscription'),
          style: headers2,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(appLogo))),
          ),
          SubscriptionCard(
            id: 1,
            planPrice: "30",
            details: "باقه ٣ شهور",
            type: "٣ شهور",
          ),
          SubscriptionCard(
            id: 2,
            planPrice: "50",
            details: "باقه 6 شهور",
            type: "6 شهور",
          ),
          SubscriptionCard(
            id: 3,
            planPrice: "90",
            details: "باقه سنة كاملة",
            type: "سنة كاملة",
          ),
        ],
      ),
    );
  }
}

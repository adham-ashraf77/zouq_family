import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/I10n/app_localizations.dart';
import 'package:zouqadmin/theme/common.dart';

class EULAPage extends StatefulWidget {
  var data;

  EULAPage({this.data});

  @override
  _EULAPageState createState() => _EULAPageState();
}

class _EULAPageState extends State<EULAPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('EULA'),
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
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage(appLogo))),
          ),
          Text(widget.data['content'], style: paragarph1),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/theme/common.dart';

class TermsAndConditionsPage extends StatefulWidget {
  TermsAndConditionsPage();

  @override
  _TermsAndConditionsPageState createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' الشروط والاحكام',
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
          Text(
              """إنك بمجرد استخدامك و/ أو زيارتك هذا الموقع" تشير إلى موافقتك وإقرارك لهذه البنود والشروط ("شروط الخدمة") وأية بنود وشروط أخرى قد تضيفها من وقت لآخر مؤسسة دبي للإعلام فيما يتعلق باستخدام هذا الموقع. تحتفظ مؤسسة دبي للإعلام بحق تعديل هذه الشروط في أي وقت بوضع التغييرات على شبكة الإنترنت (أون لاين) وتتحمل أنت مسؤولية الرجوع إلى هذه الشروط والالتزام بها عند دخولك الموقع أو استخدامك له. وإذا لم توافق على أي من هذه الشروط، يرجى التوقف عن استخدام هذا الموقع على الفور.
              """,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: paragarph1),
        ],
      ),
    );
  }
}

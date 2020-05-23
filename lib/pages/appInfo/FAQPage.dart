import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/I10n/app_localizations.dart';
import 'package:zouqadmin/theme/common.dart';

class FAQPage extends StatelessWidget {
  var data;

  FAQPage({this.data});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context).translate('FAQ'),
            style: moreTextStyle,
          ),
          centerTitle: true,
        ),
        body: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 15),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ExpansionTile(
                  title: Text(
                    Localizations.localeOf(context).languageCode == "en"
                        ? data[index]['question_en']
                        : data[index]['question_ar'],
                    style: moreTextStyle1,
                  ),
                  children: <Widget>[
                    Text(
                      Localizations.localeOf(context).languageCode == "en"
                          ? data[index]['answer_en']
                          : data[index]['answer_ar'],
                      textAlign: TextAlign.start,
                      style: moreTextStyle1.copyWith(fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}

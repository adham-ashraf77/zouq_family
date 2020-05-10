import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/services/withdraw.dart';
import 'package:zouqadmin/theme/common.dart';

import '../I10n/app_localizations.dart';

class AdminWalletPage extends StatefulWidget {
  String walletAmount;

  AdminWalletPage(this.walletAmount);

  @override
  _AdminWalletPageState createState() => _AdminWalletPageState();
}


class _AdminWalletPageState extends State<AdminWalletPage> {

  TextEditingController bankNameController = TextEditingController();
  TextEditingController IbanController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  withdraw() {
    Withdraw().withdrawMoney(
      bankName: bankNameController.text,
      iban: int.parse(IbanController.text),
      quantity: double.parse(quantityController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ذوق", style: TextStyle(color: Colors.blue),),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            children: <Widget>[
              Center(
                child: Text(
                  AppLocalizations.of(context).translate('withdraw'),
                  style: moreTextStyle,
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              ListTile(
                title: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Color(0xFF1DAED1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(' ريال' + "${widget.walletAmount}",
                          style: TextStyle(color: Colors.white, fontSize: 25.0)),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        AppLocalizations.of(context).translate('currentBalance'),
                        style: moreTextStyle1,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  AppLocalizations.of(context).translate('detailsRequired'),
                  style: moreTextStyle1,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: quantityController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)
                                .translate('transactionAmount'),
                            hintStyle: hintTextStyle),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Color(0xff888888),
                indent: 25,
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: bankNameController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                            AppLocalizations.of(context).translate('bank'),
                            hintStyle: hintTextStyle),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Color(0xff888888),
                indent: 25,
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: IbanController,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                            AppLocalizations.of(context).translate('bankId'),
                            hintStyle: hintTextStyle),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Color(0xff888888),
                indent: 25,
              ),
              SizedBox(
                height: 25.0,
              ),
              ListTile(
                title: Container(
                  height: 150.0,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context).translate('details'),
                        hintStyle: hintTextStyle),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ListTile(
                title: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  color: accent,
                  child: Text(
                    AppLocalizations.of(context).translate('withdraw'),
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                  onPressed: () => withdraw(),),
              ),
            ],
          )),
    );
  }
}

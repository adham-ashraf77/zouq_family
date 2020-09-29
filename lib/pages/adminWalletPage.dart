import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zouqadmin/ConstantVarables.dart';
import 'package:zouqadmin/services/withdraw.dart';
import 'package:zouqadmin/theme/common.dart';

import '../I10n/app_localizations.dart';

class AdminWalletPage extends StatefulWidget {
  String walletAmount;
  int familyId;

  AdminWalletPage(this.walletAmount, this.familyId);

  @override
  _AdminWalletPageState createState() => _AdminWalletPageState();
}


class _AdminWalletPageState extends State<AdminWalletPage> {

  TextEditingController bankNameController = TextEditingController();
  TextEditingController IbanController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  FocusNode bankNameNode = FocusNode();
  FocusNode IbanNode = FocusNode();
  FocusNode quantityNode = FocusNode();

  unfocus() {
    bankNameNode.unfocus();
    IbanNode.unfocus();
    quantityNode.unfocus();
  }

  withdraw(BuildContext context) async {
    await Withdraw().withdrawMoney(
      bankName: bankNameController.text,
      iban: int.parse(IbanController.text),
      quantity: double.parse(quantityController.text),
    );
    final snackBar = SnackBar(content: Text('${AppLocalizations.of(context).translate('withdrawSuccess')}'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
    Future.delayed(Duration(seconds: 2), () => Navigator.of(context).pop());
  }

  payCheck() async {
    _launchURL("${ConstantVarable.baseUrl}/api/family/wallet-debt/${widget.familyId}/checkout");
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ذوق",
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => unfocus(),
        child: SafeArea(
          child: Builder(
            builder: (context) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          AppLocalizations.of(context).translate('withdraw'),
                          style: moreTextStyle.copyWith(fontSize:15),
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
                              Text(
                                  ' ريال' + "${widget.walletAmount}", style: TextStyle(color: Colors.white, fontSize: 15)),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                AppLocalizations.of(context).translate('currentBalance'),
                                style: moreTextStyle1.copyWith(fontSize:15),
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
                          style: moreTextStyle1.copyWith(fontSize:15),
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
                                focusNode: quantityNode,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: AppLocalizations.of(context).translate('transactionAmount'),
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
                                focusNode: bankNameNode,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: AppLocalizations.of(context).translate('bank'),
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
                                focusNode: IbanNode,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: AppLocalizations.of(context).translate('bankId'),
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
                              border: Border.all(width: 0.5), borderRadius: BorderRadius.circular(15.0)),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                          color: accent,
                          child: Text(
                            double.parse(widget.walletAmount) < 0 ?
                            "دفع المستحق" :
                            AppLocalizations.of(context).translate('withdraw'),
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          onPressed: () => double.parse(widget.walletAmount) < 0 ? payCheck() : withdraw(context),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

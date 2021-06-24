import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zouqadmin/I10n/app_localizations.dart';
import 'package:zouqadmin/widgets/UiCard.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionCard extends StatefulWidget {
  final String planPrice;
  final String details;
  final String type;
  final int id;

  SubscriptionCard({
    this.planPrice,
    this.details,
    this.type,
    this.id,
  });

  @override
  _SubscriptionCardState createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  launchWhatsApp({int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name');
    int id = prefs.getInt('id');
    String phone = prefs.getString('phone');
    String message;
    if (widget.id == 1) {
      message = "رقم الأسرة: " +
          id.toString() +
          "\nاسم الأسرة: " +
          name +
          "\nجوال الأسرة: " +
          phone +
          "\nأريد الأشتراك في باقة 3 شهور";
    } else if (widget.id == 2) {
      message = "رقم الأسرة: " +
          id.toString() +
          "\nاسم الأسرة: " +
          name +
          "\nجوال الأسرة: " +
          phone +
          "\nأريد الأشتراك في باقة 6 شهور";
    } else {
      message = "رقم الأسرة: " +
          id.toString() +
          "\nاسم الأسرة: " +
          name +
          "\nجوال الأسرة: " +
          phone +
          "\nأريد الأشتراك في باقة سنة كاملة";
    }
    final link = WhatsAppUnilink(
      phoneNumber: '+966554297102',
      text: message,
    );
    // Convert the WhatsAppUnilink instance to a string.
    // Use either Dart's string interpolation or the toString() method.
    // The "launch" method is part of "url_launcher".
    await launch('$link');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: InkWell(
        onTap: () => launchWhatsApp(id: widget.id),
        child: UICard(
          borderColor: Colors.grey[200],
          cardContent: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.15,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("${widget.planPrice + " " + "ريال"}",
                            style: TextStyle(fontSize: 25)),
                        SizedBox(
                          width: 13,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${widget.details == null ? "" : widget.details}",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                )),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                  color: Color(0xFF1DAED1),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.type,
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

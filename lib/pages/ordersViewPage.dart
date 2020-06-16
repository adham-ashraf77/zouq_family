import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zouqadmin/models/order.dart';
import 'package:zouqadmin/models/product.dart';
import 'package:zouqadmin/services/accept_or_reject_order.dart';
import 'package:zouqadmin/services/end_order.dart';
import 'package:zouqadmin/services/getorderwithproducts.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/widgets/commentDesign.dart';
import 'package:zouqadmin/widgets/ordersViewPageCard.dart';

import '../I10n/app_localizations.dart';
import '../home.dart';

class OrdersViewPage extends StatefulWidget {
  static const routeName = '/oredersViewPage';

  @override
  _OrdersViewPageState createState() => _OrdersViewPageState();
}

class _OrdersViewPageState extends State<OrdersViewPage> {
  String link =
      'https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap' +
          '&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318' +
          '&markers=color:red%7Clabel:C%7C40.718217,-73.998284' +
          '&key=AIzaSyCXJIkfOM7D2PhXUHxTh8Gzzxc5mVLr-Xg';

  ///TODO .. The Google Maps Platform server rejected your request. You must enable Billing on the Google Cloud Project at https://console.cloud.google.com/project/_/billing/enable Learn more at https://developers.google.com/maps/gmp-get-started
  final int type = 1;

  String rate;
  bool firstTime = true;
  String latitude;
  String longitude;

  endOrder(String orderId) async {
    await EndOrder().endOrder(orderId);
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Home(),
    ));
  }

  void whatsAppOpen({String phone}) async {
    final snackBar = SnackBar(content: Text('please install whatsapp'));
    var whatsappUrl = "whatsapp://send?phone=$phone&text=hello";
    await canLaunch(whatsappUrl) ? launch(whatsappUrl) : Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final List index = ModalRoute.of(context).settings.arguments;
    final Order order = index[0];
    final int type = index[1];

    acceptOrRejectOrder({String orderStatus}) async {
      await AcceptOrRejectOrder().postOrderStatus(orderId: order.id, orderStatus: orderStatus);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    }

    firstTime
        ? GetOrderWithProducts().getOrderWithProducts(id: order.id).then((onValue) {
            //TODO here and using onValue u can get any info about the product
            latitude = jsonDecode(onValue.toString())['order']['latitude'];
            longitude = jsonDecode(onValue.toString())['order']['longitude'];
            // print('X = ' + latitude + ' = ' + longitude);
            List x = jsonDecode(onValue.toString())['order']['products'];
            order.product.clear();
            for (int i = 0; i < x.length; i++) {
              setState(() {
                rate = jsonDecode(onValue.toString())['order']['rate'].toString();
                order.product.add(Product(
                  name: x[i]['name'],
                  price: x[i]['price'],
                  imageUrl: x[i]['caption'],
                  amount: x[i]['cart']['quantity'],
                ));
              });
            }
          }).whenComplete(() {
            setState(() {
              this.firstTime = false;
            });
          })
        : null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("ذوق", style: TextStyle(color: Colors.blue),),
            Image.asset('assets/images/logo.png', scale: 22,),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(3.0), // borde width
                  decoration: new BoxDecoration(
                    color: Colors.grey[200], // border color
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        NetworkImage('${order.imageUrl.toString()}'),
                    radius: 50,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  order.name.toString(),
                  style: paragarph1.copyWith(
                      fontWeight: FontWeight.w500, color: Color(0xFF535353)),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  decoration: new BoxDecoration(
                      color: type == 1
                          ? Color(0xFFF39D67).withOpacity(0.2)
                          : type == 2
                              ? Color(0xFFF39D67)
                              : type == 3 && order.status == 'done'
                                  ? Color(0xFF48CF84)
                                  : type == 3 &&
                                              order.status ==
                                                  'c'
                                                      'anceled' ||
                                          order.status == "rejected"
                                      ? Colors.red
                                      : Colors.blue, // border color
                      border: Border.all(
                        color: type == 1
                            ? Color(0xFFF39D67)
                            : type == 2
                                ? Color(0xFFF39D67)
                                : type == 3 ? Color(0xFF48CF84) : Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(10)),
                  width: 100,
                  height: 30,
                  child: Center(
                      child: Text(
                    type == 1
                        ? AppLocalizations.of(context).translate('newOrder')
                        : type == 2
                            ? AppLocalizations.of(context)
                                .translate('confirmedOrder')
                            : type == 3 && order.status == 'done'
                                ? AppLocalizations.of(context)
                                    .translate('completedOrder')
                        : type == 3 && order.status == 'canceled' || order.status == "rejected"
                        ? AppLocalizations.of(context)
                        .translate('cancelOrder')
                        : '',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        color: type == 1
                            ? Color(0xFFE08248)
                            : type == 2
                                ? Colors.white
                                : type == 3 ? Colors.white : Colors.blue,
                        fontSize: 16),
                  )),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${order.id.toString()}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            AppLocalizations.of(context).translate('orderNum'),
                            style: paragarph2.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 2,
                        color: Colors.grey[300],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${order.time.toString()}' +
                                '  ' +
                                '${order.date.toString()}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            AppLocalizations.of(context).translate('orderTime'),
                            style: paragarph2.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        height: 2,
                        color: Colors.grey[300],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      type == 2 || type == 3
                          ? InkWell(
                        onTap: () {
                          if (type == 2) whatsAppOpen(phone: order.phoneNumber);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 35,
                                  height: 35,
                                  child: Image.asset(
                                    'assets/images/whatsicon.png',
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${order.phoneNumber.toString()}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Text(
                              'محادثة whatsapp',
                              textDirection: TextDirection.rtl,
                              style: paragarph2.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ],
                        ),
                      )
                          : SizedBox(),
                      type == 2 || type == 3
                          ? Divider(
                              height: 2,
                              color: Colors.grey[300],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: type == 2 || type == 3 ? 20 : 0,
                      ),
                      /////
                      type == 2 || type == 3
                          ? InkWell(
                        onTap: () => _makePhoneCall('tel:${order.phoneNumber}'),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 5,
                                ),
                                FaIcon(FontAwesomeIcons.mobile,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '${order.phoneNumber.toString()}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('telephone'),
                              textDirection: TextDirection.rtl,
                              style: paragarph2.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ],
                        ),
                      )
                          : SizedBox(),
                      type == 2 || type == 3
                          ? Divider(
                              height: 2,
                              color: Colors.grey[300],
                            )
                          : SizedBox(),
                      SizedBox(
                        height: type == 2 || type == 3 ? 20 : 0,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                type == 3
                    ? SizedBox()
                    : Text(
                        AppLocalizations.of(context).translate('location'),
                        style: paragarph2.copyWith(color: Colors.blue),
                      ),
                SizedBox(
                  height: type == 3 ? 0 : 20,
                ),
                type == 2 || type == 1
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                            color: Colors.grey[200],
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                                'https://www.mediafire.com/convkey/b31a/c318q2te6lqziqzzg.jpg')),

                        ///TODO this url must be replaced with `link` variable
                      )
                    : Container(
                        height: 100 * order.comments.length.toDouble(),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: order.comments.length,
                          itemBuilder: (context, i) {
                            return CommentDesign(comment: order.comments[i]);
                          },
                        ),
                      ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'الطلبات (${order.product.length.toString()} منتجات)',
                  style: paragarph2.copyWith(color: Colors.blue),
                ),
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal:5),
                  primary: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: order.product.length,
                  itemBuilder: (context, i) {
                    return OrderViewPageCard(
                      prouct: order.product[i],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        child: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal:10,vertical:5),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                  child: type == 1
                      ? Row(
                          children: <Widget>[
                            InkWell(
                              child: Container(
                                height: 40,
                                width: 40,
                                child: Icon(
                                  Icons.close,
                                  color: rejectedColor,
                                  size: 23,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                    border: Border.all(
                                        color: Color(0xFFDADADA), width: 2)),
                              ),
                              onTap: () => acceptOrRejectOrder(orderStatus: "reject"),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            InkWell(
                              onTap: () => acceptOrRejectOrder(orderStatus: "approve"),
                              child: Container(
                                height: 40,
                                width: 70,
                                child: Icon(
                                  Icons.check,
                                  color: accent,
                                  size: 23,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                                  border: Border.all(
                                      color: Color(0xFFDADADA), width: 2),
                                ),
                              ),
                            ),
                          ],
                        )
                      : type == 2
                      ? InkWell(
                    onTap: () => endOrder(order.id),
                    child: Container(
                      height: 40,
                      width: 110,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 23,
                      ),
                      decoration: BoxDecoration(
                          color: Colors.green[300],
                          borderRadius:
                          BorderRadius.all(Radius.circular(50)),
                          border: Border.all(color: Colors.grey[300])),
                    ),
                  )
                          : Row(
                              children: <Widget>[
                                Container(
                                  height: 40,
                                  width: 40,
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 23,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.red[300],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      border:
                                          Border.all(color: Colors.grey[300])),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  rate == null || rate == "-1" ? '0' : rate,
                                  style: paragarph1.copyWith(
                                      fontWeight: FontWeight.w100),
                                ),
                              ],
                            ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: Text(
                    '${order.price}' + ' ' + 'ريال',
                    textDirection: TextDirection.rtl,
                    style: paragarph1.copyWith(
                        fontWeight: FontWeight.w200, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

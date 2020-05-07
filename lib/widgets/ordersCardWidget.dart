import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zouqadmin/models/order.dart';
import 'package:zouqadmin/pages/ordersViewPage.dart';
import 'package:zouqadmin/services/accept_or_reject_order.dart';
import 'package:zouqadmin/theme/common.dart';

class OrdersCard extends StatelessWidget {
  final Order order;
  final int type; //1 - new orders, 2 - complete orders, 3 - old orders

  acceptOrder({String orderId, String orderStatus}) {
    AcceptOrRejectOrder().postOrderStatus(orderId: orderId, orderStatus: orderStatus);
  }

  OrdersCard({@required this.order, @required this.type});
  Widget build(BuildContext context) {
    final double allWidth = MediaQuery.of(context).size.width;

    Future<void> _makePhoneCall(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    void whatsAppOpen({String phone}) async {
      final snackBar = SnackBar(content: Text('please install whatsapp'));
      var whatsappUrl = "whatsapp://send?phone=$phone&text=hello";
      await canLaunch(whatsappUrl) ? launch(whatsappUrl) : Scaffold.of(context).showSnackBar(snackBar);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(OrdersViewPage.routeName, arguments: [order, type]);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(Radius.circular(25)),
            border: Border.all(
              width: 1,
              color: Colors.grey[200],
            ),
          ),
          width: allWidth - 25,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          type == 2
                              ? Text('${this.order.price.toString()}',
                              style: paragarph3.copyWith(color: Colors.black54, fontWeight: FontWeight.w300))
                              : SizedBox(),
                          Text(
                            this.order.id.toString(),
                            style: paragarph3.copyWith(color: Colors.black54, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      this.order.name.toString(),
                      textDirection: TextDirection.rtl,
                      style:
                      paragarph6.copyWith(fontSize: 25, color: Colors.black, height: 1.8, fontWeight: FontWeight.w200),
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            this.order.time.toString(),
                            style: paragarph3.copyWith(color: Colors.black54, fontWeight: FontWeight.w100),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            this.order.date.toString(),
                            style: paragarph3.copyWith(color: Colors.black54, fontWeight: FontWeight.w100),
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          // CircleAvatar(backgroundColor: accent,radius: 9,),
                          Container(
                            height: 19,
                            width: 19,
                            decoration: BoxDecoration(
                              color: accent,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      // color: Colors.blueGrey,
                      width: MediaQuery.of(context).size.width - 150,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  type == 3 ?
                                  Container() :
                                  InkWell(
                                    onTap: () {
                                      if (type == 1) acceptOrder(orderId: order.id, orderStatus: "reject");
                                      if (type == 2) _makePhoneCall('tel:${order.phoneNumber}');
                                    },
                                    child: Container(
                                      height: MediaQuery
                                          .of(context)
                                          .orientation == Orientation.portrait
                                          ? MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.05
                                          : 50,
                                      width: MediaQuery
                                          .of(context)
                                          .orientation == Orientation.portrait
                                          ? MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.05
                                          : 50,
                                      child: Icon(
                                        type == 1 || type == 3 ? Icons.close : Icons.phone,
                                        color: type == 1 || type == 3 ? rejectedColor : accent,
                                        size: MediaQuery
                                            .of(context)
                                            .orientation == Orientation.portrait ? 23 : 30,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          border: Border.all(color: Colors.grey[300])),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 13,
                                  ),
                                  type == 3 ?
                                  Container() :
                                  InkWell(
                                    onTap: () {
                                      if (type == 1) acceptOrder(orderId: order.id, orderStatus: "approve");
                                      if (type == 2) whatsAppOpen(phone: order.phoneNumber);
                                    },
                                    child: Container(
                                      height: MediaQuery
                                          .of(context)
                                          .orientation == Orientation.portrait
                                          ? MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.05
                                          : 50,
                                      width: MediaQuery
                                          .of(context)
                                          .orientation == Orientation.portrait
                                          ? (type == 1
                                          ? MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.07
                                          : type == 2
                                          ? MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.05
                                          : type == 3 ? MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.07 : null)
                                          : (type == 1 ? 70 : type == 2 ? 50 : type == 3 ? 70 : null),
                                      child: type == 1 || type == 3
                                          ? Icon(
                                        Icons.check,
                                        color: accent,
                                        size: MediaQuery
                                            .of(context)
                                            .orientation == Orientation.portrait ? 23 : 30,
                                      )
                                          : Image.asset(
                                        'assets/images/whatsicon.png',
                                        fit: BoxFit.fill,
                                      ),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(50)),
                                          border: Border.all(color: Colors.grey[300])),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    this.order.contents.toString(),
                                    style: paragarph3.copyWith(color: Colors.black54, fontWeight: FontWeight.w100),
                                  ),
                                  SizedBox(
                                    width: 9,
                                  ),
                                  Icon(
                                    Icons.shopping_cart,
                                    color: accent,
                                    size: 25,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  radius: 33,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: NetworkImage(this.order.imageUrl.toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

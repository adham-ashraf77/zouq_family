import 'package:flutter/material.dart';
import 'package:zouqadmin/models/order.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/widgets/commentDesign.dart';
import 'package:zouqadmin/widgets/ordersViewPageCard.dart';

class OrdersViewPage extends StatelessWidget {
  static const routeName = '/oredersViewPage';
  String link =
      'https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap' +
          '&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318' +
          '&markers=color:red%7Clabel:C%7C40.718217,-73.998284' +
          '&key=AIzaSyCXJIkfOM7D2PhXUHxTh8Gzzxc5mVLr-Xg';

  ///TODO .. The Google Maps Platform server rejected your request. You must enable Billing on the Google Cloud Project at https://console.cloud.google.com/project/_/billing/enable Learn more at https://developers.google.com/maps/gmp-get-started
  final int type = 1;

  @override
  Widget build(BuildContext context) {
    final List index = ModalRoute.of(context).settings.arguments;
    final Order order = index[0];
    final int type = index[1];
    print(order.name);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                alignment: Alignment(-1.0, -0.8),
                width: MediaQuery.of(context).size.width,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                        backgroundImage: NetworkImage('${order.imageUrl}'),
                        radius: 50,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      order.name,
                      style: paragarph1.copyWith(
                          fontWeight: FontWeight.w100, color: Colors.black54),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: new BoxDecoration(
                          color: Colors.grey[200], // border color
                          border: Border.all(
                            color: Colors.redAccent[100],
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      width: 70,
                      height: 30,
                      child: Center(
                          child: Text(
                        type == 1
                            ? 'طلب جديد'
                            : type == 2
                                ? 'طلب مؤكد'
                                : type == 3 ? 'طلب تم' : '',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: Colors.redAccent[100]),
                      )),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              '${order.id}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'رقم الطلب',
                              textDirection: TextDirection.rtl,
                              style: paragarph2.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w100,
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
                              '${order.time}' + '  ' + '${order.date}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'وقت الطلب',
                              textDirection: TextDirection.rtl,
                              style: paragarph2.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w100,
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
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                        '${order.phoneNumber}',
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
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: 5,
                                      ),
                                      CircleAvatar(
                                        backgroundColor: accent,
                                        radius: 12,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        '${order.phoneNumber}',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'رقم هاتف',
                                    textDirection: TextDirection.rtl,
                                    style: paragarph2.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                ],
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
                    SizedBox(
                      height: 20,
                    ),
                   type == 3 ? SizedBox() : Text(
                      'الموقع',
                      style: paragarph2.copyWith(color: Colors.blue),
                    ),
                    SizedBox(
                      height:  type == 3 ? 0 : 20,
                    ),
                    type == 2 || type == 1
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                                color: Colors.grey[200],
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                child: Image.network('https://www.mediafire.com/convkey/b31a/c318q2te6lqziqzzg.jpg')), ///TODO this url must be replaced with `link` variable
                          )
                        : Container(
                          height:  100 * order.comments.length.toDouble(),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: order.comments.length,
                            itemBuilder:(context,i){
                              return  CommentDesign(comment : order.comments[i]);
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
                    Container(
                      height: 105 * order.product.length.toDouble(),
                      child: ListView.builder(
                        itemCount: order.product.length,
                        itemBuilder: (context, i) {
                          return OrderViewPageCard(
                            prouct: order.product[i],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        child: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                child: type == 1
                    ? Row(
                        children: <Widget>[
                          Container(
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
                                border: Border.all(color: Colors.grey[300])),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Container(
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
                                border: Border.all(color: Colors.grey[300])),
                          ),
                        ],
                      )
                    : type == 2
                        ? Container(
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
                                    border: Border.all(color: Colors.grey[300])),
                              ),SizedBox(width: 10,),Text(order.rate.toString(),style: paragarph1.copyWith(fontWeight: FontWeight.w100),),
                          ],
                        ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Text(
                  'ريال ' + '236',
                  textDirection: TextDirection.rtl,
                  style: paragarph1.copyWith(fontWeight: FontWeight.w200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

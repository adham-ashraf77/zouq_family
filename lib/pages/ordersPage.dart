import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zouqadmin/models/order.dart';
import 'package:zouqadmin/services/accept_or_reject_order.dart';
import 'package:zouqadmin/services/paginateorders.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/widgets/ordersCardWidget.dart';

import '../I10n/app_localizations.dart';
import 'addItemPage.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isFocused1 = true;
  bool _isFocused2 = false;
  bool _isFocused3 = false;
  List<Order> newOrders = [];
  List<Order> completeOrders = [];
  List<Order> oldOrders = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getOrders();
  }

  acceptOrRejectOrder({String orderId, String orderStatus}) {
    AcceptOrRejectOrder().postOrderStatus(orderId: orderId, orderStatus: orderStatus).then((value) => getOrders());
  }

  getOrders() async {
    PaginateOrders().paginateOrders(status: 'new').then((onValue) {
      newOrders.clear();
      List data = jsonDecode(onValue.toString())['orders'];
      for (int i = 0; i < data.length; i++) {
        setState(() {
          newOrders.add(
            Order(
              id: data[i]['id'].toString(),
              name: data[i]['client']['name'].toString(),
              date: data[i]['created_at'].toString(),
              contents: data[i]['products_meta'].toString(),
              imageUrl: data[i]['client']['image'].toString(),
              time: "",
              comments: [],
              product: [],
              price: data[i]['total'],
            ),
          );
        });
        print('new order length: ${newOrders.length}');
      }
      // print('Old Orders  : ' + x.length.toString());
    });
    PaginateOrders().paginateOrders(status: 'old').then((onValue) {
      print('a7ba tete');
      print(onValue);
      oldOrders.clear();
      List x = jsonDecode(onValue.toString())['orders'];
      //  print('Old Orders  : ' + x.toString());
      for (int i = 0; i < x.length; i++) {
        setState(() {
          oldOrders.add(Order(
            id: x[i]['id'].toString(),
            status: x[i]['status'],
            name: x[i]['client']['name'].toString(),
            date: x[i]['created_at'].toString(),
            contents: x[i]['products_meta'].toString(),
            imageUrl: x[i]['client']['image'].toString(),
            time: "",
            comments: [],
            product: [],
            price: x[i]['total'],
            rate: 0,
            phoneNumber: x[i]['client']['phone'],
          ));
        });
      }
      // print('Old Orders  : ' + x.length.toString());
    });
    PaginateOrders().paginateOrders(status: 'approved').then((onValue) {
      completeOrders.clear();
      List x = jsonDecode(onValue.toString())['orders'];
      //  print('Old Orders  : ' + x.toString());
      for (int i = 0; i < x.length; i++) {
        setState(() {
          completeOrders.add(Order(
            id: x[i]['id'].toString(),
            name: x[i]['client']['name'].toString(),
            date: x[i]['created_at'].toString(),
            contents: x[i]['products_meta'].toString(),
            imageUrl: x[i]['client']['image'].toString(),
            time: "",
            comments: [],
            product: [],
            price: x[i]['total'],
            rate: 0,
            phoneNumber: x[i]['client']['phone'],
          ));
        });
      }
      // print('Old Orders  : ' + x.length.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final double allWidth = MediaQuery.of(context).size.width;
//    AppBar appBar = AppBar(
//      backgroundColor: Color.fromRGBO(250, 250, 253, 1),
//      centerTitle: true,
//      elevation: 0,
//
//      ///TODO uncomment the code below if you want a back button
//      // leading: IconButton(
//      //     icon: Icon(
//      //       Icons.arrow_back,
//      //       color: Colors.black,
//      //     ),
//      //     onPressed: () {
//      //       Navigator.pop(context);
//      //     }),
//      title: Text(
//        'ذوق',
//        style: headers1,
//      ),
//    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // pinned: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("ذوق", style: headers1),
            Image.asset(
              'assets/images/logo.png',
              scale: 18,
            ),
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: new Image.asset('assets/icons/add.png'),
            onPressed: () {
              //TODO go add product screen
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddItemPage()));
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: Container(
              color: Colors.white,
              width: allWidth - 25,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFocused3 = true;
                        _isFocused1 = false;
                        _isFocused2 = false;
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        width: (allWidth - 37) / 3,
                        height: 35,
                        color: _isFocused3 ? Colors.blue[300] : Colors.white,
                        child: Center(
                          child: Text(AppLocalizations.of(context).translate('oldOrders'),
                              style: paragarph3.copyWith(
                                  color: _isFocused3 ? Colors.white : Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w100)),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFocused3 = false;
                        _isFocused1 = false;
                        _isFocused2 = true;
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        width: (allWidth - 37) / 3,
                        height: 35,
                        color: _isFocused2 ? Colors.blue[300] : Colors.white,
                        child: Center(
                          child: Text(AppLocalizations.of(context).translate('confirmedOrders'),
                              style: paragarph3.copyWith(
                                  color: _isFocused2 ? Colors.white : Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w100)),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFocused3 = false;
                        _isFocused1 = true;
                        _isFocused2 = false;
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        width: (allWidth - 37) / 3,
                        height: 35,
                        color: _isFocused1 ? Colors.blue[300] : Colors.white,
                        child: Center(
                          child: Text(AppLocalizations.of(context).translate('newOrders'),
                              style: paragarph3.copyWith(
                                  color: _isFocused1 ? Colors.white : Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w100)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _isFocused1
              ? Expanded(
                  child: ListView.builder(
                    itemCount: newOrders.length,
                    itemBuilder: (context, i) {
                      return Stack(
                        children: <Widget>[
                          OrdersCard(
                              order: newOrders[i],
                              type: 1,
                              rejectFunction: () async {
                                await acceptOrRejectOrder(orderId: newOrders[i].id, orderStatus: "reject");
                                setState(() {});
                              },
                              acceptFunction: () async {
                                await acceptOrRejectOrder(orderId: newOrders[i].id, orderStatus: "approve");
                                setState(() {});
                              }
//                                            if (type == 1){
//
//
//                                            };
//                                            if (type == 2) whatsAppOpen(phone: order.phoneNumber);
//                                          },
                          ),
                        ],
                      );
                    },
                  ),
                )
              : _isFocused2
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: completeOrders.length,
                        itemBuilder: (context, i) {
                          return OrdersCard(
                            order: completeOrders[i],
                            type: 2,
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: oldOrders.length,
                        itemBuilder: (context, i) {
                          return OrdersCard(
                            order: oldOrders[i],
                            type: 3,
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}

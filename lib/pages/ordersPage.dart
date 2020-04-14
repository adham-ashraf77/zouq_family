import 'package:flutter/material.dart';
import 'package:zouqadmin/models/comment.dart';
import 'package:zouqadmin/models/order.dart';
import 'package:zouqadmin/models/product.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/widgets/bottomNavigationbar.dart';
import 'package:zouqadmin/widgets/ordersCardWidget.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool _isFocused1 = true;
  bool _isFocused2 = false;
  bool _isFocused3 = false;
  List<Order> newOrders = [
    Order(
        id: '54676867#',
        imageUrl: 'http://www.mediafire.com/convkey/e3dc/q0w2dc096ilt7r8zg.jpg',
        name: 'خالد مرعي',
        date: '08 May 2020',
        time: '02:22PM',
        contents: ' كيك , حلا , ….',
        product: [
          Prouct(
              amount: 3,
              price: '45',
              imageUrl:
                  'http://www.mediafire.com/convkey/37d2/4rblt3fgtrad9sbzg.jpg',
              name: 'ملفوفة في أوراق الموز'),
          Prouct(
              amount: 1,
              name: 'بوتو بيرياني',
              imageUrl:
                  'http://www.mediafire.com/convkey/5116/igw7chb8ee4dmlfzg.jpg',
              price: '45')
        ]),
    Order(
        id: '54676867#',
        imageUrl: 'http://www.mediafire.com/convkey/e3dc/q0w2dc096ilt7r8zg.jpg',
        name: 'غادة يوسف',
        date: '08 May 2020',
        time: '02:22PM',
        contents: ' كيك , حلا , ….',
        product: [
          Prouct(
              amount: 3,
              price: '45',
              imageUrl:
                  'http://www.mediafire.com/convkey/37d2/4rblt3fgtrad9sbzg.jpg',
              name: 'ملفوفة في أوراق الموز'),
          Prouct(
              amount: 1,
              name: 'بوتو بيرياني',
              imageUrl:
                  'http://www.mediafire.com/convkey/5116/igw7chb8ee4dmlfzg.jpg',
              price: '45')
        ]),
  ];
  List<Order> completeOrders = [
    Order(
      id: '54676867#',
      imageUrl: 'http://www.mediafire.com/convkey/55ed/l9wgqr9lsqh9hyrzg.jpg',
      name: 'محمد يونس',
      date: '08 May 2020',
      time: '02:22PM',
      contents: ' كيك , حلا , ….',
      price: '43 ريال',
      phoneNumber: '543-649-3478',
      product: [
        Prouct(
            amount: 3,
            price: '45',
            imageUrl:
                'http://www.mediafire.com/convkey/37d2/4rblt3fgtrad9sbzg.jpg',
            name: 'ملفوفة في أوراق الموز'),
        Prouct(
            amount: 1,
            name: 'بوتو بيرياني',
            imageUrl:
                'http://www.mediafire.com/convkey/5116/igw7chb8ee4dmlfzg.jpg',
            price: '45')
      ],
    ),
    Order(
      id: '54676867#',
      imageUrl: 'http://www.mediafire.com/convkey/e3dc/q0w2dc096ilt7r8zg.jpg',
      name: 'أحمد محمد',
      date: '08 May 2020',
      time: '02:22PM',
      contents: ' كيك , حلا , ….',
      price: '43 ريال',
      phoneNumber: '543-649-3478',
   
      product: [
        Prouct(
            amount: 3,
            price: '45',
            imageUrl:
                'http://www.mediafire.com/convkey/37d2/4rblt3fgtrad9sbzg.jpg',
            name: 'ملفوفة في أوراق الموز'),
        Prouct(
            amount: 1,
            name: 'بوتو بيرياني',
            imageUrl:
                'http://www.mediafire.com/convkey/5116/igw7chb8ee4dmlfzg.jpg',
            price: '45')
      ],
    ),
  ];
  List<Order> oldOrders = [Order(
      id: '54676867#',
      imageUrl: 'http://www.mediafire.com/convkey/55ed/l9wgqr9lsqh9hyrzg.jpg',
      name: 'محمد يونس',
      date: '08 May 2020',
      time: '02:22PM',
      contents: ' كيك , حلا , ….',
      price: '43 ريال',
      phoneNumber: '543-649-3478',
       rate: 4.9,
      comments: [
        Comment(name : 'محمد يوسف', comment: 'الطعام مذاقة جيد ولم يتأخر التوصيل , انصح بطلب هذا المنتج فانة رائع', imageUrl: 'http://www.mediafire.com/convkey/f3dd/rp9c5h7xajnzrh8zg.jpg', rate: 4.9)
      ],
      product: [
        Prouct(
            amount: 3,
            price: '45',
            imageUrl:
                'http://www.mediafire.com/convkey/37d2/4rblt3fgtrad9sbzg.jpg',
            name: 'ملفوفة في أوراق الموز'),
        Prouct(
            amount: 1,
            name: 'بوتو بيرياني',
            imageUrl:
                'http://www.mediafire.com/convkey/5116/igw7chb8ee4dmlfzg.jpg',
            price: '45')
      ],
    ),
    Order(
      id: '54676867#',
      imageUrl: 'http://www.mediafire.com/convkey/e3dc/q0w2dc096ilt7r8zg.jpg',
      name: 'أحمد محمد',
      date: '08 May 2020',
      time: '02:22PM',
      contents: ' كيك , حلا , ….',
      price: '43 ريال',
      phoneNumber: '543-649-3478',
      rate: 4.9,
      comments: [
        Comment(name : 'محمد يوسف', comment: 'الطعام مذاقة جيد ولم يتأخر التوصيل , انصح بطلب هذا المنتج فانة رائع', imageUrl: 'http://www.mediafire.com/convkey/f3dd/rp9c5h7xajnzrh8zg.jpg', rate: 4.9)
      ],
      product: [
        Prouct(
            amount: 3,
            price: '45',
            imageUrl:
                'http://www.mediafire.com/convkey/37d2/4rblt3fgtrad9sbzg.jpg',
            name: 'ملفوفة في أوراق الموز'),
        Prouct(
            amount: 1,
            name: 'بوتو بيرياني',
            imageUrl:
                'http://www.mediafire.com/convkey/5116/igw7chb8ee4dmlfzg.jpg',
            price: '45')
      ],
    ),];
  @override
  Widget build(BuildContext context) {
    final double allWidth = MediaQuery.of(context).size.width;
    AppBar appBar = AppBar(
      backgroundColor: Color.fromRGBO(250, 250, 253, 1),
      centerTitle: true,
      elevation: 0,

      ///TODO uncomment the code below if you want a back button
      // leading: IconButton(
      //     icon: Icon(
      //       Icons.arrow_back,
      //       color: Colors.black,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     }),
      title: Text(
        'ذوق',
        style: headers1,
      ),
    );
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 253, 1),
      appBar: appBar,
      bottomNavigationBar: BottomNavigationbar(),
      body: Container(
          width: allWidth,
          child: Column(
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
                            color:
                                _isFocused3 ? Colors.blue[300] : Colors.white,
                            child: Center(
                              child: Text('طلبات قديمة',
                                  style: paragarph3.copyWith(
                                      color: _isFocused3
                                          ? Colors.white
                                          : Colors.black,
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
                            color:
                                _isFocused2 ? Colors.blue[300] : Colors.white,
                            child: Center(
                              child: Text('طلبات مؤكدة',
                                  style: paragarph3.copyWith(
                                      color: _isFocused2
                                          ? Colors.white
                                          : Colors.black,
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
                            color:
                                _isFocused1 ? Colors.blue[300] : Colors.white,
                            child: Center(
                              child: Text('طلبات جديدة',
                                  style: paragarph3.copyWith(
                                      color: _isFocused1
                                          ? Colors.white
                                          : Colors.black,
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
                  ? Container(
                      width: allWidth - 25,
                      height: MediaQuery.of(context).size.height -
                          (MediaQuery.of(context).padding.top +
                              appBar.preferredSize.height +
                              50 +
                              82),
                      child: ListView.builder(
                        itemCount: newOrders.length,
                        itemBuilder: (context, i) {
                          return OrdersCard(
                            order: newOrders[i],
                            type: 1,
                          );
                        },
                      ),
                    )
                  : _isFocused2
                      ? Container(
                          width: allWidth - 25,
                          height: MediaQuery.of(context).size.height -
                              (MediaQuery.of(context).padding.top +
                                  appBar.preferredSize.height +
                                  50 +
                                  82),
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
                      : Container(
                          width: allWidth - 25,
                          height: MediaQuery.of(context).size.height -
                              (MediaQuery.of(context).padding.top +
                                  appBar.preferredSize.height +
                                  50 +
                                  82),
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
          )),
    );
  }
}

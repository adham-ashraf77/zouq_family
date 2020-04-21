import 'package:flutter/material.dart';
import 'package:zouqadmin/models/product.dart';
import 'package:zouqadmin/theme/common.dart';

class OrderViewPageCard extends StatelessWidget {
  final Product prouct;
  final int type;

  OrderViewPageCard({this.prouct, this.type});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        height: 90,
        width: MediaQuery.of(context).size.width,
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey[50], width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(prouct.name,
                      style: paragarph2, textDirection: TextDirection.rtl),
                  Container(
                    width: MediaQuery.of(context).size.width - (20 + 90 + 43),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('assets/icons/cart.png',scale: 2.7,),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${prouct.amount}' + 'x',
                              style:
                                  paragarph3.copyWith(color: Colors.blue,fontSize: 16),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        Text(
                          'ريال ${prouct.price}',
                          style: paragarph3.copyWith(color: Colors.blue,fontSize: 16),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
                width: 90,
                height: 90,
                child: Image.network(
                  '${prouct.imageUrl}',
                  fit: BoxFit.fill,
                )),
          ],
        ),
      ),
    );
  }
}

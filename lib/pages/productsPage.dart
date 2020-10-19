import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zouqadmin/I10n/app_localizations.dart';
import 'package:zouqadmin/models/product.dart';
import 'package:zouqadmin/pages/addItemPage.dart';
import 'package:zouqadmin/pages/itemDetailPage.dart';
import 'package:zouqadmin/services/paginate.dart';
import 'package:zouqadmin/widgets/UiCard.dart';
import 'package:zouqadmin/widgets/cardContents/marketProfileCardContent.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];

  @override
  void didChangeDependencies() {
    Paginate().paginate().then((onVal) {
      var x = jsonDecode(onVal.toString());
      List allProducts = x['products'];
      products.clear();
      for (int i = 0; i < allProducts.length; i++) {
        setState(() {
          products.add(new Product(
              description: allProducts[i]['description'].toString(),
              imageUrl: allProducts[i]['caption'].toString(),
              name: allProducts[i]['name'].toString(),
              price: allProducts[i]['price'].toString(),
              rate: allProducts[i]['rate'].toString(),
              id: allProducts[i]['id'].toString()));
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final allHeight = mediaQuery.size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              scale: 18,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddItemPage()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('addProduct'),
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset('assets/icons/add.png'),
                  ],
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            height: (allHeight -
                AppBar().preferredSize.height -
                mediaQuery.padding.top -
                MediaQuery.of(context).size.height * 0.2),
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                padding: EdgeInsets.all(0),
                primary: true,
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ItemDetail(orderId: products[index].id),
                          ));
                    },
                    child: UICard(
                        cardContent: MarketProfileCardContecnt(
                      title: "${products[index].name}",
                      description: "${products[index].description}",
                      imgUrl: "${products[index].imageUrl}",
                      price: double.parse('${products[index].price}'),
                      rating: double.parse('${products[index].rate}'),
                    )),
                  );
                }),
          )
        ],
      ),
    );
  }
}

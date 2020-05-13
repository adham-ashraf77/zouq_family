import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zouqadmin/models/product.dart';
import 'package:zouqadmin/pages/addItemPage.dart';
import 'package:zouqadmin/pages/itemDetailPage.dart';
import 'package:zouqadmin/services/paginate.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/widgets/UiCard.dart';
import 'package:zouqadmin/widgets/cardContents/marketProfileCardContent.dart';
import 'package:zouqadmin/widgets/chips/tagchip.dart';

import '../I10n/app_localizations.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<String> tags = ["حلوى", "غداء", "حلوى", "غداء", "حلوى", "غداء"];
  List<bool> selcted = [false, false, false, false, false, false];
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
        // pinned: true,
        title: Text(AppLocalizations.of(context).translate('zouq'), style: headers1),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: new Image.asset('assets/icons/add.png'),
            onPressed: () {
              //TODO go add product screen
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddItemPage()));
            },
          ),
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return TagChip(
                  onSelect: (clicked) {
                    setState(() {
                      selcted[index] = clicked;
                    });
                  },
                  isSelected: selcted[index],
                  tagName: tags[index],
                );
              },
            ),
          ),
          Container(
            height: (allHeight -
                AppBar().preferredSize.height -
                mediaQuery.padding.top -
                MediaQuery.of(context).size.height * 0.2),
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                padding: EdgeInsets.all(0),
                primary: true,
                itemCount: products.length, //TODO replace with products.length
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemDetail(
                                orderId: products[index]
                                    .id), //TODO replace with products[index] ID
                          ));
                    },
                    child: UICard(
                        //TODO render products instead of static
                        cardContent: MarketProfileCardContecnt(
                      title: "${products[index].name}",
                      description: "${products[index].description}",
                      imgUrl: "${products[index].imageUrl}",
                      price: double.parse('${products[index].price}'),
                      rating:  double.parse('${products[index].rate}'),
                    )),
                  );
                }),
          )
        ],
      ),
    );
  }
}

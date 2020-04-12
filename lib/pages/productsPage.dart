import 'package:flutter/material.dart';
import 'package:zouqadmin/pages/addItemPage.dart';
import 'package:zouqadmin/pages/itemDetailPage.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/widgets/UiCard.dart';
import 'package:zouqadmin/widgets/bottomNavigationbar.dart';
import 'package:zouqadmin/widgets/cardContents/marketProfileCardContent.dart';
import 'package:zouqadmin/widgets/chips/tagchip.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<String> tags = ["حلوى", "غداء", "حلوى", "غداء", "حلوى", "غداء"];
  List<bool> selcted = [false, false, false, false, false, false];
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final allHeight = mediaQuery.size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // pinned: true,
        title: Text("ذوق", style: headers1),
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
                mediaQuery.padding.top-MediaQuery.of(context).size.height * 0.2),
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                padding: EdgeInsets.all(0),
                primary: true,
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItemDetail()));
                    },
                    child: UICard(
                        cardContent: MarketProfileCardContecnt(
                      title: "وجبة",
                      description: "وجبة منزلية لذيذة",
                      imgUrl:
                          "https://img.delicious.com.au/xME97xUY/w1200/del/2015/10/white-chocolate-truffle-cake-13633-1.jpg",
                      price: 15.0,
                      rating: 5.0,
                    )),
                  );
                }),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        child: BottomNavigationbar(),
      ),
    );
  }
}

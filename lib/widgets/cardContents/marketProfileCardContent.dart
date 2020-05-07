import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zouqadmin/theme/common.dart';

class MarketProfileCardContecnt extends StatefulWidget {
  final String imgUrl;
  final String title;
  final String description;
  final double price;
  final double rating;
  final bool state;

  MarketProfileCardContecnt(
      {this.rating = 0,
      this.price = 0.0,
      this.imgUrl = "",
      this.title = "",
      this.description = "",
      this.state =true});
  @override
  _MarketProfileCardContecntState createState() =>
      _MarketProfileCardContecntState();
}

class _MarketProfileCardContecntState extends State<MarketProfileCardContecnt> {


  @override
  void initState() {
    super.initState();
  }

  String tagListStirng(List<String> tags) {
    String result = "";
    for (int i = 0; i < tags.length; i++) {
      result += "${tags[i]}, ";
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: "${widget.imgUrl}",
                placeholder: (context, text) {
                  return SpinKitFoldingCube(
                    color: accent,
                    size: 30,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.4,
                        child: Text(
                          "${widget.title}",
                          overflow: TextOverflow.ellipsis,
                          style: headers4,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "${widget.rating}",
                            style: paragarph4,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Container(
                            width: 20,
                            height: 20,
                            child: Image.asset("assets/icons/star.png"),
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.5,
                        child: Text(
                          "${widget.description}",
                          overflow: TextOverflow.ellipsis,
                          style: paragarph3,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        " ريال ${widget.price} ",
                        style: priceText1.copyWith(fontSize: 13),
                      ),
              ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

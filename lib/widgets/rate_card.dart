import 'package:flutter/material.dart';
import 'package:zouqadmin/theme/common.dart';

class RateCard extends StatefulWidget {
  final String name;

  /// if there is no image provided, [profileImg] in
  /// [Common.dart] file will be used as default image
  final String image;
  final double rate;
  final String desc;

  RateCard({this.name = "", this.image, this.rate = 0.0, this.desc = ""});
  @override
  _RateCardState createState() => _RateCardState();
}

class _RateCardState extends State<RateCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 38,
                backgroundColor: iconsFaded,
                child: Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: widget.image == null
                          ? AssetImage(profileImg)
                          : NetworkImage(
                              '${widget.image}',
                            ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${widget.name}',
                      style: headers4,
                    ),
                    SizedBox(
                      child: Text('${widget.desc}',
                          textDirection: TextDirection.rtl, style: paragarph3),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    Text(
                      '${widget.rate}',
                      style: paragarph4,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Container(
                      child: Image.asset("assets/icons/star.png"),
                    )
                  ],
                ),
              ),
            ],
          ),
          Divider(
            color: iconsFaded,
            indent: 20,
          ),
        ],
      ),
    );
  }
}

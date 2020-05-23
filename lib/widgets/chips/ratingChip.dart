import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zouqadmin/theme/common.dart';


class RatingChip extends StatefulWidget {
  final double rating;
  RatingChip({this.rating = 0.0});
  @override
  _RatingChipState createState() => _RatingChipState();
}

class _RatingChipState extends State<RatingChip> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 15),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
            color: iconColors2,
          ),
          height: 30,
          width: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                widget.rating == -1 ? "0.0" : '${widget.rating}',
                style: TextStyle(color: mainColor, fontSize: 15),
              ),
              //TODO:: @rami fix the spacing between the star and rate value please
              FaIcon(
                FontAwesomeIcons.solidStar,
                color: mainColor,
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

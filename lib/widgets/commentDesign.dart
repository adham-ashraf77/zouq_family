import 'package:flutter/material.dart';
import 'package:zouqadmin/models/comment.dart';
import 'package:zouqadmin/theme/common.dart';

class CommentDesign extends StatelessWidget {
      final Comment comment;

   CommentDesign({this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - (40 + 64 + 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.redAccent,
                              size: 13,
                            ),
                            Text(
                              comment.rate.toString(),
                              style: paragarph3.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                        Text(comment.name),
                      ],
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width - (40 + 64 + 20),
                      child: Text(
                        comment.comment,
                        maxLines: 4,
                        style: paragarph3.copyWith(fontSize: 13),
                        textDirection: TextDirection.rtl,
                      ))
                ],
              ),
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                radius: 32,
                backgroundImage: NetworkImage(comment.imageUrl),
              ),
            ],
          ),
          SizedBox(height: 10,)
          ,Divider(
            thickness: 1,
          )
        ],
      ),
    );
  }
}

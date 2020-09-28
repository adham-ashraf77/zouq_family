import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:zouqadmin/utils/helpers.dart';

import 'bigImageView.dart';

class ChatBubble extends StatefulWidget {
  final bool isMyMsg;
  final String msg;
  final bool isImg;
  final String imgLink;
  ChatBubble({this.isMyMsg = false, this.msg = "", this.isImg = false, this.imgLink=""});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    ///////////////////////////////////////////////////////////
    /// Chat Styles
    ///////////////////////////////////////////////////////////

    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;
    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );
    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );
    return Bubble(
      style: widget.isMyMsg ? styleMe : styleSomebody,
      child: widget.isImg
          ? InkWell(onTap: (){
            pushPage(context, BigImgView(url: "${widget.imgLink}",));
          },
                      child: Container(
                width: 100,
                height: 100,
                child: FadeInImage.assetNetwork(
                  fit: BoxFit.contain,
                  placeholder: "assets/icons/loading.gif",
                  image: "${widget.imgLink}",
                ),
              ),
          )
          : Text('${widget.msg}'),
    );
  }
}

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final bool isMyMsg;
  final String msg;
  ChatBubble({this.isMyMsg = false, this.msg = ""});
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
      child: Text('${widget.msg}'),
    );
  }
}

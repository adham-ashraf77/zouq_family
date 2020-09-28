import 'package:flutter/material.dart';

class BigImgView extends StatefulWidget {
  final String url;
  BigImgView({this.url});
  @override
  _BigImgViewState createState() => _BigImgViewState();
}

class _BigImgViewState extends State<BigImgView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FadeInImage.assetNetwork(
              fit: BoxFit.contain,
              placeholder: "assets/icons/loading.gif",
              image: "${widget.url}",
            ),
          )
        ],
      ),
    );
  }
}

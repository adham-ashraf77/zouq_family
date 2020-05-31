import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:zouqadmin/models/product_comments&rating.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/pages/editItemPage.dart';
import 'package:zouqadmin/services/delete.dart';
import 'package:zouqadmin/services/show.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';
import 'package:zouqadmin/widgets/chips/ratingChip.dart';
import 'package:zouqadmin/widgets/rate_card.dart';

import '../I10n/app_localizations.dart';
import '../home.dart';

class ItemDetail extends StatefulWidget {
  final String orderId;

  const ItemDetail({@required this.orderId});
  @override
  _ItemDetailState createState() => _ItemDetailState(orderId: this.orderId);
}

class _ItemDetailState extends State<ItemDetail> {
  final String orderId;

  _ItemDetailState({this.orderId});
  int _current = 0;
  //VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  String name;
  String videoUrl;
  String rate;
  String price;
  String description;
  bool isLoading = true;
  bool isPlay = false;
  VideoPlayerController _controller;
  List<ProductsCommentsAndRating> productsCommentsAndRating = List<ProductsCommentsAndRating>();

  static List<String> imgList = [
    //   'https://assets.bonappetit.com/photos/597f6564e85ce178131a6475/16:9/w_1200,c_limit/0817-murray-mancini-dried-tomato-pie.jpg',
    //   'https://assets.bonappetit.com/photos/597f6564e85ce178131a6475/16:9/w_1200,c_limit/0817-murray-mancini-dried-tomato-pie.jpg',
    //   'https://assets.bonappetit.com/photos/597f6564e85ce178131a6475/16:9/w_1200,c_limit/0817-murray-mancini-dried-tomato-pie.jpg',
    //   'https://assets.bonappetit.com/photos/597f6564e85ce178131a6475/16:9/w_1200,c_limit/0817-murray-mancini-dried-tomato-pie.jpg',
    //   // 'https://assets.bonappetit.com/photos/597f6564e85ce178131a6475/16:9/w_1200,c_limit/0817-murray-mancini-dried-tomato-pie.jpg',
    //
  ];

  List child;
  

  static List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  deleteProduct() {
    print('Deleting ' + orderId.toString());

    Delete().delete(productID: orderId).then((onValue) {
      if (onValue.toString().contains('success')) {
        showDialog(
            context: context,
            builder: (BuildContext context) => DialogWorning(
              mss: AppLocalizations.of(context).translate('deleteSuccess'),
                )).then((_) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => Home(),
          ));
        });
      } else {
        print('Error ' + onValue.toString());

        showDialog(
            context: context,
            builder: (BuildContext context) => DialogWorning(
              mss: AppLocalizations.of(context).translate('deleteFailed'),
                ));
      }
    });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,

        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  ControllerVideo() async {
    try {
      // _controller =await VideoPlayerController.network(_product.video);

      _controller = await VideoPlayerController.network('$videoUrl');

      _initializeVideoPlayerFuture = _controller.initialize();
      await initImages();
      if (this.videoUrl != '') {
        await vedioStart();
      }
    } catch (e) {
      print("vvvvvvvvvvvvvvvvvvvvvvvvvvvv");
      print(e);
    }
  }

  Future getData() {
    Show().show(productID: orderId).then((onValue) {
      print('Product ID : ' + orderId.toString());
      print('onValue : ' + onValue.toString());
      var x = jsonDecode(onValue.toString());
      var y = x['product'];

      setState(() {
        this.name = y['name'];
        this.price = y['price'];
        this.rate = y['rate'].toString();
        this.description = y['description'];
        this.videoUrl = y['video'];
        List<dynamic> list = y['media'];
        imgList.clear();

        list.forEach((f) {
          setState(() {
            imgList.add(f.toString());
          });
        });
        print('25er sora' + imgList.last);
      });
    }).then((value) async {
      initImages();
      await ControllerVideo();
      setState(() {
        isLoading = false;
      });
    });
  }

  initImages() {
    child = map<Widget>(
      imgList,
      (index, i) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
            child: Stack(children: <Widget>[
              Image.network(
                i,
                fit: BoxFit.cover,
                width: 5000,
                height: 2000,
              ),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    ).toList();
  }

  vedioStart() {
    child.insert(
      0,
      Stack(
        children: <Widget>[
          Container(
            height: 270,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        isPlay = !isPlay;
                        _controller.value.isPlaying ? _controller.pause() : _controller.play();
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),);
  }

  getComments() async {
    Response response = await Dio().get("https://api.dhuqapp.com/api/client/products/${widget.orderId}/reviews");
    List data = response.data['reviews'];
    data.forEach((element) {
      productsCommentsAndRating.add(ProductsCommentsAndRating.fromJson(element));
    });
  }

  @override
  void initState() {
    super.initState();
    getComments();
    getData();
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

//  void vedioStart() {
//    child.insert(
//        0,
//        Container(
//          margin: EdgeInsets.all(5.0),
//          child: ClipRRect(
//            borderRadius: BorderRadius.all(Radius.circular(15.0)),
//            child: Stack(
//              children: <Widget>[
//                Container(
//                  height: 240,
//                  child: FutureBuilder(
//                    future: _initializeVideoPlayerFuture,
//                    builder: (context, snapshot) {
//                      if (snapshot.connectionState == ConnectionState.done) {
//                        return AspectRatio(
//                          aspectRatio: _controller.value.aspectRatio,
//                          child: VideoPlayer(_controller),
//                        );
//                      } else {
//                        return Container();
//                      }
//                    },
//                  ),
//                ),
//                Positioned(
//                  bottom: 200.0,
//                  left: 50.0,
//                  right: 50.0,
//                  top: 50.0,
//                  child: InkWell(
//                    onTap: () {
//                      setState(() {
//                        if (_controller.value.isPlaying) {
//                          _controller.pause();
//                        } else {
//                          _controller.play();
//                        }
//                      });
//                    },
//                    child: _controller.value.isPlaying
//                        ? Container()
//                        : Image.asset("assets/icons/Play.png"),
//                  ),
//                )
//              ],
//            ),
//          ),
//        ));
//  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.grey[400],
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[300]),
                      strokeWidth: 2,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).translate('loading'),
                    textDirection: TextDirection.ltr,
                    style: paragarph4.copyWith(color: Colors.grey[400], height: 2),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mainColor,
              title: Text(
                AppLocalizations.of(context).translate('productDescription'),
                style: headers3,
              ),
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: true,
            ),
            body: Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: CarouselSlider(
                        items: child,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.5,
                        autoPlay: false,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        viewportFraction: 1.0,
                        onPageChanged: (index) {
                          setState(() {
                            _current = index;
                          });
                        },
                      ),
                    ),

                    _current == 0 ?
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.3,
                      padding: EdgeInsets.only(left: MediaQuery
                          .of(context)
                          .padding
                          .left + 30),
                      alignment: Alignment.center,
                      child: isPlay
                          ? Container() : IconButton(
                        onPressed: () {
                          setState(() {
                            isPlay = !isPlay;
                            _controller.value.isPlaying
                                ? _controller.pause()
                                : _controller.play();
                          });
                        },
                        icon: Icon(Icons.play_circle_outline, color: Colors.cyan, size: 60,),
                      ),
                    ) : Container(),
                  ],
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.6,
                  maxChildSize: 1.0,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                textDirection: TextDirection.rtl,
                                children: map<Widget>(
                                  child,
                                  (index, url) {
                                    return Container(
                                      width: 10,
                                      height: 10,
                                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle, color: _current == index ? accent : inputBackgrounds),
                                    );
                                  },
                                ),
                              ),
                            ),
                            RatingChip(rating: double.parse(this.rate)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                '${this.name}',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Text(
                                '${this.description}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: smallTextColor,
                                ),
                              ),
                            ),
                            ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: productsCommentsAndRating.length,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              itemBuilder: (context, index) {
                                return RateCard(
                                  image:
                                  "${productsCommentsAndRating[index].userInfo.photo}",
                                  name: '${productsCommentsAndRating[index].userInfo.name}',
                                  desc:
                                  '${productsCommentsAndRating[index].comment}',
                                  rate: productsCommentsAndRating[index].rate.toDouble(),
                                );
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            bottomNavigationBar: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.grey[50],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "${this.price}",
                      style: priceText1.copyWith(fontSize: 18),
                    ),
                    Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            // popPage(context);
                            pushPage(context, EditItemPage(id: orderId,));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                              color: accent,
                            ),
                            height: MediaQuery.of(context).size.height * 0.055,
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context).translate('edit'),
                                style: TextStyle(color: mainColor, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(12),
                          child: GestureDetector(
                            onTap: deleteProduct,
                            child: Center(
                              child: Image.asset("assets/icons/delete.png"),
                            ),
                          ),
                          decoration:
                              BoxDecoration(border: Border.all(color: Colors.black, width: 0.1), shape: BoxShape.circle),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }

}

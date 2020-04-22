import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
//import 'package:video_player/video_player.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/services/delete.dart';
import 'package:zouqadmin/services/show.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';
import 'package:zouqadmin/widgets/chips/ratingChip.dart';
import 'package:zouqadmin/widgets/rate_card.dart';

class ItemDetail extends StatefulWidget {
  final String id;

  const ItemDetail({@required this.id});
  @override
  _ItemDetailState createState() => _ItemDetailState(id: this.id);
}

class _ItemDetailState extends State<ItemDetail> {
  final String id;
  _ItemDetailState({this.id});
  int _current = 0;
  //VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  String name;
  String videoUrl;
  String rate;
  String price;
  String description;
  bool isLoading = true;

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
    print('Deleting ' + id.toString());

    Delete().delete(productID: id).then((onValue) {
      if (onValue.toString().contains('success')) {
        showDialog(
            context: context,
            builder: (BuildContext context) => DialogWorning(
                  mss: 'The product has been deleted successfully!',
                )).then((_) {
          popPage(context);
        });
      } else {
        print('Error ' + onValue.toString());

        showDialog(
            context: context,
            builder: (BuildContext context) => DialogWorning(
                  mss: 'Something went wrong please check your connection and try again!',
                ));
      }
    });
  }

  initImages() {
    Show().show(productID: id).then((onValue) {
      print('Product ID : ' + id.toString());
      print('onValue : ' + onValue.toString());
      var x = jsonDecode(onValue.toString());
      var y = x['product'];
      print('=>>> ' + y.toString());
      setState(() {
        this.name = y['name'];
        this.price = y['price'];
        this.rate = y['rate'].toString();
        this.description = y['description'];
        this.videoUrl = y['video'];
        List<dynamic> list = y['media'];
        imgList.clear();
        print('=>>> ' + y.toString());
        list.forEach((f) {
          setState(() {
            imgList.add(f.toString());
          });
        });
        print('25er sora' + imgList.last);
      });

      // if (onValue.toString().contains('success')) {

      //   print(onValue.toString());
      // }
      // else {
      //   print('Error ' + onValue.toString());

      //   showDialog(
      //       context: context,
      //       builder: (BuildContext context) => DialogWorning(
      //             mss:'Something went wrong please check your connection and try again!',
      //           ));
      // }
    }).then((_) {
//              print('=>><< ' + this.videoUrl);
//      _controller = VideoPlayerController.network(
//
//          this.videoUrl == null
//              ? 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'
//              : this.videoUrl);
//      _initializeVideoPlayerFuture = _controller.initialize();
      // vedioStart();
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
    }).whenComplete(() {
      print('gazar');
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    initImages();
    super.initState();
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
////                Container(
////                  height: 240,
////                  child: FutureBuilder(
////                    future: _initializeVideoPlayerFuture,
////                    builder: (context, snapshot) {
////                      if (snapshot.connectionState == ConnectionState.done) {
////                        return AspectRatio(
////                          aspectRatio: _controller.value.aspectRatio,
////                          child: VideoPlayer(_controller),
////                        );
////                      } else {
////                        return Container();
////                      }
////                    },
////                  ),
////                ),
////                Positioned(
////                  bottom: 200.0,
////                  left: 50.0,
////                  right: 50.0,
////                  top: 50.0,
////                  child: InkWell(
////                    onTap: () {
////                      setState(() {
////                        if (_controller.value.isPlaying) {
////                          _controller.pause();
////                        } else {
////                          _controller.play();
////                        }
////                      });
////                    },
////                    child: _controller.value.isPlaying
////                        ? Container()
////                        : Image.asset("assets/icons/Play.png"),
////                  ),
////                )
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
                    'Loading...',
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
                "تفاصيل المنتج",
                style: headers3,
              ),
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: true,
            ),
            body: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: CarouselSlider(
                    items: child,
                    height: MediaQuery.of(context).size.height * 0.5,
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
                            RateCard(
                              image:
                                  "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                              name: 'محمد يوسف',
                              desc: 'الطعام مذاقة جيد ولم يتأخر التوصيل , انصح بطلب هذا المنتج فانة رائع',
                              rate: 4.9,
                            ),
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
                                'تعديل',
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

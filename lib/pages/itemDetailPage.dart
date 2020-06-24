import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import 'magnify_photos_screen.dart';

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
  String productStatus;
  String productMeta;
  String videoUrl;
  String rate;
  String price;
  String description;
  int productId;
  bool isLoading = true;
  bool isPlay = false;
  bool avalaible = false;
  bool onDemand = false;
  bool notAvalaible = false;
  TextEditingController onDemandController = TextEditingController();
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
      } else if (onValue.toString().contains('order contains it')) {
        showDialog(
            context: context,
            builder: (BuildContext context) => DialogWorning(
                  mss: AppLocalizations.of(context).translate('deleteProductFailed'),
                ));
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

  void updateStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    FormData formdata;
    avalaible
        ? formdata = FormData.fromMap({
            "availability_status": "ready",
          })
        : notAvalaible
            ? formdata = FormData.fromMap({
                "availability_status": "unavailable",
              })
            : formdata =
                FormData.fromMap({"availability_status": "upon-request", "availability_meta": "${onDemandController.text}"});
    try {
      print(productId);
      await Dio().post('https://api.dhuqapp.com/api/family/products/$productId/availability',
          data: formdata,
          options: Options(
            headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
          ));
      getData();
      setState(() {});
//      Navigator.of(context).pushReplacement(
//          MaterialPageRoute(builder: (context) => Home(),)
//      );
    } on DioError catch (e) {
      print('error from change status of product');
      print(e.response.data);
    }
  }

  Future getData() {
    Show().show(productID: orderId).then((onValue) {
      print('order ID : ' + orderId.toString());
      print('onValue : ' + onValue.toString());
      var x = jsonDecode(onValue.toString());
      var y = x['product'];
      var availability = x['product']['availability'];

      setState(() {
        this.productStatus = availability['status'];
        this.productMeta = availability['meta'];
        this.productId = y['id'];
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
      videoUrl == null
          ? Center(
              child: Text(
                'لا يوجد فيديو الان',
                style: TextStyle(fontSize: 30),
              ),
            )
          : Stack(
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
                    InkWell(
                      onTap: () {
                        if (_current != 0)
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MagnifyPhotoScreen(imgList, name),
                          ));
                      },
                      child: Align(
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
                    ),
                    _current == 0 && videoUrl != null
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context)
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
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(color: productStatus == 'ready' ? Colors.cyan : Colors.orange)
                              ),
                              child: Text('${
                                  productStatus == 'ready' ?
                                  '${AppLocalizations.of(context).translate('available')}' :
                                  productStatus == 'unavailable' ?
                                  '${AppLocalizations.of(context).translate('notAvailable')}' :
                                  '${AppLocalizations.of(context).translate('onDemand')}'
                              }'),
                            ),
                            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                            productMeta.isEmpty ?
                            Container() :
                            Text('$productMeta', style: TextStyle(color: Colors.orange),),
                            SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        avalaible = true;
                                        notAvalaible = false;
                                        onDemand = false;
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          border: Border.all(color: Colors.cyan),
                                          color: avalaible ? Colors.green : Colors.transparent,
                                        ),
                                        child: Text('${AppLocalizations.of(context).translate('available')}'),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        avalaible = false;
                                        notAvalaible = true;
                                        onDemand = false;
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          border: Border.all(color: Colors.cyan),
                                          color: notAvalaible ? Colors.green : Colors.transparent,

                                        ),
                                        child: Text('${AppLocalizations.of(context).translate('notAvailable')}'),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        avalaible = false;
                                        notAvalaible = false;
                                        onDemand = true;
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          border: Border.all(color: Colors.cyan),
                                          color: onDemand ? Colors.green : Colors.transparent,
                                        ),
                                        child: Text('${AppLocalizations.of(context).translate('onDemand')}'),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: updateStatus,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(25),
                                          ),
                                          color: Color.fromRGBO(29, 174, 209, 1),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context).translate('editStatus'),
                                            style: TextStyle(color: mainColor, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onDemand ?
                            Padding(
                              padding: EdgeInsets.only(left: 30, top: 15),
                              child: TextFormField(
                                controller: onDemandController,
                                validator: (value) {
                                  if (value.length < 10) {
                                    return 'الوصف يجب ان يكون على الاقل 10 احرف';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(10.0),
                                    borderSide: new BorderSide(
                                      color: Colors.black,
                                      width: 0.2,
                                    ),
                                  ),
                                  hintText: AppLocalizations.of(context).translate('productDescription'),
                                  hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                                ),
                                maxLines: 3,
                              ),
                            ) : Container(),

                            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
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

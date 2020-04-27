import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/services/show.dart';
import 'package:zouqadmin/services/updateproduct.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';

class EditItemPage extends StatefulWidget {
  final String id;

  const EditItemPage({@required this.id});

  @override
  _EditItemPageState createState() => _EditItemPageState(id: this.id);
}

class _EditItemPageState extends State<EditItemPage> {
  final String id;
  _EditItemPageState({this.id});
  String _dropdownValue;
  VideoPlayerController vbc;
  File productVideo;
  File _image;
  File _video;
  // List<File> images = [null, null, null, null, null];
  final nameTextFieldController = TextEditingController();
  final priceTextFieldController = TextEditingController();
  final descTextFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<File> productImages = [];
  int categoryID;
  List<String> imgList = List<String>();
  List<File> listOfImages = List<File>();
  List<Asset> images = List<Asset>();
  bool photosIsEmpty = false;
  bool isLoading = false;
  String name;
  String price;
  String rate;
  String description;
  String videoUrl;
  List child;

  Future<File> _downloadFile(String url, String filename) async {
    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
//    if(file!=null && file.isNotEmpty)
//      file.clear();

    String error = 'No Error Dectected';

    Future<File> getImageFileFromAssets(ByteData bytedata, String name) async {
      print('hi');
      final byteData = bytedata;

      final file = File('${(await getTemporaryDirectory()).path}/$name');
      await file.writeAsBytes(
        byteData.buffer
            .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );
      print('bye');
      return file;
    }

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      photosIsEmpty = false;
      images = resultList;
    });
    print('hi');
    print('Here ' + images.length.toString());
    if (images.length > 0) listOfImages.clear();
    images.forEach((image) async {
//      images.first.requestOriginal(quality: 100).then((value){
//
//        print('yoooooooooooooo${value.buffer}');
//      });
      File x = await getImageFileFromAssets(
          await image.requestOriginal(quality: 100), image.name);

      setState(() {
        listOfImages.add(x);
      });
      print(image.name);
      print('fileLength----->${listOfImages.length}');
    });

    print('hi');
    //print('--------->${file.first.path}');
  }

  Future getVideo() async {
    _video = await FilePicker.getFile(type: FileType.video);
    setState(() {
      File videoFile = _video;
      vbc = new VideoPlayerController.file(videoFile)
        ..initialize().then((_) {
          print('Duration : ' +
              vbc.value.duration.toString().split(':').toString());
          var duration = vbc.value.duration.toString().split(':');
          print(duration[0] + ' - ' + duration[1] + ' = ' + duration[2]);
          if (duration[0].trim() == '0' &&
              duration[1].trim() == '00' &&
              double.parse(duration[2]) < 10.0) {
            print('accepted');
            productVideo = videoFile;
          } else {
            print('rejected');
            showDialog(
                context: context,
                builder: (BuildContext context) => DialogWorning(
                      mss: 'مسموح بحد أقصي 10 ثواني فقط',
                    ));
            productVideo = null;
          }
        });

      // _controller = VideoPlayerController.file(videoFile);

      // // Initialize the controller and store the Future for later use.
      // _initializeVideoPlayerFuture = _controller.initialize();

      // // Use the controller to loop the video.
      // _controller.setLooping(true);
    });
  }

  updateProduct() {
    if (_formKey.currentState.validate()) {
      if (_dropdownValue != null) {
        //TODO uploading
        UpdateProduct().updateProduct(
          catID: categoryID + 1,
          desc: descTextFieldController.text,
          name: nameTextFieldController.text,
          listOfPhotos: listOfImages,
          price: priceTextFieldController.text,
          video: productVideo,
          context: context,
          id: id,
        );
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) => DialogWorning(
                  mss: 'من فضلك اختر تصنيف للمنتج',
                ));
      }
    }
    // // if (_formKey.currentState.validate()) {
    // //   if (_dropdownValue != null) {
    // //     productImages.clear();
    // //     for (int i = 0; i < images.length; i++) {
    // //       // if (images[i] != null) {
    // //       //   productImages.add(images[i]);
    // //       // }
    // //     }
    // //     if (productImages.length == 0) {
    // //       showDialog(
    // //           context: context,
    // //           builder: (BuildContext context) => DialogWorning(
    // //                 mss: 'من فضلك اختر على الاقل صورة واحده',
    // //               ));
    // //     } else {
    // //       //TODO uploading
    // //       AddProduct().addProduct(
    // //           catID: categoryID + 1,
    // //           desc: descTextFieldController.text,
    // //           name: nameTextFieldController.text,
    // //           listOfPhotos : listOfImages,
    // //           price: priceTextFieldController.text,
    // //           video: productVideo);
    // //     }
    // //   } else {
    // //     showDialog(
    // //         context: context,
    // //         builder: (BuildContext context) => DialogWorning(
    // //               mss: 'من فضلك اختر تصنيف للمنتج',
    // //             ));
    // //   }
    // }
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Show().show(productID: id).then((onValue) {
      print('Product ID : ' + id.toString());
      print('onValue : ' + onValue.toString());
      var x = jsonDecode(onValue.toString());
      var y = x['product'];
      _dropdownValue = ['حلوى', 'مكسرات', 'اطعمه', 'مطبوخات'][int.parse(
          y['category']['text_en'].toString().replaceAll('category_', ''))];
      categoryID = int.parse(
          y['category']['text_en'].toString().replaceAll('category_', ''));
      setState(() {
        this.name = y['name'];
        this.price = y['price'];
        this.rate = y['rate'].toString();
        this.description = y['description'];
        this.videoUrl = y['video'];
        List<dynamic> list = y['media'];
        nameTextFieldController.text = this.name;
        priceTextFieldController.text = this.price;
        descTextFieldController.text = this.description;
        setState(() {
          imgList.clear();
        });
        list.forEach((f) {
          setState(() {
            imgList.add(f.toString());
          });
        });

        int i = 0;
        setState(() {
          listOfImages.clear();
        });
        for (var url in list) {
          try {            
            i = i + 1;            
            _downloadFile(url, 'file_' + DateTime.now().millisecondsSinceEpoch.toString()).then((onValue) {
              setState(() {
                listOfImages.add(onValue);
              });
            });
            // ImageDownloader.downloadImage(url).then((imageId) {
            //   print('==>>, ' + imageId);
            //   ImageDownloader.findPath(imageId).then((path) {
            //     print('==>>, ' + path);
            //     files.add(File(path));
            //     print('==>>, ' + path);
            //     setState(() {
            //       listOfImages.addAll(files);
            //       print('==>>, ' + listOfImages.toString());
            //     });
            //   });
            // });
          } catch (error) {
            print(error);
          }
        }
        _downloadFile(this.videoUrl, 'video_000').then((onValue) {
          setState(() {
            productVideo = onValue;
            print('Video ' + productVideo.toString());
          });
        });
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
      //stop loading or open update button
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    // print('Edit id : ' + id);
print('Here ' + listOfImages.toString());
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
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.grey[300]),
                      strokeWidth: 2,
                    ),
                  ),
                  Text(
                    'Loading...',
                    textDirection: TextDirection.ltr,
                    style:
                        paragarph4.copyWith(color: Colors.grey[400], height: 2),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              // pinned: true,
              title: Text("اضافة منتج", style: headers1),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.only(right: 30),
              child: Form(
                key: _formKey,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            getVideo().catchError((onError) {
                              print('Error caught' + onError.toString());
                            });
                          },
                          child: Container(
                            width: 160,
                            height: 100,
                            child: Center(
                                child:
                                    // (vbc.value.initialized)
                                    //     ? VideoPlayer(vbc) :
                                    //TODO uncomment the previous files if u want a thumbnail for the video
                                    Image.asset("assets/icons/video.png")),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: Colors.black, width: 0.1),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context).translate('optionalVideo'),
                              style: TextStyle(fontSize: 23),
                            ),
                            Text(
                              AppLocalizations.of(context).translate('tenSecLimit'),
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          AppLocalizations.of(context).translate('productImages'),
                          style: TextStyle(fontSize: 23),
                        ),
                        Text(
                          AppLocalizations.of(context).translate('imagesLimit'),
                          style: paragarph3,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Padding(
                    //     padding:
                    //         EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    //     child: SizedBox(
                    //       height: MediaQuery.of(context).size.height * 0.15,
                    //       child: Directionality(
                    //           textDirection: TextDirection.rtl,
                    //           child: images.length == 0
                    //               ? Container(
                    //                   width: MediaQuery.of(context).size.width * 0.35,
                    //                   margin: EdgeInsets.only(bottom: 10),
                    //                   decoration: BoxDecoration(
                    //                       border: Border.all(
                    //                           color: Colors.green, width: 2),
                    //                       borderRadius:
                    //                           BorderRadius.all(Radius.circular(20))),
                    //                   alignment: Alignment.center,
                    //                   child: Icon(Icons.camera_alt),
                    //                 )
                    //               : ListView.builder(
                    //                   scrollDirection: Axis.horizontal,
                    //                   itemCount: images.length,
                    //                   itemBuilder:
                    //                       ((BuildContext context, int index) {
                    //                     Asset asset = images[index];
                    //                     return AssetThumb(
                    //                       asset: asset,
                    //                       width: 300,
                    //                       height: 300,
                    //                     );
                    //                   }))),
                    //     )),
                    // InkWell(
                    //   onTap: () {
                    //     if (listOfImages != null && listOfImages.isNotEmpty) {
                    //       listOfImages.clear();
                    //     }
                    //     loadAssets();
                    //   },
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width * 0.35,
                    //     height: MediaQuery.of(context).size.height * 0.07,
                    //     margin: EdgeInsets.only(top: 10),
                    //     decoration: BoxDecoration(
                    //         border: Border.all(color: Colors.green, width: 2),
                    //         borderRadius: BorderRadius.all(Radius.circular(20))),
                    //     alignment: Alignment.center,
                    //     child: Text(
                    //       "choose a pic",
                    //     ),
                    //   ),
                    // ),
                    // RaisedButton(
                    //   onPressed: () {
                    //     addItem(listOfImages);
                    //   },
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: InkWell(
                              onTap: () {
                                // pickImageFromGallery(index);
                                loadAssets();
                                
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: 70,
                                  height: 70,
                                  child: listOfImages.length > index
                                      ? Image.file(
                                          listOfImages[index],
                                          fit: BoxFit.fill,
                                        )
                                      : Icon(
                                          Icons.add,
                                          size: 30,
                                          color: Colors.grey,
                                        ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.black, width: 0.10),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, top: 10),
                      child: TextFormField(
                        controller: nameTextFieldController,
                        validator: (value) {
                          if (value.trim().length < 3) {
                            //todo translate
                            return 'Name must be at least 3 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          // border: InputBorder.none,
                          hintText: AppLocalizations.of(context).translate('name'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, top: 10),
                      child: TextFormField(
                        controller: priceTextFieldController,
                        validator: (value) {
                          if (value.trim().length < 1) {
                            //todo translate
                            return 'Please put a price';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          // border: InputBorder.none,
                          hintText: AppLocalizations.of(context).translate('price'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, top: 15),
                      child: DropdownButton<String>(
                        value: _dropdownValue,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromRGBO(29, 174, 209, 1),
                          size: 35,
                        ),
                        elevation: 10,
                        hint: Text(
                          AppLocalizations.of(context).translate('productCategory'),
                        ),
                        underline: Container(
                          height: 1,
                          color: Colors.grey,
                        ),
                        isExpanded: true,
                        onChanged: (String newValue) {
                          setState(() {
                            _dropdownValue = newValue;
                            categoryID = ['حلوى', 'مكسرات', 'اطعمه', 'مطبوخات']
                                .indexOf(_dropdownValue);
                            print('Cat ID' + categoryID.toString());
                          });
                        },
                        items: <String>['حلوى', 'مكسرات', 'اطعمه', 'مطبوخات']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 30, top: 15),
                      child: TextFormField(
                        controller: descTextFieldController,
                        validator: (value) {
                          if (value.length < 10) {
                            return 'description must be at least 10 charcters';
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
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 15),
                        ),
                        maxLines: 3,
                      ),
                    ),
                    GestureDetector(
                      onTap: updateProduct,
                      child: Padding(
                        padding: EdgeInsets.only(left: 30, top: 40, bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                            color: Color.fromRGBO(29, 174, 209, 1),
                          ),
                          height: MediaQuery.of(context).size.height * 0.075,
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).translate('edit'),
                              style: TextStyle(
                                  color: mainColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

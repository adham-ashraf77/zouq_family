import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/services/addproduct.dart';
import 'package:zouqadmin/theme/common.dart';

import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';
import '../I10n/app_localizations.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
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

  List<File> listOfImages = List<File>();
  List<Asset> images = List<Asset>();
  bool photosIsEmpty = false;

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

  addItem(List<File> listOfPhotos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    print('token: $token');
    List<MultipartFile> something = List();

    listOfPhotos.forEach((photo) async {
      something.add(MultipartFile.fromFileSync("${photo.path}"));
      print(listOfPhotos.length);
      print(something.length);
      if (listOfPhotos.length == something.length) {
        print('hi ^^');
        FormData _formData = FormData.fromMap({
          "name": "test1",
          "description": "descriptiondescriptiondescription1111",
          "price": "100",
          "images": something,
          "category_id": 2,
        });
        try {
          print('--------------------> addItemFile: ${_formData.files}');
          Response response;
          if (token.isNotEmpty) {
            print('before response');
            response =
                await Dio().post("http://api.dhuqapp.com/api/family/products",
                    data: _formData,
                    options: Options(
                      headers: {
                        HttpHeaders.authorizationHeader: "Bearer $token"
                      },
                    ));
            print('after response');
            print(response.data);
          }
          if (response.statusCode == 200) {
            return "success";
          } else {
            print(response.data);
            return "something is wrong";
          }
        } on DioError catch (e) {
          print('errooooooooorrrrrrrrr');
          if (e.response == null) return "connection time out";
          print(e.response.data);
        }
      }
      return null;
    });
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

  addProduct() {
    if (_formKey.currentState.validate()) {
      if (_dropdownValue != null) {
        if (listOfImages.length == 0) {
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogWorning(
                    mss: 'من فضلك اختر على الاقل صورة واحده',
                  ));
        } else {
          //TODO uploading
          print('hi from else');
          AddProduct().addProduct(
              catID: categoryID + 1,
              desc: descTextFieldController.text,
              name: nameTextFieldController.text,
              listOfPhotos: listOfImages,
              price: priceTextFieldController.text,
              video: productVideo,
              context: context);
        }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // pinned: true,
        title: Text(AppLocalizations.of(context).translate('addProduct'),
            style: headers1),
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
                        border: Border.all(color: Colors.black, width: 0.1),
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
                        style: TextStyle(color: Colors.grey, fontSize: 13),
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
                              border:
                                  Border.all(color: Colors.black, width: 0.10),
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
                          .indexOf(newValue);
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
                    hintText: AppLocalizations.of(context)
                        .translate('productDescription'),
                    hintStyle: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  maxLines: 3,
                ),
              ),
              GestureDetector(
                onTap: addProduct,
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
                        AppLocalizations.of(context).translate('add'),
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

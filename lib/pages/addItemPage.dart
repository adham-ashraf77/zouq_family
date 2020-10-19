import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:zouqadmin/models/CategoriesTag.dart';
import 'package:zouqadmin/models/TagsModel.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/services/addproduct.dart';
import 'package:zouqadmin/services/getCategories.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/widgets/loading_dialog.dart';

import '../I10n/app_localizations.dart';
import '../home.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  String _dropdownValue;
  VideoPlayerController vbc;
  File productVideo;
  File _image;
  final picker = ImagePicker();
  File _video;

  final nameTextFieldController = TextEditingController();
  final priceTextFieldController = TextEditingController();
  final descTextFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<File> productImages = [];
  int categoryID;
  bool isLoading = true;

  List<File> listOfImages = List<File>();
  List<Asset> images = List<Asset>();
  bool photosIsEmpty = false;
  List<int> tagsIdList = List();

  Future<void> loadAssets(int index) async {
    List<Asset> resultList = List<Asset>();

    PickedFile img = await picker.getImage(source: ImageSource.gallery);
    File selectedImg = File(img.path);
    selectedImg = await ImageCropper.cropImage(
        sourcePath: selectedImg.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
        ],
        compressQuality: 70,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
        ),
        iosUiSettings: IOSUiSettings());
    if (!mounted) return;

    setState(() {
      photosIsEmpty = false;
      _image = File(selectedImg.path);
    });
    try {
      if (_image.existsSync()) listOfImages[index] = _image;
    } catch (e) {
      print(e);
      listOfImages.add(_image);
    }
  }

  addItem(List<File> listOfPhotos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    List<MultipartFile> something = List();

    listOfPhotos.forEach((photo) async {
      something.add(MultipartFile.fromFileSync("${photo.path}"));
      if (listOfPhotos.length == something.length) {
        FormData _formData = FormData.fromMap({
          "name": "test1",
          "description": "descriptiondescriptiondescription1111",
          "price": "100",
          "images": something,
          "category_id": 2,
        });
        try {
          Response response;
          if (token.isNotEmpty) {
            response =
                await Dio().post("http://api.dhuqapp.com/api/family/products",
                    data: _formData,
                    options: Options(
                      headers: {
                        HttpHeaders.authorizationHeader: "Bearer $token"
                      },
                    ));
          }
          if (response.statusCode == 200) {
            return "success";
          } else {
            return "something is wrong";
          }
        } on DioError catch (e) {
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
          if (duration[0].trim() == '0' &&
              duration[1].trim() == '00' &&
              double.parse(duration[2]) < 11.0) {
            productVideo = videoFile;
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) => DialogWorning(
                      mss: AppLocalizations.of(context)
                          .translate('videoLengthError'),
                    ));
            productVideo = null;
          }
        });
    });
  }

  bool isConnected = true;

  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    setState(() {});
  }

  addProduct() async {
    await checkConnection();
    if (tagsSelected.length != 0) {
      if (isConnected) {
        if (_formKey.currentState.validate()) {
          if (categoryID != null) {
            if (listOfImages.length == 0) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => DialogWorning(
                        mss: AppLocalizations.of(context)
                            .translate('addPhotoLengthError'),
                      ));
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => LoadingDialog(
                        mss: AppLocalizations.of(context)
                            .translate('addLoading'),
                      ));
              if (tagsSelected.length != 0) {
                for (int i = 0; i < tagsSelected.length; i++) {
                  tagsIdList.add(tagsSelected[i].id);
                }
              }

              AddProduct()
                  .addProduct(
                      catID: categoryID,
                      tagList: tagsIdList,
                      desc: descTextFieldController.text.isEmpty == true ||
                              descTextFieldController.text == ''
                          ? ''
                          : descTextFieldController.text,
                      name: nameTextFieldController.text,
                      listOfPhotos: listOfImages,
                      price: priceTextFieldController.text,
                      video: productVideo == null ? File('') : productVideo,
                      context: context)
                  .then((value) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Home(),
                ));
              });
            }
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) => DialogWorning(
                      mss: AppLocalizations.of(context)
                          .translate('chooseCategoryLengthError'),
                    ));
          }
        }
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogWorning(
                mss: AppLocalizations.of(context)
                    .translate('أختر وسم واحد على الاقل'),
              ));
    }
  }

  List<CategoriesTag> categories = List<CategoriesTag>();
  List<String> catTags = List<String>();

  getCategories() async {
    await GetCategories().getCategories();
    setState(() {
      categories = GetCategories.categories;
      categories.forEach((element) {
        catTags.add(element.text_ar);
      });
      isLoading = false;
    });
  }

  List<TagsModel> tagsList = List<TagsModel>();
  List<TagsModel> tagsSelected = List<TagsModel>();
  getTags() async {
    await AddProduct().getAllTags();
    setState(() {
      tagsList = AddProduct.tags;
    });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  String dropDownTitleTag = "أختار وسم او اكثر";

  TagsModel selectedTag;

  @override
  void initState() {
    super.initState();
    checkConnection();
    getCategories();
    getTags();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('addProduct'),
            style: headers1.copyWith(fontSize: 25)),
        centerTitle: true,
      ),
      body: !isConnected
          ? Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.signal_wifi_off,
                    size: 50,
                  ),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  Text('الرجاء الاتصال بالانترنت'),
                ],
              ),
            )
          : isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
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
                                setState(() {
                                  getVideo().catchError((onError) {
                                    print('Error caught' + onError.toString());
                                  });
                                });
                              },
                              child: Container(
                                width: 160,
                                height: 100,
                                child: Center(
                                    child: vbc != null
                                        ? vbc.value.initialized
                                            ? VideoPlayer(vbc)
                                            : VideoPlayer(vbc)
                                        : Image.asset(
                                            "assets/icons/video.png")),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.black, width: 0.1),
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
                                  AppLocalizations.of(context)
                                      .translate('optionalVideo'),
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('tenSecLimit'),
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 11),
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
                              AppLocalizations.of(context)
                                  .translate('productImages'),
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('imagesLimit'),
                              style: paragarph3.copyWith(fontSize: 13),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                                    loadAssets(index);
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
                              if (value.trim().length <= 3) {
                                //todo translate
                                return 'الاسم لابد ان يكون على الاقل 3 احرف';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)
                                  .translate('name'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30, top: 10),
                          child: TextFormField(
                            enableInteractiveSelection: false,
                            controller: priceTextFieldController,
                            validator: (value) {
                              if (value.trim().length < 1) {
                                //todo translate
                                return 'من فضلك ضع السعر';
                              } else if (isNumeric(value) == false) {
                                return 'من فضلك ضع السعر بالشكل الصحيح';
                              } else if (double.parse(value) < 1.0) {
                                return 'أقل سعر يجب ادخاله هو 1 ريال';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context)
                                  .translate('price'),
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
                              AppLocalizations.of(context)
                                  .translate('productCategory'),
                            ),
                            underline: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                            isExpanded: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _dropdownValue = newValue;
                                categories.forEach((element) {
                                  if (element.text_ar == newValue) {
                                    categoryID = element.id;
                                  }
                                });
                              });
                            },
                            items: catTags
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        tagsSelected.length == 0
                            ? Container()
                            : Container(
                                height: 55,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: tagsSelected.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: Text(
                                                    tagsSelected[index].name),
                                              ),
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.cancel,
                                                    color: Color.fromRGBO(
                                                        29, 174, 209, 1),
                                                  ),
                                                  onPressed: () {
                                                    tagsSelected
                                                        .removeAt(index);
                                                    setState(() {});
                                                  })
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.1,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              // ),
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: <Widget>[
                              DropdownButton<TagsModel>(
                                  hint: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Text(
                                      dropDownTitleTag,
                                    ),
                                  ),
                                  underline: Container(),
                                  value: selectedTag,
                                  iconSize: 35,
                                  icon: Padding(
                                      padding: const EdgeInsets.only(right: 0),
                                      child: Icon(
                                        Icons.arrow_drop_down,
                                        color: Color.fromRGBO(29, 174, 209, 1),
                                      )),
                                  items: tagsList.map((TagsModel tag) {
                                    return DropdownMenuItem<TagsModel>(
                                        value: tag,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, right: 8),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.4,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  tag.name,
                                                ),
                                                Expanded(
                                                  child: Container(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ));
                                  }).toList(),
                                  onChanged: (TagsModel value) {
                                    setState(() {
                                      print(value.name);
                                      selectedTag = value;
                                      print(selectedTag.name);
                                      tagsSelected.add(value);

                                      print(tagsSelected);
                                    });
                                  })
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30, top: 15),
                          child: TextFormField(
                            controller: descTextFieldController,
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
                              hintStyle: TextStyle(
                                  color: Colors.black54, fontSize: 15),
                            ),
                            maxLines: 3,
                          ),
                        ),
                        GestureDetector(
                          onTap: addProduct,
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 30, top: 40, bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                color: Color.fromRGBO(29, 174, 209, 1),
                              ),
                              height:
                                  MediaQuery.of(context).size.height * 0.075,
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

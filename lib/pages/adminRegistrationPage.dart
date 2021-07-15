import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:zouqadmin/models/categories.dart';
import 'package:zouqadmin/models/cities.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/pages/terms.dart';
import 'package:zouqadmin/services/getData.dart';
import 'package:zouqadmin/services/registeration.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/utils/helpers.dart';
import 'package:zouqadmin/widgets/filterChipWidget.dart';

import '../I10n/app_localizations.dart';
import '../theme/common.dart';
import '../widgets/AppButton.dart';
import 'auth/verificationcode_screen.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

enum DeliveryService { doesDelivery, noDelivery }

class AdminRegistration extends StatefulWidget {
  @override
  _AdminRegistrationState createState() => _AdminRegistrationState();
}

class _AdminRegistrationState extends State<AdminRegistration> {
  DeliveryService selectedDeliveryService;
  String fileName = '';
  String fileType = '';
  final _formKey = GlobalKey<FormState>();
  bool _loodingImage = false;
  String _shopOwnerName;
  String _pIN;
  //String _password;
  //String _email;
  String _phone;
  File _image;
  List<int> _categories = [];
  String _city;
  String _countryCode = "+966";
  List<Categories> _tags = [];
  List<bool> selected = [];
  List<Cities> _allCity = [];
  List<String> _showCity = [];
  bool _isLooding = false;

  bool _agree = false;
  bool _agreeClicked = true;

  // bool percant = false;
  // bool percantClicked = true;

  TextEditingController name = TextEditingController();

  Future getImage(BuildContext context) async {
    setState(() {
      _loodingImage = true;
    });
    // try {
    var file = await selectImg(context);
    setState(() {
      fileName = path.basename(file.path);
      _image = file;
    });
    setState(() {
      _loodingImage = false;
    });

    // } catch (Exception) {
    //   print('Except ' + Exception.toString());
    //   setState(() {
    //     _image = null;
    //     _loodingImage = false;
    //   });
    // }
  }

  bool isConnected = true;

  checkConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
        print('true');
      }
    } on SocketException catch (_) {
      isConnected = false;
      print('false');
    }
    setState(() {});
  }

  validation() async {
    await checkConnection();
    if (isConnected) if (_agree == true) {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          registration();
        }
    } else {
      _agreeClicked = false;
      setState(() {});
    }
  }

  registration() async {
    int idCity;
    Cities city = _allCity.firstWhere((c) => c.text == _city);
    idCity = city.id;
    //if (_image != null) {
    if (name.text != null && name.text != '' && name.text.isNotEmpty) {
      if (_phone != null || int.parse(_phone) == 9) {
//          if (_email != null) {
          if (selectedDeliveryService != null) {
            if (_categories.isNotEmpty) {
              if (_city != null) {
                String response1 = await Registeration().registration(
                    shopName: name.text,
                    shopOwnerName: _shopOwnerName,
                    pIN: _pIN,
                    //email: _email,
                    phone:
                    "${(_countryCode.replaceAll("+", "")).trim()}$_phone",
                    image: _image == null ? File('') : _image,
                    city: idCity,
                    is_delivery_available: selectedDeliveryService ==
                        DeliveryService.doesDelivery
                        ? true
                        : false,
                    categories: _categories);
                setState(() {
                  _isLooding = false;
                });

                if (response1 != "success") {
                  if (response1 == "phoneError")
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            DialogWorning(
                              mss: AppLocalizations.of(context)
                                  .translate('phoneDuplicatedError'),
                            ));
                  else if (response1 == "emailError")
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            DialogWorning(
                              mss: AppLocalizations.of(context)
                                  .translate('emailDuplicatedError'),
                            ));
                  else
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            DialogWorning(
                              mss: response1,
                            ));
                } else {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VerificationcodePage(
                                phone:
                                "${(_countryCode.replaceAll("+", "")).trim()}$_phone",
                                flag: 1,
                              )));
                }
              } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => DialogWorning(
                            mss: AppLocalizations.of(context)
                                .translate('chooseCity'),
                          ));
                }
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => DialogWorning(
                          mss: AppLocalizations.of(context)
                              .translate('categoryError'),
                        ));
                setState(() {
                  _isLooding = false;
                });
              }
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => DialogWorning(
                        mss: AppLocalizations.of(context)
                            .translate('deliveryServiceError'),
                      ));
            }
        //         }
//          else {
//            showDialog(
//                context: context,
//                builder: (BuildContext context) => DialogWorning(
//                      mss: AppLocalizations.of(context).translate('emailError'),
//                    ));
//          }
      }
      else {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                DialogWorning(
                  mss: AppLocalizations.of(context).translate('phoneError'),
                ));
      }
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) =>
                DialogWorning(
                  mss: AppLocalizations.of(context).translate('nameError'),
                ));
      }
//    } else {
//      showDialog(
//          context: context,
//          builder: (BuildContext context) => DialogWorning(
//                mss: AppLocalizations.of(context).translate('imageError'),
//              ));
//    }
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      _countryCode = countryCode.toString();
    });
    print("New Country selected: " + countryCode.toString());
  }

  @override
  void initState() {
    checkConnection();
    setState(() {
      _isLooding = true;
    });
    save();

    super.initState();
  }

  save() async {
    await GetData().getCategories();
    await GetData().getCity();
    setState(() {
      _tags = GetData.arCategories;
      _allCity = GetData.arCity;
      _allCity.forEach((d) {
        _showCity.add(d.text);
      });
      _tags.forEach((d) {
        selected.add(false);
      });
    });
    setState(() {
      _isLooding = false;
    });
  }

  @override
  void dispose() {
    _tags.clear();
    _allCity.clear();
    selected.clear();
    super.dispose();
  }

  void addCategories(int id) {
    _categories.add(id);
    _categories.forEach((element) {
      print(element);
    });
    print('----------------------');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          AppLocalizations.of(context).translate('signUp'),
          style: moreTextStyle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: isConnected
            ? Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      child: InkWell(
                        onTap: () {
                          getImage(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _image == null
                              ? new ExactAssetImage(profileImg)
                              : FileImage(_image),
                          radius: 50,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  _loodingImage ? CircularProgressIndicator() : Container(),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: name,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate('shopName'),
                            hintStyle: hintTextStyle),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        onSaved: (value) {
                          _shopOwnerName = value;
                        },
//                        validator: (value) {
//                          if (_shopOwnerName != null) {
//                            if (value
//                                .trim()
//                                .length == 0) {
//                              return '${AppLocalizations.of(context).translate('shopOwnerNameError')}';
//                            }
//                          }
//                          return null;
//                        },
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate('shopOwnerName'),
                            hintStyle: hintTextStyle),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        onSaved: (value) {
                          _pIN = value;
                        },
//                        validator: (value) {
//                          if (_pIN != null) {
//                            if (value
//                                .trim()
//                                .length == 0 || value
//                                .trim()
//                                .length < 10) {
//                              return '${AppLocalizations.of(context).translate('pINError')}';
//                            }
//                          }
//                          return null;
//                        },
                        decoration: InputDecoration(
                            hintText:
                            AppLocalizations.of(context).translate('PIN'),
                            hintStyle: hintTextStyle),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: TextFormField(
                          maxLength: 9,
                          decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)
                                  .translate('telephone'),
                              hintStyle: hintTextStyle),
                          onSaved: (value) {
                            _phone = value;
                          },
                          validator: (value) {
                            if (value
                                .trim()
                                .length == 0 ||
                                value
                                    .trim()
                                    .length != 9) {
                              print(value
                                  .trim()
                                  .length);
                              return AppLocalizations.of(context)
                                  .translate('phoneError');
                            }
                            return null;
                          },
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: iconsFaded, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: Container(
                  height: 55,
                  child: CountryCodePicker(
                    onChanged: _onCountryChange,
                    initialSelection: 'SA',
                    favorite: ['+966', 'SA'],
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: iconsFaded, width: 1),
                    ),
                  ),
                ),
              ),
//              ListTile(
//                title: Row(
//                  children: <Widget>[
//                    Expanded(
//                      child: TextFormField(
//                        decoration: InputDecoration(
//                            hintText:
//                                AppLocalizations.of(context).translate('email'),
//                            hintStyle:
//                                hintTextStyle), //TODO email verification logic
//                        onSaved: (value) {
//                          _email = value;
//                        },
//                        validator: (value) {
//                          if (value.isEmpty || !value.contains('@')) {
//                            return AppLocalizations.of(context)
//                                .translate('emailError');
//                          }
//                          return null;
//                        },
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//               ListTile(
//                 title: Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: TextFormField(
//                         obscureText: true,
//                         decoration: InputDecoration(
//                             hintText: AppLocalizations.of(context)
//                                 .translate('password'),
//                             hintStyle: hintTextStyle),
//                         onSaved: (value) {
//                           _password = value;
//                         },
//                         validator: (value) {
//                           if (value
//                               .trim()
//                               .length == 0) {
//                             return AppLocalizations.of(context)
//                                 .translate('passwordError');
//                           }
//                           if (value
//                               .trim()
//                               .length < 6) {
//                             return AppLocalizations.of(context)
//                                 .translate('shortPassword');
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
                    ListTile(
                      title: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDeliveryService =
                                  DeliveryService.doesDelivery;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedDeliveryService ==
                                      DeliveryService.doesDelivery
                                      ? accent
                                      : Color(0xFF636363),
                                ),
                                borderRadius: BorderRadius.circular(50)),
                            child: CircleAvatar(
                              child: Icon(
                                FontAwesomeIcons.check,
                                color: Colors.white,
                                size: 9.0,
                              ),
                              radius: 10.0,
                              backgroundColor: selectedDeliveryService ==
                                  DeliveryService.doesDelivery
                                  ? accent
                                  : Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('delivery'),
                          style: productName1,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDeliveryService =
                                  DeliveryService.noDelivery;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedDeliveryService ==
                                      DeliveryService.noDelivery
                                      ? accent
                                      : Color(0xFF636363),
                                ),
                                borderRadius: BorderRadius.circular(50)),
                            child: CircleAvatar(
                              child: Icon(
                                FontAwesomeIcons.check,
                                color: Colors.white,
                                size: 9,
                              ),
                              radius: 10.0,
                              backgroundColor: selectedDeliveryService ==
                                  DeliveryService.noDelivery
                                  ? accent
                                  : Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('noDelivery'),
                          style: productName1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //TODO revise code and add retrive selected item index logic
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.1,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tags.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: FilterChipWidget(
                          chipName: _tags[index].text,
                          isSelected: selected[index],
                          onSelect: (clicked) {
                            if (clicked == true) {
                              addCategories(_tags[index].id);
                            } else {
                              _categories.remove(_tags[index].id);
                              _categories.forEach((element) {
                                print(element);
                              });
                                    print('----------------------');
                                  }
                                  setState(() {
                                    selected[index] = clicked;
                                  });
                                },
                              ),
                            );
                          }),
                    ),
                    SearchableDropdown.single(
                      items: _showCity
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: _city,
                      hint:
                          AppLocalizations.of(context).translate('chooseCity'),
                      searchHint:
                          AppLocalizations.of(context).translate('chooseCity'),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Color.fromRGBO(29, 174, 209, 1),
                        size: 35,
                      ),
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _city = value;
                        });
                      },
                      isExpanded: true,
                    ),
                    // //TODO fill dropdown button with data from api
                    // DropdownButton<String>(
                    //   value: _city,
                    //   icon: Icon(
                    //     Icons.arrow_drop_down,
                    //     color: Color.fromRGBO(29, 174, 209, 1),
                    //     size: 35,
                    //   ),
                    //   elevation: 10,
                    //   hint: Text(
                    //     AppLocalizations.of(context).translate('chooseCity'),
                    //   ),
                    //   underline: Container(
                    //     height: 1,
                    //     color: Colors.grey,
                    //   ),
                    //   isExpanded: true,
                    //   onChanged: (String newValue) {
                    //     setState(() {
                    //       _city = newValue;
                    //     });
                    //   },
                    //   items: _showCity.map<DropdownMenuItem<String>>((String value) {
                    //     return DropdownMenuItem<String>(
                    //       value: value,
                    //       child: Text(value),
                    //     );
                    //   }).toList(),
                    // ),

                    Padding(
                      padding: EdgeInsets.only(left: 25.0, top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                          setState(() {
                            _agree = !_agree;
                            if (_agree == true)
                              _agreeClicked = true;
                            else
                              _agreeClicked = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: _agree ? accent : Color(0xFF636363),
                              ),
                              borderRadius: BorderRadius.circular(50)),
                          child: CircleAvatar(
                            child: Icon(
                              FontAwesomeIcons.check,
                              color: Colors.white,
                              size: 9.0,
                            ),
                            radius: 10.0,
                            backgroundColor: _agree ? accent : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () async {
                        Response response = await Dio().get(
                            'http://api.dhuqapp.com/api/content/page/terms-and-conditions');
                        var data = response.data;
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              TermsAndConditionsPage(
                                data: data,
                              ),
                        ));
                      },
                      child: Text(
                        AppLocalizations.of(context).translate('termsAgree'),
                              style: paragarph4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    _agreeClicked == false
                        ? Text(
                            "الرجاء الموافقه على الشروط و الاحكام",
                            style: TextStyle(color: Colors.red),
                          )
                        : Container(),

                    // Padding(
                    //   padding: EdgeInsets.only(left: 25.0, top: 10.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: <Widget>[
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(
                    //             vertical: 10.0, horizontal: 10),
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //               border: Border.all(
                    //                 color: accent ,
                    //               ),
                    //               borderRadius: BorderRadius.circular(50)),
                    //           child: CircleAvatar(
                    //             child: Icon(
                    //               FontAwesomeIcons.check,
                    //               color: Colors.white,
                    //               size: 9.0,
                    //             ),
                    //             radius: 10.0,
                    //             backgroundColor: accent ,
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: 5,
                    //       ),
                    //       // InkWell(
                    //       //   child: Text(
                    //       //     AppLocalizations.of(context).translate('percantAgree'),
                    //       //     style: paragarph4,
                    //       //   ),
                    //       // ),
                    //     ],
                    //   ),
                    // ),

                    // Text("الرجاء الاشتراك فى باقات ال", style: TextStyle(color: Colors.red),),

                    ListTile(
                      title: _isLooding
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : AppButton(
                              text: AppLocalizations.of(context)
                                  .translate('signUp'),
                              onClick: () {
                                //TODO admin profile editing code
                                validation();
                    }),
              ),
              //TODO remove row testing alert dialogs
//              Row(
//                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  RaisedButton(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(18.0)),
//                      color: accent,
//                      child: Text(
//                        'test non-active',
//                        style: TextStyle(color: Colors.white, fontSize: 20.0),
//                      ),
//                      onPressed: () {
//                        showDialog(
//                            context: context,
//                            builder: (BuildContext context) =>
//                                AccountNotActivatedDialog());
//                      }),
//                  RaisedButton(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.circular(18.0)),
//                      color: accent,
//                      child: Text(
//                        'test frozen',
//                        style: TextStyle(color: Colors.white, fontSize: 20.0),
//                      ),
//                      onPressed: () {
//                        showDialog(
//                            context: context,
//                            builder: (BuildContext context) =>
//                                AccountFrozenDialog());
//                      }),
//                ],
//              )
            ],
          ),
        ) :
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.signal_wifi_off, size: 50,),
              Padding(padding: EdgeInsets.only(top: 30)),
              Text('الرجاء الاتصال بالانترنت'),
            ],
          ),
        ),
      ),
    );
  }
}

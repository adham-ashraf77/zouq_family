import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:zouqadmin/models/categories.dart';
import 'package:zouqadmin/models/cities.dart';
import 'package:zouqadmin/pages/dialogWorning.dart';
import 'package:zouqadmin/services/getData.dart';
import 'package:zouqadmin/services/registeration.dart';
import 'package:zouqadmin/theme/common.dart';
import 'package:zouqadmin/widgets/filterChipWidget.dart';

import '../I10n/app_localizations.dart';
import '../theme/common.dart';
import '../widgets/AppButton.dart';
import 'auth/verificationcode_screen.dart';

enum DeliveryService { doesDelivery, noDelivery }

class AdminRegistration extends StatefulWidget {
  @override
  _AdminRegistrationState createState() => _AdminRegistrationState();
}

class _AdminRegistrationState extends State<AdminRegistration> {
  DeliveryService selectedDeliveryService;
  String dropdownValue = 'one';
  String fileName = '';
  String fileType = '';
  final _formKey = GlobalKey<FormState>();
  String _imageAlert = '';
  String _deliveryAlert = '';
  String _cityAlert = '';
  bool _loodingImage = false;
  String _name;
  String _password;
  String _email;
  String _phone;
  bool _is_delivery_available;
  File _image;
  List<int> _categories = [];
  String _city;
  String _countryCode = "+966";
  List<Categories> _tags = [];
  List<bool> selected = [];
  List<Cities> _allCity = [];
  List<String> _showCity = [];
  bool _isLooding = false;

  Future getImage() async {
    setState(() {
      _loodingImage = true;
    });
    try {
      var file = await FilePicker.getFile(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
      );

      setState(() {
        fileName = p.basename(file.path);
        _image = file;
      });
      setState(() {
        _loodingImage = false;
      });
    } catch (Exception) {
      print('Except ' + Exception.toString());
      setState(() {
        _image = null;
        _loodingImage = false;
      });
    }
  }

  validation() {
    if (_image == null) {
      setState(() {
        _imageAlert = "please select image";
      });
    } else {
      setState(() {
        _imageAlert = '';
      });
    }
    if (selectedDeliveryService == null) {
      setState(() {
        _deliveryAlert = "Please select one";
      });
    } else {
      setState(() {
        _deliveryAlert = '';
      });
    }
    if (_city == null) {
      setState(() {
        _cityAlert = "Please select city";
      });
    } else {
      setState(() {
        _cityAlert = '';
      });
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_image != null) {
        if (selectedDeliveryService != null) {
          if (_city != null) {
            setState(() {
              _isLooding = true;
            });
            registration();
          }
        }
      }
    }
  }

  registration() async {
    int idCity;
    Cities city = _allCity.firstWhere((c) => c.text == _city);
    idCity = city.id;

    if (_image != null) {
      if (_name != null) {
        if (_phone != null || int.parse(_phone) < 7 && int.parse(_phone) > 12) {
          if (_email != null) {
            if (_password != null) {
              if (selectedDeliveryService != null) {
                if (_categories.isNotEmpty) {
                  if (_city != null) {
                    String response1 = await Registeration().registration(
                        name: _name,
                        email: _email,
                        password: _password,
                        phone: "${(_countryCode.replaceAll("+", "")).trim()}$_phone",
                        image: _image,
                        city: idCity,
                        is_delivery_available: selectedDeliveryService == DeliveryService.doesDelivery ? true : false,
                        categories: _categories);
                    setState(() {
                      _isLooding = false;
                    });

                    if (response1 != "success") {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => DialogWorning(
                                mss: response1,
                              ));
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VerificationcodePage(
                                    phone: "${(_countryCode.replaceAll("+", "")).trim()}$_phone",
                                    flag: 1,
                                  )));
                    }
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => DialogWorning(
                              mss: AppLocalizations.of(context).translate('chooseCity'),
                            ));
                  }
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => DialogWorning(
                            mss: AppLocalizations.of(context).translate('categoryError'),
                          ));
                  setState(() {
                    _isLooding = false;
                  });
                }
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => DialogWorning(
                          mss: AppLocalizations.of(context).translate('deliveryServiceError'),
                        ));
              }
            } else {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => DialogWorning(
                        mss: AppLocalizations.of(context).translate('passwordError'),
                      ));
            }
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) => DialogWorning(
                      mss: AppLocalizations.of(context).translate('emailError'),
                    ));
          }
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) => DialogWorning(
                    mss: AppLocalizations.of(context).translate('phoneError'),
                  ));
        }
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) => DialogWorning(
                  mss: AppLocalizations.of(context).translate('nameError'),
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => DialogWorning(
                mss: AppLocalizations.of(context).translate('imageError'),
              ));
    }
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      _countryCode = countryCode.toString();
    });
    print("New Country selected: " + countryCode.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
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
    // TODO: implement dispose
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
        child: Form(
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
                          getImage();
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
              Center(
                child: Text(
                  "$_imageAlert",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        onSaved: (value) {
                          _name = value;
                        },
                        validator: (value) {
                          if (value.trim().length == 0) {
                            return 'Please enter your Name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate('username'),
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
                          maxLength: 12,
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
                            if (value.trim().length == 0 ||
                                value.trim().length < 11) {
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
              ListTile(
                title: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText:
                                AppLocalizations.of(context).translate('email'),
                            hintStyle:
                                hintTextStyle), //TODO email verification logic
                        onSaved: (value) {
                          _email = value;
                        },
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return AppLocalizations.of(context)
                                .translate('emailError');
                          }
                          return null;
                        },
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
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate('password'),
                            hintStyle: hintTextStyle),
                        onSaved: (value) {
                          _password = value;
                        },
                        validator: (value) {
                          if (value.trim().length == 0) {
                            return AppLocalizations.of(context)
                                .translate('passwordError');
                          }
                          if (value.trim().length < 6) {
                            return AppLocalizations.of(context)
                                .translate('shortPassword');
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
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
                              selectedDeliveryService = DeliveryService.doesDelivery;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      selectedDeliveryService == DeliveryService.doesDelivery
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
                              selectedDeliveryService = DeliveryService.noDelivery;
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
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "$_deliveryAlert",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                  textAlign: TextAlign.start,
                ),
              ),
              //TODO revise code and add retrive selected item index logic
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
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
                            }
                            else {
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
              //TODO fill dropdown button with data from api
              DropdownButton<String>(
                value: _city,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color.fromRGBO(29, 174, 209, 1),
                  size: 35,
                ),
                elevation: 10,
                hint: Text(
                  AppLocalizations.of(context).translate('chooseCity'),
                ),
                underline: Container(
                  height: 1,
                  color: Colors.grey,
                ),
                isExpanded: true,
                onChanged: (String newValue) {
                  setState(() {
                    _city = newValue;
                  });
                },
                items: _showCity.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              Text(
                "$_cityAlert",
                style: TextStyle(color: Colors.red, fontSize: 12),
                textAlign: TextAlign.start,
              ),
              ListTile(
                title: _isLooding
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : AppButton(
                        text: AppLocalizations.of(context).translate('signUp'),
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
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConstantVarable {
  static String baseUrl = "http://api-testing.dhuqapp.com";

  // static String baseUrl = "http://api.dhuqapp.com";
  static String apiImg = "https://www.q8pulse.app/public/";
  static String apiMap = "AIzaSyCZCgOpXKbNdhTHAe4ANYKteYQSIYZYlGA";

  static String lang;
  static String userOrCompany;

  static final GlobalKey<FormState> regformKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> regScaffoldkey = GlobalKey<ScaffoldState>();

  static bool regAutoValid = false;

  static final GlobalKey<FormState> loginformKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> loginScaffoldkey =
      GlobalKey<ScaffoldState>();
  static bool loginAutoValid = false;

  static final GlobalKey<FormState> addPageFormKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> addPageScaffoldkey =
      GlobalKey<ScaffoldState>();
  static bool addPageAutoValid = false;

  static final GlobalKey<FormState> sendMessageFormKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> sendMessageScaffoldkey =
      GlobalKey<ScaffoldState>();
  static bool sendMessageAutoValid = false;

  static final GlobalKey<FormState> registerPhoneFormKey =
      GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> registerPhoneScaffoldkey =
      GlobalKey<ScaffoldState>();
  static bool registerPhoneAutoValid = false;

  static final GlobalKey<FormState> socialFormKey = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> socialScaffoldkey =
      GlobalKey<ScaffoldState>();
  static bool socialAutoValid = false;

  static final TextEditingController phoneController = TextEditingController();
  static final TextEditingController emailController = TextEditingController();

  static final TextEditingController passwordController =
      TextEditingController();

  static final TextEditingController confirmPasswordController =
      TextEditingController();

  static final TextEditingController userNameController =
      TextEditingController();

  static final TextEditingController lastNameController =
      TextEditingController();
  static final TextEditingController oldPassController =
      TextEditingController();
  static final TextEditingController nameArController = TextEditingController();
  static final TextEditingController nameEnController = TextEditingController();
  static final TextEditingController messageController =
      TextEditingController();
  static final TextEditingController searchController = TextEditingController();
  static final TextEditingController pageNameController =
      TextEditingController();
  static final TextEditingController pagePhoneController =
      TextEditingController();
  static final TextEditingController pageAddressController =
      TextEditingController();
  static final TextEditingController pageAboutController =
      TextEditingController();
}

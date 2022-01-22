import 'package:country_picker/country_picker.dart';
import 'package:doctro/api/Retrofit_Api.dart';
import 'package:doctro/api/network_api.dart';
import 'package:doctro/model/login.dart';
import 'package:doctro/model/verifyphone.dart';
import 'package:doctro/phoneverification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:doctro/const/prefConstatnt.dart';
import 'package:doctro/const/preference.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/base_model.dart';
import '../../api/server_error.dart';
import '../../const/Palette.dart';
import '../../const/app_string.dart';
import '../../localization/localization_constant.dart';
import '../../model/DetailSetting.dart';
import 'otp_page.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
 // TextEditingController email = TextEditingController();
  //TextEditingController password = TextEditingController();
  TextEditingController _phoneCode = TextEditingController();
  TextEditingController _phone = TextEditingController();
 // TextEditingController _phoneCode = TextEditingController();
  bool _isHidden = true;
  String? msg = "";
  String? deviceToken = "";
  int? verify = 0;
  int? id = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    _detailsetting();
  }
  late LocationData _locationData;
  Location location = new Location();
  Future<void> getLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _locationData = await location.getLocation();

    prefs.setString('lat', _locationData.latitude.toString());
    prefs.setString('lang', _locationData.longitude.toString());
  }
  @override
  Widget build(BuildContext context) {
    double width;double height;
    height = MediaQuery.of(context).size.height;
  //  Size size = MediaQuery.of(context).size;
    width = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Form(
            key: formkey,
            child:   Container(
              height: size.height * 1,
              width: width * 1,
              child: Stack(
                children: [
                  Positioned(top: size.height*0,
                    child: Image.asset(
                      "assets/images/intro_header.png",
                      height: size.height * 0.25,
                      width: width * 1,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.00,
                    child: Container(
                      width: width * 1,
                      height: size.height * 1,

                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: width * 0.00),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/splash.png",
                                  height: size.height * 0.45,
                                  width: width * 0.45,
                                  fit: BoxFit.fitWidth,
                                ),

                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  width: width * 0.21,
                                  height: height * 0.06,
                                  padding: EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                                  margin: EdgeInsets.only(
                                    top: height * 0.01,
                                    left: width * 0.05,
                                    right: width * 0.05,

                                  ),
                                  decoration: BoxDecoration(
                                    color: Palette.dark_white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    textAlign: TextAlign.center,
                                    readOnly: true,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Palette.dark_blue,
                                    ),
                                    controller: _phoneCode,
                                    decoration: InputDecoration(
                                      hintText: '+91',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Palette.dark_grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () {
                                      showCountryPicker(
                                        context: context,
                                        exclude: <String>['KN', 'MF'],
                                        showPhoneCode: true,
                                        onSelect: (Country country) {
                                          _phoneCode.text = "+" + country.phoneCode;
                                        },
                                        countryListTheme: CountryListThemeData(
                                          // Optional. Sets the border radius for the bottomsheet.
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(40.0),
                                            topRight: Radius.circular(40.0),
                                          ),
                                          inputDecoration: InputDecoration(
                                            labelText: getTranslated(context, signUp_phoneCode_label).toString(),
                                            // 'Search',
                                            hintText: getTranslated(context, signUp_phoneCode_hint).toString(),
                                            // 'Start typing to search',
                                            prefixIcon: const Icon(Icons.search),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color:  Palette.grey.withOpacity(0.2),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  width: width * 0.60,
                                  height: height * 0.06,
                                  margin: EdgeInsets.only(
                                    top: size.height * 0.01,
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: Palette.dark_white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextFormField(
                                    controller: _phone,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                      LengthLimitingTextInputFormatter(10)
                                    ],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Palette.dark_blue,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: getTranslated(context, signUp_phoneNo_hint).toString(),
                                      hintStyle: TextStyle(
                                        fontSize: width * 0.04,
                                        color: Palette.dark_grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return getTranslated(context, signUp_phoneNo_validator1).toString();
                                      }
                                      if (value.length != 10) {
                                        return getTranslated(context, signUp_phoneNo_validator2).toString();
                                      }
                                      return null;
                                    },
                                    onSaved: (String? name) {},
                                  ),
                                ),
                              ],
                            ),
                          ),

                        /*  Container(
                            margin: EdgeInsets.only(top: width * 0.02, left: width * 0.07, right: width * 0.07),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                            decoration: BoxDecoration(color: Palette.dark_white, borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              controller: email,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: getTranslated(context, signIn_email_hint).toString(),
                                hintStyle: TextStyle(fontSize: width * 0.038, color: Palette.dark_blue),
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return getTranslated(context, signIn_email_validator1).toString();
                                }
                                if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                                  return getTranslated(context, signIn_email_validator2).toString();
                                  // "Please enter valid email";
                                }
                                return null;
                              },
                              onSaved: (String? name) {},
                            ),
                          ),*/
                         /* Container(
                            margin: EdgeInsets.only(top: size.height * 0.02, left: width * 0.07, right: width * 0.07),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                            decoration: BoxDecoration(color: Palette.dark_white, borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              controller: password,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: getTranslated(context, signIn_password_hint).toString(),
                                hintStyle: TextStyle(fontSize: width * 0.038, color: Palette.dark_blue),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isHidden ? Icons.visibility : Icons.visibility_off,
                                    color: Palette.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isHidden = !_isHidden;
                                    });
                                  },
                                ),
                              ),
                              obscureText: _isHidden,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return getTranslated(context, signIn_password_validator).toString();
                                }
                                return null;
                              },
                              onSaved: (String? name) {},
                            ),
                          ),*/
                          Container(
                            width: width * 1,
                            height: 40,
                            margin: EdgeInsets.only(top: size.height * 0.03, left: 20, right: 20),
                            padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: 0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: RaisedButton(color: Color(0XFF2C9085),
                              child: Text(
                                getTranslated(context, signIn_signIn_button).toString(),
                                style: TextStyle(fontSize: width * 0.045,color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {

                                if (formkey.currentState!.validate()) {
                                 callForLogin();

                                } else {
                                  print('Not Login');
                                }
                              },
                            ),
                          ),
                       /*   Container(
                            height: size.height * 0.06,
                            width: width * 0.85,
                            margin: EdgeInsets.only(
                              left: width * 0.05,
                              right: width * 0.05,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextButton(
                                  child: Text(
                                    getTranslated(context, signIn_forgotPassword_button).toString(),
                                    style: TextStyle(fontSize: width * 0.042, color: Palette.dark_grey),
                                    textAlign: TextAlign.center,
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'forgotpassword');
                                  },
                                ),
                              ],
                            ),
                          ),*/
                         /* Container(
                            margin: EdgeInsets.only(top: size.height * 0.03),
                            alignment: AlignmentDirectional.topStart,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          child: Text(
                                            getTranslated(context, signIn_notAccount).toString(),
                                            style: TextStyle(fontSize: width * 0.04, color: Palette.dark_grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: width * 0.03),
                                      child: GestureDetector(
                                        onTap: () {
                                          // Navigator.pushReplacementNamed(context, 'signup');
                                          Navigator.pushNamed(context, 'OtpPage');
                                        },
                                        child: Text(
                                          getTranslated(context, signIn_signUp_button).toString(),
                                          style: TextStyle(fontSize: width * 0.04, color: Palette.blue, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )*/
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<BaseModel<verifyphone>> callForLogin() async {
    verifyphone response;
    var  body = _phoneCode.text.toString()+ _phone.text.toString();
     // "phone":_phoneCode.text.toString()+ _phone.text.toString(),
     // "password": password.text.toString(),
    //  "device_token": deviceToken,

    setState(() {
      Preferences.onLoading(context);
    });
    try {
      response = await RestClient(Retro_Api2().Dio_Data2()).verifyRequest(body);
      print('OTP');
      print('${response.oTP}');
       {
        setState(() {
          Preferences.hideDialog(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpPage(Phone: body,),
            ),
          );
          verify ;
           id ;

          verify != 0 ? Navigator.pushReplacementNamed(context, "/")
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpPage(Phone: body,),
                  ),
                );
          msg = response.oTP;
      //   email.clear();
       //  password.clear();
          SharedPreferenceHelper.setBoolean(Preferences.is_logged_in, true);
          //SharedPreferenceHelper.setString(Preferences.auth_token, response.data!.token!);

          Fluttertoast.showToast(
            msg: '${response.oTP}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Palette.blue,
            textColor: Palette.white,
          );
        });
      }
    /*  else{
        setState(() {

        Preferences.hideDialog(context);
        Fluttertoast.showToast(
          msg: '${response.oTP}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Palette.blue,
          textColor: Palette.white,
        );
        });
      }*/
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
  Future<BaseModel<DetailSetting>> _detailsetting() async {
    DetailSetting response;

    try {
      response = await RestClient(Retro_Api2().Dio_Data2()).detailsettingRequest();
      setState(() {
        if (response.success == true) {
          SharedPreferenceHelper.setString(Preferences.patientAppId, response.data!.patientAppId!);

          if (response.data!.patientAppId != null) {
            getOneSingleToken(SharedPreferenceHelper.getString(Preferences.patientAppId));
          }
        }
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
  Future<void> getOneSingleToken(appId) async {
    //one signal mate
    try {
      OneSignal.shared.consentGranted(true);
      OneSignal.shared.setAppId(appId);
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
      await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
      OneSignal.shared.promptLocationPermission();
      await OneSignal.shared.getDeviceState().then((value) {
        print('device token is ${value!.userId}');
        return SharedPreferenceHelper.setString(Preferences.device_token, value.userId!);
      });
    } catch (e) {
      print("error${e.toString()}");
    }

    setState(() {
      deviceToken = SharedPreferenceHelper.getString(Preferences.device_token);
    });
  }
}

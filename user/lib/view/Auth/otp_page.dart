import 'package:doctro/api/Retrofit_Api.dart';
import 'package:doctro/api/base_model.dart';
import 'package:doctro/api/network_api.dart';
import 'package:doctro/api/server_error.dart';
import 'package:doctro/const/Palette.dart';
import 'package:doctro/const/app_string.dart';
import 'package:doctro/const/prefConstatnt.dart';
import 'package:doctro/const/preference.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/model/submitOTP.dart';
import 'package:doctro/model/verifyphone.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';


class OtpPage extends StatefulWidget {
  String Phone;
  String phonecode;
  String Otp;
   OtpPage({Key? key,required this.Phone,required this.Otp,required this.phonecode}) : super(key: key);
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String? msg = "";
  String? deviceToken = "";
  int? verify = 0;
  int? id = 0;
  String text = '';
  Future<BaseModel<verifyphone>> callForLogin() async {
    verifyphone response;
    var  body = Phone.toString();


    setState(() {
      Preferences.onLoading(context);
    });
    try {
      response = await RestClient(Retro_Api2().Dio_Data2()).verifyRequest(widget.Phone,);
      print('OTP');
      print('${response.otp}');
      {
        setState(() {
          Preferences.hideDialog(context);



          Fluttertoast.showToast(
            msg: '${response.otp}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Palette.primary,
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
          backgroundColor: Palette.primary,
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
late String Phone;
  void _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
  }
  Future<BaseModel<Submitotp>> SubmitotpLogin() async {
    Submitotp response;
    Map<String, dynamic>  body = {

     "otp":text,
      "phone_code":"91",
      "phone_number":widget.Phone.toString()
    // "password": password.text.toString(),
    //  "device_token": deviceToken,
    };

    setState(() {
      Preferences.onLoading(context);
    });
    try {
      response = await RestClient(Retro_Api2().Dio_Data2()).SubmitOTpRequest(body);

      if (response.status == 200) {
        setState(() {
          print(response.data!.user!.userId.toString());
          Preferences.hideDialog(context);
          SharedPreferenceHelper.setBoolean(Preferences.is_logged_in, true);
          SharedPreferenceHelper.setString(Preferences.auth_token, response.data!.token!);
          SharedPreferenceHelper.setInt(Preferences.userid, response.data!.user!.userId!);
          response.data!.isProfile== true?Navigator.pushNamed(context, '/'):Navigator.pushNamed(context, 'profile');


         /* verify != 0 ? Navigator.pushReplacementNamed(context, "/")
              : Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => phoneverification(id),
            ),
          );*/
          msg = response.msg;

          SharedPreferenceHelper.setBoolean(Preferences.is_logged_in, true);
          //SharedPreferenceHelper.setString(Preferences.auth_token, response.data!.token!);

          Fluttertoast.showToast(
            msg: '${response.msg}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Palette.primary,
            textColor: Palette.white,
          );
        });
      }else{
        setState(() {

          Preferences.hideDialog(context);
          Fluttertoast.showToast(
            msg: '${response.msg}',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Palette.primary,
            textColor: Palette.white,
          );
        });
      }
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
        child: Center(child: Text(text[position], style: TextStyle(color: Colors.black),)),
      );
    } catch (e) {
      return Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0),
            borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width;double height;
    height = MediaQuery.of(context).size.height;
    //  Size size = MediaQuery.of(context).size;
    width = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    return  Scaffold(
              backgroundColor: Colors.white,
             // key: loginStore.otpScaffoldKey,

              body:  Stack(
                  children:[
                    Positioned(top: size.height*0,
                      child: Image.asset(
                        "assets/images/intro_header.png",
                        height: size.height * 0.25,
                        width: width * 1,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(

                                        child: Column(
                                          children: [
                                            Image.asset(
                                              "assets/images/phonelogo.png",
                                              height: size.height * 0.20,
                                              width: width * 0.20,
                                              fit: BoxFit.fitWidth,
                                            ),

                                          ],
                                        ),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 60),
                                          child: Center(child: Text(' Phone Verification', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)))
                                      ),
                                      SizedBox( height:height*0.02),
                                      Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 60),
                                          child: Center(child: Text('Please enter the 6-digit code sent to you at ${widget.Phone} ', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500)))
                                      ),
                                      SizedBox( height:height*0.02),
                                      Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 60),
                                          child: Center(child: Text('SMS Panel Not intergated so we  are showing your OTP Here  ${widget.Otp} ', style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500)))
                                      ),
                                      SizedBox( height:height*0.07),
                                      Container(
                                        constraints: const BoxConstraints(
                                            maxWidth: 500
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            otpNumberWidget(0),
                                            otpNumberWidget(1),
                                            otpNumberWidget(2),
                                            otpNumberWidget(3),
                                            otpNumberWidget(4),

                                            //otpNumberWidget(5),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                /* Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                constraints: const BoxConstraints(
                                    maxWidth: 500
                                ),
                                child: RaisedButton(
                                  onPressed: () {
                                    //loginStore.validateOtpAndLogin(context, text);
                                  },
                                  color: Palette.light_blue,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(14))
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text('Confirm', style: TextStyle(color: Colors.white),),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                                            color: Palette.light_blue,
                                          ),
                                          child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16,),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),*/
                                Container(
                                  margin: EdgeInsets.only(top: size.height * 0.03),
                                  alignment: AlignmentDirectional.topStart,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              InkWell(onTap: (){

                                              },
                                                child: Container(
                                                  child: Text(
                                                    'Not receive any Code?',
                                                    style: TextStyle(fontSize: width * 0.04, color: Palette.dark_grey),
                                                  ),
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
                                              child: Text('Resend in 30sec',
                                                style: TextStyle(fontSize: width * 0.04, color: Palette.light_blue, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                NumericKeyboard(
                                  onKeyboardTap: _onKeyboardTap,
                                  textColor: Palette.light_blue,
                                  rightIcon: Icon(
                                    Icons.check,
                                    color: Palette.light_blue,
                                  ),
                                  leftIcon: Icon(
                                    Icons.backspace,
                                    color: Palette.light_blue,
                                  ),
                                  leftButtonFn: (){
                                    setState(() {
                                      text = text.substring(0, text.length - 1);
                                    });
                                  },
                                  rightButtonFn: () {
                                    setState(() {
                                      SubmitotpLogin();

                                      // text = text.substring(0, text.length - 1);
                                    });
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),]
              ),
            )



    ;
  }
}
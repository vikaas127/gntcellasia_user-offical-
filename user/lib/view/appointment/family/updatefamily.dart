

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctro/api/Retrofit_Api.dart';
import 'package:doctro/api/apis.dart';
import 'package:doctro/api/base_model.dart';
import 'package:doctro/api/network_api.dart';
import 'package:doctro/api/server_error.dart';
import 'package:doctro/const/Palette.dart';
import 'package:doctro/const/app_string.dart';
import 'package:doctro/const/prefConstatnt.dart';
import 'package:doctro/const/preference.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../Bookappointment.dart';
import 'models/M_addmmember.dart';

class UpdateFamilymember extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return UpdateFamilymember_state();
  }

}
class UpdateFamilymember_state extends State<UpdateFamilymember>{
  File? _Proimage;
  final picker = ImagePicker();
  bool _loadding = false;
  late var temp;
  TextEditingController appointment_for = TextEditingController();
  TextEditingController patient_name = TextEditingController();
  TextEditingController illness_information = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController patient_address = TextEditingController();
  TextEditingController phone_no = TextEditingController();
  TextEditingController drug_effect = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController payment_status = TextEditingController();

  TextEditingController _Offer = TextEditingController();
  void _ChooseProfileImage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(
                      "From Gallery",
                    ),
                    onTap: () {
                      _ProimgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    "From Camera",
                  ),
                  onTap: () {
                    _ProimgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void _ProimgFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(
          () {
        if (pickedFile != null) {
          SharedPreferenceHelper.setString(Preferences.image, pickedFile.path);
          _Proimage = File(SharedPreferenceHelper.getString(Preferences.image)!);
          List<int> imageBytes = _Proimage!.readAsBytesSync();
          print(imageBytes);
          String base64Image = base64Encode(imageBytes);
          //  List<int> imageBytes = _Proimage!.readAsBytesSync();
          image = base64Encode(imageBytes);
          //       String   image2 = base64Encode(imageBytes);
          print('vikaas');
          print(base64Image);
          //   callApiUpdateImage();
        } else {
          print('No image selected.');
        }
      },
    );
  }
  String? image = "";

  void _ProimgFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        SharedPreferenceHelper.setString(Preferences.image, pickedFile.path);
        _Proimage = _Proimage = File(SharedPreferenceHelper.getString(Preferences.image)!);
        List<int> imageBytes = _Proimage!.readAsBytesSync();
        image = base64Encode(imageBytes);
        //  callApiUpdateImage();
      } else {
        print('No image selected.');
      }
    });
  }
  Future<BaseModel<M_addmmember>> callApiUpdateProfile() async {
    M_addmmember response;

    Map<String, dynamic> body =
    {
      "user_id": SharedPreferenceHelper.getInt(Preferences.userid),
      "name": patient_name.text,
      "mobile":phone_no.text ,
      "email": "rani@mailinator.com",
      "sex": "female",
      "dob": null,
      "address": patient_address.text
    };


    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api().Dio_Data()).UpdatemembersRequest(body);
      print("1234566");
      print(response.message.toString());
      setState(() {
        if (response.status == 200) {
          setState(() {
            _loadding = false;
            Fluttertoast.showToast(
              msg: '${response.message}',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Palette.primary,
              textColor: Palette.white,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Bookappointment( 31),
              ),
            );
          });
        }
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    return Scaffold(  bottomNavigationBar: Container(
      height: height * 0.05,
      child: ElevatedButton(
        child: Text(
          getTranslated(context, profile_save_button).toString(),
          style: TextStyle(
            fontSize: width * 0.04,
            color: Palette.white,
          ),
        ),
        onPressed: () {

          callApiUpdateProfile();

        },
      ),
    ),
      appBar: AppBar(),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50,),
                Center(
                  child: Container(
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle, // BoxShape.circle or BoxShape.retangle
                      boxShadow: [
                        new BoxShadow(
                          color: Palette.primary,
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 85,
                          width: 85,
                          child: Stack(
                            clipBehavior: Clip.none,
                            fit: StackFit.expand,
                            children: [
                              _Proimage != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _Proimage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : CachedNetworkImage(
                                alignment: Alignment.center,
                                imageUrl: '${Apis.baseUrlImages}${''}',
                                imageBuilder: (context, imageProvider) => CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Palette.white,
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundImage: imageProvider,
                                  ),
                                ),
                                placeholder: (context, url) => SpinKitFadingCircle(color: Palette.primary),
                                errorWidget: (context, url, error) => ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset("assets/images/no_image.jpg"),
                                ),
                                height: 95,
                                width: 95,
                                fit: BoxFit.fitHeight,
                              ),
                              Positioned(
                                top: 50,
                                left: 65,
                                child: GestureDetector(
                                  onTap: () {
                                    _ChooseProfileImage();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Palette.dark_grey,
                                    radius: 18,
                                    child: SvgPicture.asset(
                                      'assets/icons/camera.svg',

                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                Container(
                  margin: EdgeInsets.only(top: width * 0.05),
                  child: Column(
                    children: [
                      Text(
                        getTranslated(context, bookAppointment_patient_title).toString(),
                        style: TextStyle(
                            fontSize: width * 0.04,
                            color: Palette.dark_blue,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  controller: patient_name,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
                  ],
                  style: TextStyle(
                    fontSize: width * 0.04,
                    color: Palette.dark_blue,
                  ),
                  decoration: InputDecoration(
                    hintText: getTranslated(context, bookAppointment_patient_hint).toString(),
                    // 'Enter patient name',
                    hintStyle: TextStyle(
                      fontSize: width * 0.04,
                      color: Palette.grey,
                    ),
                  ),
                  validator: (String? value) {
                    value!.trim();
                    if (value.isEmpty) {
                      return getTranslated(context, bookAppointment_patient_validator1).toString();
                      // "Please enter patient name";
                    } else if (value.trim().length < 1) {
                      return getTranslated(context, bookAppointment_patient_validator2).toString();
                      // "Please enter patient valid name";
                    }
                    return null;
                  },
                  onChanged: (String name) {
                    name.trim();
                  },
                ),

                Container(
                  margin: EdgeInsets.only(top: width * 0.05),
                  child: Column(
                    children: [
                      Text(
                        getTranslated(context, bookAppointment_age_title).toString(),
                        style: TextStyle(
                            fontSize: width * 0.04,
                            color: Palette.dark_blue,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                TextFormField(
                  controller: age,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]'))
                  ],
                  style: TextStyle(
                    fontSize: width * 0.04,
                    color: Palette.dark_blue,
                  ),
                  decoration: InputDecoration(
                    hintText: getTranslated(context, bookAppointment_age_hint).toString(),
                    // 'Enter patient age',
                    hintStyle: TextStyle(
                      fontSize: width * 0.04,
                      color: Palette.grey,
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return getTranslated(context, bookAppointment_age_validator).toString();
                    }
                    return null;
                  },
                  onSaved: (String? name) {},
                ),
                Container(

                  margin: EdgeInsets.only(top: width * 0.05),
                  child: Column(
                    children: [
                      Text(
                        getTranslated(context, bookAppointment_patientAddress_title).toString(),

                        style: TextStyle(
                            fontSize: width * 0.04,
                            color: Palette.dark_blue,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: patient_address,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9, ]'))
                  ],
                  style: TextStyle(
                    fontSize: width * 0.04,
                    color: Palette.dark_blue,
                  ),
                  decoration: InputDecoration(
                    hintText: getTranslated(context, bookAppointment_patientAddress_text).toString(),

                    hintStyle: TextStyle(
                      fontSize: width * 0.04,
                      color: Palette.grey,
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return getTranslated(context, bookAppointment_patientAddress_validator1).toString();

                    } else if (value.trim().length < 1) {
                      return getTranslated(context, bookAppointment_patientAddress_validator2).toString();

                    }
                    return null;
                  },
                  onSaved: (String? name) {},
                ),
                Container(

                  margin: EdgeInsets.only(top: width * 0.05),
                  child: Column(
                    children: [
                      Text(
                        getTranslated(context, bookAppointment_phoneNo_title).toString(),

                        style: TextStyle(
                            fontSize: width * 0.04,
                            color: Palette.dark_blue,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                TextFormField(
                  controller: phone_no,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    LengthLimitingTextInputFormatter(10)
                  ],
                  style: TextStyle(
                    fontSize: width * 0.035,
                    color: Palette.dark_blue,
                  ),
                  decoration: InputDecoration(
                    hintText: getTranslated(context, bookAppointment_phoneNo_hint).toString(),

                    hintStyle: TextStyle(
                      fontSize: width * 0.04,
                      color: Palette.grey,
                    ),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return getTranslated(context, bookAppointment_phoneNo_Validator1).toString();

                    }
                    if (value.length != 10) {
                      return getTranslated(context, bookAppointment_phoneNo_Validator2).toString();

                    }
                    return null;
                  },
                  onSaved: (String? name) {},
                ),

              ],
            ),
          ),
        ),
      ),

    );
  }

}
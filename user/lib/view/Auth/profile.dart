import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:doctro/api/Retrofit_Api.dart';
import 'package:doctro/api/apis.dart';
import 'package:doctro/api/network_api.dart';
import 'package:doctro/const/prefConstatnt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../appointment/Bookappointment.dart';
import '../../../const/preference.dart';
import '../../api/base_model.dart';
import '../../api/server_error.dart';
import '../../const/Palette.dart';
import '../../const/app_string.dart';
import '../../localization/localization_constant.dart';
import '../../model/UpdateProfile.dart';
import '../../model/UpdateUserImage.dart';
import '../../model/UserDetail.dart';

class profile extends StatefulWidget {
  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {
  bool _loadding = false;

  List<String> gender = ['MALE', 'FEMALE'];
  String? _selectGender= 'MALE';
  String? selectDate;
  String name = "";
  String? image = "";
  String? email = "";
  String? msg = "";

  String newDateApiPass = "";
  String newDateUser = "10-3-2022";

  DateTime? _selectedDate;

  // DateTime _firstTimeSelected;

  String New_Date = "";
  String New_Dateuser = "";

  // Country _selected;

  File? _Proimage;
  final picker = ImagePicker();

  late var temp;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _phoneCode = TextEditingController();
  TextEditingController _phoneNo = TextEditingController();
  TextEditingController _dateOfBirth = TextEditingController(text: '10-02-2022');
  TextEditingController _email = TextEditingController(text:'email@gmail.com');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("/////USER ID //////");
    print(SharedPreferenceHelper.getInt(Preferences.userid));
    callApiUserProfile( SharedPreferenceHelper.getInt(Preferences.userid));
  }

  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    Size size = MediaQuery.of(context).size;
    print('${Apis.baseUrlImagesprofile}${image}');
    return  ModalProgressHUD(
      inAsyncCall: _loadding,
      opacity: 0.5,
      progressIndicator: SpinKitFadingCircle(
        color: Palette.primary,
        size: 50.0,
      ),
      child: Scaffold(

        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [//image
               Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/images/intro_header.png",
                      height: size.height * 0.10,
                      width: width * 1,
                      fit: BoxFit.fitWidth,
                    ),
                  ),

                Container(
                  width: width * 1.57,
                  height: height * 0.03,),
                Container(
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle, // BoxShape.circle or BoxShape.retangle
                    boxShadow: [
                      new BoxShadow(
                        color: Palette.primary,
                        blurRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 105,
                        width: 105,
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
                              imageUrl: '${Apis.baseUrlImagesprofile}${image}',
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
                              height: 105,
                              width: 105,
                              fit: BoxFit.fitHeight,
                            ),
                            Positioned(
                              top: 70,
                              left: 75,
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
                Form(
                  key: formkey,
                  child: Container(
                    margin: EdgeInsets.only(top: size.height * 0.02),
                    width: width * 0.9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
// full name
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(height: 55,
                            margin: EdgeInsets.only(
                                top: size.height * 0.01, left: width * 0.05, right: width * 0.05),
                            // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                            decoration: BoxDecoration(
                                color: Palette.dark_white, borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              controller: _name,
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
                              ],
                              textCapitalization: TextCapitalization.words,
                              style: TextStyle(
                                fontSize: 16,
                                color: Palette.dark_blue,
                              ),
                              decoration: InputDecoration(suffixIcon:
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'assets/icons/profile.svg',height: 10,width: 10,

                                ),
                              ),

                                label: Text("Full Name"),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide: new BorderSide(),
                                ),
                                hintText: getTranslated(context, signUp_userName_hint).toString(),
                                hintStyle: TextStyle(
                                  fontSize: width * 0.04,
                                  color: Palette.dark_grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              validator: (String? value) {
                                value!.trim();
                                if (value.isEmpty) {
                                  return getTranslated(context, signUp_userName_validator1).toString();
                                } else if (value.trim().length < 1) {
                                  return getTranslated(context, signUp_userName_validator2).toString();
                                }
                                return null;
                              },
                              onSaved: (String? name) {},
                            ),
                          ),
                        ),
//gender
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                          child: Container(height: 55,
                            margin: EdgeInsets.only(
                                top: size.height * 0.01, left: width * 0.05, right: width * 0.05),
                            // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                            decoration: BoxDecoration(
                                color: Palette.dark_white, borderRadius: BorderRadius.circular(10)),
                            child: DropdownButtonFormField(
                              style: TextStyle(
                                fontSize: 15,
                                color: Palette.dark_blue,
                              ),
                              decoration: InputDecoration(
                                label: Text("Gender"),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide: new BorderSide(),
                                ),
                                hintText: getTranslated(context, signUp_selectGender_hint).toString(),
                                hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Palette.dark_grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              value: _selectGender,
                              isExpanded: true,
                              iconSize: 25,
                              onSaved: (dynamic value) {
                                setState(
                                      () {
                                    _selectGender = value;
                                  },
                                );
                              },
                              onChanged: (dynamic newValue) {
                                setState(
                                      () {
                                    _selectGender = newValue;
                                  },
                                );
                              },
                              validator: (dynamic value) => value == null ? getTranslated(context, signUp_selectGender_validator).toString() : null,
                              items: gender.map(
                                    (location) {
                                  return DropdownMenuItem<String>(
                                    child: new Text(
                                      location,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Palette.dark_blue,
                                      ),
                                    ),
                                    value: location,
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                        //calender
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(height: 55,
                            margin: EdgeInsets.only(
                                top: size.height * 0.01, left: width * 0.05, right: width * 0.05),
                            //padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                            decoration: BoxDecoration(
                                color: Palette.dark_white, borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              style: TextStyle(
                                fontSize: 14,
                                color: Palette.dark_blue,
                              ),
                              controller: _dateOfBirth,
                              decoration: InputDecoration(suffixIcon:    Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(
                                  'assets/icons/calender.svg',height: 10,width: 10,

                                ),
                              ),
                                label: Text("Date of Birth"),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide: new BorderSide(),
                                ),
                                hintText: getTranslated(context, signUp_birthDate_hint).toString(),

                                hintStyle: TextStyle(
                                    fontSize: width * 0.04,
                                    color: Palette.dark_grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return getTranslated(context, signUp_birthDate_validator1).toString();
                                }
                                return null;
                              },
                              onTap: () {
                                _selectDate(context);
                              },
                            ),
                          ),
                        ),
                        //email
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 4),
                          child: Container(height: 55,
                            margin: EdgeInsets.only(
                                top: size.height * 0.01, left: width * 0.05, right: width * 0.05),
                            // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                            decoration: BoxDecoration(
                                color: Palette.dark_white, borderRadius: BorderRadius.circular(10)),
                            child: TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.text,
                              style: TextStyle(
                                fontSize: 14,
                                color: Palette.dark_blue,
                              ),
                              decoration: InputDecoration(suffixIcon:  Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(
                                  'assets/icons/email.svg',height: 10,width: 10,

                                ),
                              ),
                                label: Text("Email"),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                  borderSide: new BorderSide(),
                                ),
                                hintText: getTranslated(context, signUp_email_hint).toString(),
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Palette.dark_grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return getTranslated(context, signUp_email_validator1).toString();
                                }
                                if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return getTranslated(context, signUp_email_validator1).toString();
                                }
                                return null;
                              },
                              onSaved: (String? name) {},
                            ),
                          ),
                        ),
//phone code
                        Container(
                          margin: EdgeInsets.only(
                              top: size.height * 0.01, left: width * 0.05, right: width * 0.05),
                          // padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                              color: Palette.dark_white, borderRadius: BorderRadius.circular(10)),
                          child:  Row(
                            children: [
                              Container(
                                width: width * 0.23,
                                height: 55,
                                // margin: EdgeInsets.symmetric(horizontal: 9),
                                child: TextFormField(

                                  textAlign: TextAlign.center,
                                  textAlignVertical: TextAlignVertical.bottom,
                                  readOnly: true,
                                  style: TextStyle(fontSize: 16, color: Palette.dark_blue, fontWeight: FontWeight.bold),
                                  controller: _phoneCode,
                                  decoration: InputDecoration(

                                    hintText: '+91',
                                    label: Text("india"),
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(15.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    hintStyle: TextStyle(
                                      fontSize: 12,
                                      color: Palette.dark_grey1,
                                    ),
                                  ),
                                  onTap: () {
                                    showCountryPicker(
                                      context: context,
                                      //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                                      exclude: <String>['KN', 'MF'],
                                      //Optional. Shows phone code before the country name.
                                      showPhoneCode: true,
                                      onSelect: (Country country) {
                                        _phoneCode.text = "+" + country.phoneCode;
                                      },
                                      // Optional. Sets the theme for the country list picker.
                                      countryListTheme: CountryListThemeData(
                                        // Optional. Sets the border radius for the bottomsheet.
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40.0),
                                          topRight: Radius.circular(40.0),
                                        ),
                                        // Optional. Styles the search field.
                                        inputDecoration: InputDecoration(   border: InputBorder.none,
                                          labelText: getTranslated(context, profile_phoneCode_search).toString(),
                                          // 'Search',
                                          hintText: getTranslated(context, profile_phoneCode_hint).toString(),
                                          // 'Start typing to search',
                                          prefixIcon: const Icon(Icons.search),

                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                width: width * 0.57,
                                height: 55,
                                child: TextFormField(
                                  readOnly: true,
                                  textAlignVertical: TextAlignVertical.bottom,

                                  style: TextStyle(fontSize: 16, color: Palette.dark_blue, letterSpacing: 0.5, fontWeight: FontWeight.bold),
                                  controller: _phoneNo,
                                  decoration: InputDecoration(suffixIcon: Icon(Icons.phone,color: Palette.light_blue,),
                                    hintText: getTranslated(context, profile_phoneNo_hint).toString(),
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Palette.dark_grey1,
                                    ),
                                    label: Text("Phone no"),
                                    border: new OutlineInputBorder(
                                      borderRadius: new BorderRadius.circular(15.0),
                                      borderSide: new BorderSide(),
                                    ),
                                  ),
                                  /* validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return getTranslated(context, profile_phoneNo_validation1).toString();
                                          }
                                          if (value.length != 10) {
                                            return getTranslated(context, profile_phoneNo_validation2).toString();
                                          }
                                          return null;
                                        },*/
                                ),
                              ),
                            ],
                          ),
                        ),














                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: height * 0.10,
          child: Column(
            children: [

              Container( height: height * 0.05,width: width*0.75,
                child: ElevatedButton(
                  child: Text(
                    getTranslated(context, profile_save_button).toString(),
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: Palette.white,
                    ),
                  ),
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      callApiUpdateProfile();
                    } else {
                      print('Not update');
                    }
                  },
                ),
              ),
              SizedBox(height:height * 0.05 ,),
            ],
          ),
        ),
      ),
    );
  }

  Future<BaseModel<UserDetail>> callApiUserProfile(int id) async {
    UserDetail response;
    setState(() {
      _loadding = true;

    });
    try {

      response = await RestClient(Retro_Api().Dio_Data()).userdetailRequest(id.toString());
      print(response.data!.profileDetail!.mobile.toString());
      print(response.data!.profileDetail!.name.toString());
      setState(() {
        _loadding = false;

        _name.text = response.data!.profileDetail!.name!=null?response.data!.profileDetail!.name!:"";
        _phoneCode.text = response.data!.profileDetail!.mobile_code!.toString();
        _phoneNo.text =response.data!.profileDetail!.mobile!=null?response.data!.profileDetail!.mobile!:"";
        print("mobile data");
        print( _phoneNo.text);
        _email.text =response.data!.profileDetail!.email!=null?response.data!.profileDetail!.email!:"";
        selectDate = response.data!.profileDetail!.dob;
        _selectGender = response.data!.profileDetail!.sex!.toUpperCase();
       image = response.data!.profileDetail!.photo;
       print(image);
        email = response.data!.profileDetail!.email;

        // Date Formate Display user
       newDateUser = selectDate!=null?DateUtil().formattedDate(DateTime.parse(selectDate!)):"";
        _dateOfBirth.text = newDateUser;
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
      firstDate: DateTime(1950, 1),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Palette.primary,
              onPrimary: Palette.white,
              surface: Palette.primary,
              onSurface: Palette.light_black,
            ),
            dialogBackgroundColor: Palette.white,
          ),
          child: child!,
        );
      },
    );
    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _dateOfBirth
        ..text = DateFormat('dd-MM-yyyy').format(_selectedDate!)
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: _dateOfBirth.text.length, affinity: TextAffinity.upstream),
        );
    }
  }

  Future<BaseModel<UpdateProfile>> callApiUpdateProfile() async {
    UpdateProfile response;
    if (_selectedDate != null) {
      temp = '$_selectedDate';
    } else {
      temp = '$selectDate';
    }
    newDateApiPass = DateUtilforpass().formattedDate(DateTime.parse(temp));
    Map<String, dynamic> body = {

        "user_id": SharedPreferenceHelper.getInt(Preferences.userid),
        "name": _name.text,
       // "mobile": "8233081931",
        "email": _email.text,
        "dob": newDateApiPass,
        "photo": "",
        "sex": _selectGender,
        "language": Preferences.current_language_code,
    };
    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api().Dio_Data()).updateProfileRequest(body);
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
            Navigator.pushNamed(context, '/');
          });
        }
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<UpdateUserImage>> callApiUpdateImage() async {
    UpdateUserImage response;
    Map<String, dynamic> body = {
      "user_id":SharedPreferenceHelper.getInt(Preferences.userid).toString(),
      "photo": "data:image/png;base64,${image}",
    };
    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api().Dio_Data()).updateUserImageRequest(body);
      setState(() {
        if (response.status == 200) {
          setState(() {
            _loadding = false;
            msg = response.message;
            Fluttertoast.showToast(
              msg: '$msg',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Palette.primary,
              textColor: Palette.white,
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

          image = base64Encode(imageBytes);
   //       String   image2 = base64Encode(imageBytes);
          print('vikaas');
          print(base64Image);
          callApiUpdateImage();
        } else {
          print('No image selected.');
        }
      },
    );
  }

  void _ProimgFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        SharedPreferenceHelper.setString(Preferences.image, pickedFile.path);
        _Proimage = _Proimage = File(SharedPreferenceHelper.getString(Preferences.image)!);
        List<int> imageBytes = _Proimage!.readAsBytesSync();
        image = base64Encode(imageBytes);
        callApiUpdateImage();
      } else {
        print('No image selected.');
      }
    });
  }

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
}

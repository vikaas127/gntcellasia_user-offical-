import 'dart:convert';
import 'dart:io';
import 'package:doctro/constant/app_string.dart';
import 'package:doctro/constant/color_constant.dart';
import 'package:doctro/constant/prefConstatnt.dart';
import 'package:doctro/constant/preferences.dart';
import 'package:doctro/localization/language_model.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/main.dart';
import 'package:doctro/model/EducationCertifiacate.dart';
import 'package:doctro/model/EducationModel.dart';
import 'package:doctro/model/UpdateProfile.dart';
import 'package:doctro/model/doctor_profile.dart';
import 'package:doctro/retrofit/api_header.dart';
import 'package:doctro/retrofit/base_model.dart';
import 'package:doctro/retrofit/network_api.dart';
import 'package:doctro/retrofit/server_error.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key}) : super(key: key);

  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  Future? languageLoader;

  //profile image
  String? name;

  //Add List Data
  List<EducationModel> educationList = [];
  List<EducationCertificate> certificateList = [];

  String calldegree = '';
  String callcollege = '';
  String callyear = '';
  String callcertificate = '';
  String callcertificateyear = '';
  String valuedegree = '';
  String valuecollege = '';
  String valueyear = '';
  String certificate = '';
  String certificateyear = '';

  //Select Dob
  DateTime? _selectedDate;
  String newDateApiPass = "";
  String? showFormate = '';
  var temp;

  //Doctor Profile Controller
  TextEditingController _Degree = TextEditingController();
  TextEditingController _Experience = TextEditingController();
  TextEditingController _Starttime = TextEditingController();
  TextEditingController _Endtime = TextEditingController();
  TextEditingController _Timeslot = TextEditingController();
  TextEditingController _AppointmentFees = TextEditingController();
  TextEditingController _Name = TextEditingController();
  TextEditingController _Dob = TextEditingController();
  TextEditingController _Desc = TextEditingController();
  TextEditingController _College = TextEditingController();
  TextEditingController _Collegeyear = TextEditingController();
  TextEditingController _Certificate = TextEditingController();
  TextEditingController _Certificateyear = TextEditingController();
  TextEditingController _Besdon = TextEditingController();

  final picker = ImagePicker();

  //Set DropDown Popular Field
  List<String> popular = [];
  String? _selectedpopular;

  //Set DropDown For Male/Female
  List<String> gender = [];
  String? _genderSelect;

  int? isfilled;

  int? treatmentId ;
  int? categoryId;
  int? expertiseId;
  int? hospitalId;

  //Choose Images
  String? image;

  //Set MediaQuery Height / Width
  double? width;
  double? height;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    gender = [
      getTranslated(context, gender_male).toString(),
      getTranslated(context, gender_female).toString(),
    ];

    popular = [
      getTranslated(context, popular_yes).toString(),
      getTranslated(context, popular_no).toString(),
    ];
  }

  @override
  void initState() {
    super.initState();
    languageLoader = doctorprofile();
    name = SharedPreferenceHelper.getString(Preferences.name);
    isfilled = SharedPreferenceHelper.getInt(Preferences.is_filled);
    image = SharedPreferenceHelper.getString(Preferences.image);

  }

  int? value;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: colorWhite,
          leadingWidth: 40,
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: colorBlack,
                size: 30,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Text(
            getTranslated(context, chang_language).toString(),
            style: TextStyle(color: hintColor, fontSize: 18),
          ),
        ),
        body: FutureBuilder(
            future: languageLoader,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                        itemCount: Language.languageList().length,
                        itemBuilder: (context, index) {
                          this.value = 0;
                          this.value =
                              Language.languageList()[index].languageCode == SharedPreferenceHelper.getString(Preferences.current_language_code)
                                  ? index
                                  : null;
                          if (SharedPreferenceHelper.getString(Preferences.current_language_code) == 'N/A') {
                            this.value = 0;
                          }

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: grey.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ], color: colorWhite, borderRadius: BorderRadius.circular(20)),
                              height: height * 0.1,
                              width: width,
                              child: Center(
                                  child: RadioListTile(
                                value: index,
                                controlAffinity: ListTileControlAffinity.trailing,
                                groupValue: this.value,
                                activeColor: colorBlack,
                                onChanged: (dynamic value) async {
                                  Future.delayed(Duration(seconds: 1), () async {
                                    this.value = value;
                                    Locale local = await setLocale(Language.languageList()[index].languageCode);
                                    setState(() {
                                      MyApp.setLocale(context, local);
                                      SharedPreferenceHelper.setString(
                                          Preferences.current_language_code, Language.languageList()[index].languageCode);
                                      SharedPreferenceHelper.setString(Preferences.language_name, Language.languageList()[index].name);
                                      updateprofile();
                                      Navigator.popAndPushNamed(context, "loginhome");
                                    });
                                  });
                                },
                                title: Text(Language.languageList()[index].name),
                              )),
                            ),
                          );
                        }),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }

  Future<BaseModel<UpdateProfile>> updateprofile() async {
    var eeducationList = JsonEncoder().convert(educationList);
    var ccertificateList = JsonEncoder().convert(certificateList);

    //pass date formate
    if (_selectedDate != null) {
      temp = '$_selectedDate';
    } else {
      temp = '$showFormate';
    }

    newDateApiPass = DateUtilforpass().formattedDate(DateTime.parse('$temp'));
    Map<String, dynamic> body = {
      "name": _Name.text,
      "treatment_id": treatmentId,
      "category_id": categoryId,
      "expertise_id": expertiseId,
      "hospital_id": hospitalId,
      "dob": newDateApiPass,
      "gender": _genderSelect,
      "education": eeducationList,
      "certificate": ccertificateList,
      "experience": _Experience.text,
      "appointment_fees": _AppointmentFees.text,
      "start_time": _Starttime.text.toLowerCase(),
      "end_time": _Endtime.text.toLowerCase(),
      "timeslot": _Timeslot.text,
      "desc": _Desc.text,
      "besdon": _Besdon.text,
      "is_popular": _selectedpopular == getTranslated(context, popular_yes).toString() ? 1 : 0,
      "language": SharedPreferenceHelper.getString(Preferences.language_name)
    };
    UpdateProfile response;
    try {
      response = await RestClient(RetroApi().dioData()).updateprofile(body);
      Navigator.pushNamed(context, "loginhome");
      SharedPreferenceHelper.setInt(Preferences.is_filled, 1);
      Fluttertoast.showToast(
        msg: response.msg!,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<Doctorprofile>> doctorprofile() async {
    Doctorprofile response;
    try {
      response = await RestClient(RetroApi().dioData()).doctorprofile();
      setState(() {
        var convertDegree;
        var eduCertificate;
        if (response.data!.education != null) {
          convertDegree = json.decode(response.data!.education!);
        }

        if (response.data!.certificate != null) {
          eduCertificate = json.decode(response.data!.certificate!);
        }

        _Name.text = response.data!.name!;
        showFormate = response.data!.dob;
        newDateApiPass = DateUtil().formattedDate(DateTime.parse('$showFormate'));
        _Dob.text = newDateApiPass;

        _genderSelect = response.data!.gender!;

        if (convertDegree != null) {
          for (int i = 0; i < convertDegree.length; i++) {
            //Split Data Condition
            if (_Degree.text.length == 0) {
              _Degree.text = _Degree.text + convertDegree[i]['degree'];
            } else {
              _Degree.text = _Degree.text + ',' + convertDegree[i]['degree'];
            }
            if (_College.text.length == 0) {
              _College.text = _College.text + convertDegree[i]['college'];
            } else {
              _College.text = _College.text + ',' + convertDegree[i]['college'];
            }
            if (_Collegeyear.text.length == 0) {
              _Collegeyear.text = _Collegeyear.text + convertDegree[i]['year'];
            } else {
              _Collegeyear.text = _Collegeyear.text + ',' + convertDegree[i]['year'];
            }
          }
        }

        if (eduCertificate != null) {
          for (int i = 0; i < eduCertificate.length; i++) {
            if (_Certificate.text.length == 0) {
              _Certificate.text = _Certificate.text + eduCertificate[i]['certificate'];
            } else {
              _Certificate.text = _Certificate.text + ',' + eduCertificate[i]['certificate'];
            }

            if (_Certificateyear.text.length == 0) {
              _Certificateyear.text = _Certificateyear.text + eduCertificate[i]['certificate_year'];
            } else {
              _Certificateyear.text = _Certificateyear.text + ',' + eduCertificate[i]['certificate_year'];
            }
          }
        }

        _Experience.text = response.data!.experience!;
        _AppointmentFees.text = response.data!.appointmentFees!;
        _Timeslot.text = response.data!.timeslot!;
        _Starttime.text = response.data!.startTime!;
        _Endtime.text = response.data!.endTime!;
        _Besdon.text = response.data!.basedOn!;
        _Desc.text = response.data!.desc!;
        _selectedpopular = response.data!.isPopular.toString();

        treatmentId = response.data!.treatmentId!;
        categoryId = response.data!.categoryId;
        expertiseId = response.data!.expertiseId;
        hospitalId = response.data!.hospitalId;

        setState(() {});
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

}

//Pass Date Like this formate  in api
class DateUtilforpass {
  static const DATE_FORMAT = 'yyyy-MM-dd';

  String formattedDate(DateTime dateTime) {
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}

//Show Date like this formate in User
class DateUtil {
  static const DATE_FORMAT = 'dd-MM-yyyy';

  String formattedDate(DateTime dateTime) {
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}

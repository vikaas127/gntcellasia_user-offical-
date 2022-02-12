import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctro/api/Retrofit_Api.dart';
import 'package:doctro/api/apis.dart';
import 'package:doctro/api/network_api.dart';
import 'package:doctro/const/app_string.dart';
import 'package:doctro/const/prefConstatnt.dart';
import 'package:doctro/const/preference.dart';
import 'package:doctro/model/TreatmentWishDoctor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/base_model.dart';
import '../../../api/server_error.dart';
import '../../../const/Palette.dart';
import '../Bookappointment.dart';
import '../doctordetail.dart';
import '../../../localization/localization_constant.dart';

class TreatmentSpecialist extends StatefulWidget {
  int? id;

  TreatmentSpecialist(int? id) {
    this.id = id;
  }

  @override
  _TreatmentSpecialistState createState() => _TreatmentSpecialistState(id);
}

class _TreatmentSpecialistState extends State<TreatmentSpecialist> {
  bool _loadding = false;
  String? _Address = "";
  String? _lat = "";
  String? _lang = "";

  int? id = 0;
  List<Doctorslist> treatmentSpecialistList = [];
  String treatmentName = "";
  String? treatmentSpecialist = "";

  TextEditingController _search = TextEditingController();
  List<Doctorslist> _searchResult = [];

  _TreatmentSpecialistState(int? id) {
    this.id = id;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAddress();
  }

  _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        _Address = (prefs.getString('Address'));
        _lat = (prefs.getString('lat'));
        _lang = (prefs.getString('lang'));
      },
    );
    callApiTratmentWishDoctor();
  }

  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width * 0.3, size.height * 0.12),
        child: SafeArea(
          top: true,
          child: Container(
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: height * 0.01, left: width * 0.03, right: width * 0.03),
                            height: height * 0.03,
                            width: width * 0.05,
                            child: SvgPicture.asset(
                              'assets/icons/location.svg',
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: width * 0.3,
                                margin: EdgeInsets.only(
                                    top: height * 0.01, left: width * 0.03, right: width * 0.03),
                                child: _Address == null || _Address == ""
                                    ? Text(
                                        getTranslated(context, selectAddress).toString(),
                                        // 'Select Address',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: Palette.dark_blue,
                                        ),
                                      )
                                    : Text(
                                        '$_Address',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontWeight: FontWeight.bold,
                                          color: Palette.dark_blue,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: height * 0.01, right: width * 0.02, left: width * 0.02),
                        child: GestureDetector(
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 25,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: width * 0.05, right: width * 0.05, top: height * 0.005),
                  child: Column(
                    children: [
                      Card(
                        color: Palette.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Container(
                          height: height * 0.06,
                          width: width * 1,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          child: TextField(
                            textCapitalization: TextCapitalization.words,
                            controller: _search,
                            onChanged: onSearchTextChanged,
                            decoration: InputDecoration(filled: true,fillColor: Colors.grey,
                              hintText:
                                  getTranslated(context, treatmentSpecialist_searchDoctor_hint)
                                      .toString(),
                              hintStyle:
                                  TextStyle(fontSize: width * 0.04, color: Palette.dark_blue),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                  'assets/icons/SearchIcon.svg',
                                ),
                              ),
                              border: InputBorder.none,
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
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loadding,
        opacity: 0.5,
        progressIndicator: SpinKitFadingCircle(
          color: Palette.blue,
          size: 50.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
         /*     Container(
                width: width,
                color: Palette.dash_line,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  child: Text(
                    '$treatmentSpecialist' +
                        " " +
                        getTranslated(context, treatmentSpecialist_specialistDoctor).toString(),
                    // 'Specialist Doctor',
                    style: TextStyle(
                        fontSize: width * 0.045,
                        color: Palette.dark_blue,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),*/
              Container(
                height: height * 0.8,
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    _searchResult.length > 0 || _search.text.isNotEmpty
                        ? _searchResult.length != 0
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: _searchResult.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                             /*   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1, mainAxisSpacing: 5, childAspectRatio: 0.85),*/
                                itemBuilder: (context, index) {
                                  return _searchResult.length != null
                                      ? Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => Doctordetail(
                                                      _searchResult[index].id,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: width * 0.55,
                                                width: width * 0.92,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [

                                                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Container(
                                                                      margin:
                                                                      EdgeInsets.only(top: width * 0.01),
                                                                      width: width * 0.18,
                                                                      height: width * 0.18,
                                                                      child: ClipRRect(
                                                                        borderRadius: BorderRadius.all(
                                                                          Radius.circular(35),
                                                                        ),
                                                                        child: _searchResult[index].photo!=null ?CachedNetworkImage(
                                                                          alignment: Alignment.center,
                                                                          imageUrl:'${Apis.baseUrl}${  _searchResult[index].photo!}'

                                                                          ,fit: BoxFit.fill,
                                                                          placeholder: (context, url) =>
                                                                              SpinKitFadingCircle(
                                                                                  color: Palette.blue),
                                                                          errorWidget: (context, url,
                                                                              error) =>
                                                                              Image.asset(
                                                                                  "assets/images/no_image.jpg"),
                                                                        ):Image.asset(
                                                                            "assets/images/no_image.jpg"),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment: Alignment.bottomCenter,
                                                                      child:  Padding(
                                                                        padding: const EdgeInsets.only(top: 45.0,left: 50),
                                                                        child: Container(
                                                                          decoration: BoxDecoration(color: Colors.white,
                                                                            border: Border.all(color: Colors.white),
                                                                            borderRadius: BorderRadius.all(
                                                                                Radius.circular(65.0) //                 <--- border radius here
                                                                            ),
                                                                          ),
                                                                          // margin: EdgeInsets.symmetric(vertical: width * 0.005),
                                                                          child:     Padding(
                                                                            padding: const EdgeInsets.all(5.0),
                                                                            child: SvgPicture.asset(
                                                                              'assets/icons/videocal.svg',height: 10,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(height: 5,),
                                                                Container(
                                                                  child: Column(
                                                                    children: [
                                                                      Container(decoration: BoxDecoration(
                                                                        border: Border.all(color: Colors.grey),
                                                                        borderRadius: BorderRadius.all(
                                                                            Radius.circular(5.0) //                 <--- border radius here
                                                                        ),
                                                                      ),
                                                                        margin: EdgeInsets.symmetric(vertical: width * 0.005),
                                                                        child:   Padding(
                                                                          padding: const EdgeInsets.all(4.0),
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(
                                                                                'assets/icons/star.svg',
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(
                                                                                    left: width * 0.028, right: width * 0.028),
                                                                                child: Text(
                                                                                  '4.5',
                                                                                  style: TextStyle(
                                                                                      fontSize: width * 0.035,
                                                                                      fontWeight: FontWeight.bold
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(top: width * 0.02,left: width*0.02),
                                                            child:   Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Center(
                                                                  child: Text(
                                                                    _searchResult[index].name!.toString().toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize: width * 0.04,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Palette.dark_blue),
                                                                  ),
                                                                ),
                                                                _searchResult[index]
                                                                    .treatmentdata !=
                                                                    null
                                                                    ? Text(
                                                                  _searchResult[index]
                                                                      .treatmentdata![0].name
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize: width * 0.035,
                                                                      color: Palette.grey),
                                                                )
                                                                    : Text(
                                                                  getTranslated(context,
                                                                      treatmentSpecialist_notAvailable)
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize: width * 0.035,
                                                                      color: Palette.grey),
                                                                ),
                                                                _searchResult[index]
                                                                    .treatmentdata !=
                                                                    null
                                                                    ? Text(
                                                                  _searchResult[index]
                                                                      .treatmentdata![0].name
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize: width * 0.035,
                                                                      color: Palette.grey),
                                                                )
                                                                    : Text(
                                                                  getTranslated(context,
                                                                      treatmentSpecialist_notAvailable)
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize: width * 0.035,
                                                                      color: Palette.grey),
                                                                ),
                                                                Container(
                                                                  // height: 150,
                                                                  margin: EdgeInsets.only(top: height * 0.02),
                                                                  child: Row(
                                                                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                        child: Column(
                                                                          children: [
                                                                            Container(
                                                                              margin: EdgeInsets.symmetric(vertical: width * 0.005),
                                                                              child: Text(
                                                                                getTranslated(context, doctorDetail_doctorExperience)
                                                                                    .toString(),
                                                                                style: TextStyle(
                                                                                    fontSize: width * 0.035,
                                                                                    color: Palette.dark_blue,
                                                                                    fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              child: Text(
                                                                                '8  ' +
                                                                                    getTranslated(context, doctorDetail_year).toString(),
                                                                                style: TextStyle(
                                                                                  fontSize: width * 0.035,
                                                                                  color: Palette.dark_blue,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                                        child: Column(
                                                                          children: [
                                                                            Container(
                                                                              margin: EdgeInsets.symmetric(vertical: width * 0.005),
                                                                              child: Text(
                                                                                getTranslated(context, doctorDetail_appointmentFees).toString(),
                                                                                style: TextStyle(
                                                                                    fontSize: width * 0.035,
                                                                                    color: Palette.dark_blue,
                                                                                    fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              child: Text(
                                                                                SharedPreferenceHelper.getString(Preferences.currency_symbol).toString() + 'Fees',
                                                                                style: TextStyle(
                                                                                    fontSize: width * 0.035,
                                                                                    color: Palette.dark_blue,
                                                                                    fontWeight: FontWeight.bold
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                        child: Column(
                                                                          children: [
                                                                            Container(
                                                                              margin: EdgeInsets.symmetric(vertical: width * 0.005),
                                                                              child: Text(
                                                                                getTranslated(context, doctorDetail_appoipatient).toString(),
                                                                                style: TextStyle(
                                                                                    fontSize: width * 0.035,
                                                                                    color: Palette.dark_blue,
                                                                                    fontWeight: FontWeight.bold
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              child: Text('Fees',
                                                                                style: TextStyle(
                                                                                  fontSize: width * 0.035,
                                                                                  color: Palette.dark_blue,


                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),


                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(flex: 1,
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => Bookappointment( _searchResult[index].id),
                                                                      ),
                                                                    );
                                                                  });
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Container(
                                                                    //   width: width*0.40,
                                                                    height: 40,
                                                                    decoration: BoxDecoration(
                                                                      gradient: LinearGradient(
                                                                        colors: [
                                                                          Color(0xFFF06B6E),
                                                                          Color(0XFFFA7327),
                                                                        ],
                                                                        begin: Alignment.topLeft,
                                                                        end: Alignment.bottomRight,
                                                                      ),
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.black12,
                                                                          offset: Offset(5, 5),
                                                                          blurRadius: 10,
                                                                        )
                                                                      ],
                                                                    ),
                                                                    child: Center(
                                                                      child:  Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Text(
                                                                          'Online Consult',
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      /*  Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                       *//*   Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                                            child: Image.asset('assets/images/videoo.png',width: 17,height:17),
                                                                          ),*//*
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Text(
                                                                              'Online Consult',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),*/
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            Expanded(flex: 1,
                                                              child: Column(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) => Bookappointment( _searchResult[index].id),
                                                                          ),
                                                                        );
                                                                      });
                                                                    },
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Container(
                                                                        // width: width*0.40,
                                                                        height: 40,
                                                                        decoration: BoxDecoration(
                                                                          gradient: LinearGradient(
                                                                            colors: [
                                                                              Color(0xFF2C9085),
                                                                              Color(0xFF38AF8D),
                                                                            ],
                                                                            begin: Alignment.topLeft,
                                                                            end: Alignment.bottomRight,
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.black12,
                                                                              offset: Offset(5, 5),
                                                                              blurRadius: 10,
                                                                            )
                                                                          ],
                                                                        ),
                                                                        child: Center(
                                                                          child:    Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Text(
                                                                              'Book Appointment',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          /*  Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                              //   assets/images/lock.png
                                                                             *//* Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                                child: Image.asset('assets/images/lock.png',width: 17,height:17),
                                                                              ),*//*
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text(
                                                                                  'Book Appointment',
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),*/
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
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Center(
                                          child: Text(
                                            getTranslated(context,
                                                    treatmentSpecialist_treatmentNotAvailable)
                                                .toString(),
                                          ),
                                        );
                                },
                              )
                            : Container(
                                alignment: AlignmentDirectional.center,
                                margin: EdgeInsets.only(top: 250),
                                child: Text(
                                  getTranslated(context, treatmentSpecialist_doctorNotFound)
                                      .toString(),
                                  // 'Doctor Not Found.',
                                  style: TextStyle(
                                      fontSize: width * 0.04,
                                      color: Palette.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                        : treatmentSpecialistList.length != 0
                            ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: treatmentSpecialistList.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                               /* gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1, mainAxisSpacing: 5, childAspectRatio: 0.85),*/
                                itemBuilder: (context, index) {
                                  return treatmentSpecialistList.length != null
                                      ? Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => Doctordetail(
                                                      treatmentSpecialistList[index].id,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: width * 0.55,
                                                width: width * 0.92,
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [

                                                      Row(crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                            child: Column(
crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Stack(
                                                                  children: [
                                                                    Container(
                                                                      margin:
                                                                      EdgeInsets.only(top: width * 0.01),
                                                                      width: width * 0.18,
                                                                      height: width * 0.18,
                                                                      child: ClipRRect(
                                                                        borderRadius: BorderRadius.all(
                                                                          Radius.circular(35),
                                                                        ),
                                                                        child: treatmentSpecialistList[index].photo!=null ?CachedNetworkImage(
                                                                          alignment: Alignment.center,
                                                                          imageUrl:'${Apis.baseUrl}${  treatmentSpecialistList[index].photo!}'

                                                                          ,fit: BoxFit.fill,
                                                                          placeholder: (context, url) =>
                                                                              SpinKitFadingCircle(
                                                                                  color: Palette.blue),
                                                                          errorWidget: (context, url,
                                                                              error) =>
                                                                              Image.asset(
                                                                                  "assets/images/no_image.jpg"),
                                                                        ):Image.asset(
                                                                            "assets/images/no_image.jpg"),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment: Alignment.bottomCenter,
                                                                      child:  Padding(
                                                                        padding: const EdgeInsets.only(top: 45.0,left: 50),
                                                                        child: Container(
                                                                          decoration: BoxDecoration(color: Colors.white,
                                                                            border: Border.all(color: Colors.white),
                                                                            borderRadius: BorderRadius.all(
                                                                                Radius.circular(65.0) //                 <--- border radius here
                                                                            ),
                                                                          ),
                                                                         // margin: EdgeInsets.symmetric(vertical: width * 0.005),
                                                                          child:     Padding(
                                                                            padding: const EdgeInsets.all(5.0),
                                                                            child: SvgPicture.asset(
                                                                              'assets/icons/videocal.svg',height: 10,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(height: 5,),
                                                                Container(
                                                                  child: Column(
                                                                    children: [
                                                                      Container(decoration: BoxDecoration(
                                                                          border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.all(
                                  Radius.circular(5.0) //                 <--- border radius here
                                  ),
                                                                      ),
                                                                        margin: EdgeInsets.symmetric(vertical: width * 0.005),
                                                                        child:   Padding(
                                                                          padding: const EdgeInsets.all(4.0),
                                                                          child: Row(
                                                                            children: [
                                                                              SvgPicture.asset(
                                                                                'assets/icons/star.svg',
                                                                              ),
                                                                              Padding(
                                                                                padding: EdgeInsets.only(
                                                                                    left: width * 0.028, right: width * 0.028),
                                                                                child: Text(
                                                                                  '4.5',
                                                                                  style: TextStyle(
                                                                                      fontSize: width * 0.035,
                                                                                      fontWeight: FontWeight.bold
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets.only(top: width * 0.02,left: width*0.02),
                                                            child:   Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Center(
                                                                  child: Text(
                                                                    treatmentSpecialistList[index].name!.toString().toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize: width * 0.04,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Palette.dark_blue),
                                                                  ),
                                                                ),
                                                                treatmentSpecialistList[index]
                                                                    .treatmentdata !=
                                                                    null
                                                                    ? Text(
                                                                  treatmentSpecialistList[index]
                                                                      .treatmentdata![0].name
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize: width * 0.035,
                                                                      color: Palette.grey),
                                                                )
                                                                    : Text(
                                                                  getTranslated(context,
                                                                      treatmentSpecialist_notAvailable)
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize: width * 0.035,
                                                                      color: Palette.grey),
                                                                ),
                                                                treatmentSpecialistList[index]
                                                                    .treatmentdata !=
                                                                    null
                                                                    ? Text(
                                                                  treatmentSpecialistList[index]
                                                                      .treatmentdata![0].name
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize: width * 0.035,
                                                                      color: Palette.grey),
                                                                )
                                                                    : Text(
                                                                  getTranslated(context,
                                                                      treatmentSpecialist_notAvailable)
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize: width * 0.035,
                                                                      color: Palette.grey),
                                                                ),
                                                                Container(
                                                                  // height: 150,
                                                                  margin: EdgeInsets.only(top: height * 0.02),
                                                                  child: Row(
                                                                   // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                        child: Column(
                                                                          children: [
                                                                            Container(
                                                                              margin: EdgeInsets.symmetric(vertical: width * 0.005),
                                                                              child: Text(
                                                                                getTranslated(context, doctorDetail_doctorExperience)
                                                                                    .toString(),
                                                                                style: TextStyle(
                                                                                    fontSize: width * 0.035,
                                                                                    color: Palette.dark_blue,
                                                                                    fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              child: Text(
                                                                                '8  ' +
                                                                                    getTranslated(context, doctorDetail_year).toString(),
                                                                                style: TextStyle(
                                                                                  fontSize: width * 0.035,
                                                                                  color: Palette.dark_blue,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                                        child: Column(
                                                                          children: [
                                                                            Container(
                                                                              margin: EdgeInsets.symmetric(vertical: width * 0.005),
                                                                              child: Text(
                                                                                getTranslated(context, doctorDetail_appointmentFees).toString(),
                                                                                style: TextStyle(
                                                                                    fontSize: width * 0.035,
                                                                                    color: Palette.dark_blue,
                                                                                    fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              child: Text(
                                                                                SharedPreferenceHelper.getString(Preferences.currency_symbol).toString() + 'Fees',
                                                                                style: TextStyle(
                                                                                    fontSize: width * 0.035,
                                                                                    color: Palette.dark_blue,
                                                                                    fontWeight: FontWeight.bold
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                        child: Column(
                                                                          children: [
                                                                            Container(
                                                                              margin: EdgeInsets.symmetric(vertical: width * 0.005),
                                                                              child: Text(
                                                                                getTranslated(context, doctorDetail_appoipatient).toString(),
                                                                                style: TextStyle(
                                                                                    fontSize: width * 0.035,
                                                                                    color: Palette.dark_blue,
                                                                                    fontWeight: FontWeight.bold
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Container(
                                                                              child: Text('Fees',
                                                                                style: TextStyle(
                                                                                  fontSize: width * 0.035,
                                                                                  color: Palette.dark_blue,


                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),


                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Expanded(flex: 1,
                                                              child: GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => Bookappointment( treatmentSpecialistList[index].id),
                                                                      ),
                                                                    );
                                                                  });
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets.all(8.0),
                                                                  child: Container(
                                                                    //   width: width*0.40,
                                                                    height: 40,
                                                                    decoration: BoxDecoration(
                                                                      gradient: LinearGradient(
                                                                        colors: [
                                                                          Color(0xFFF06B6E),
                                                                          Color(0XFFFA7327),
                                                                        ],
                                                                        begin: Alignment.topLeft,
                                                                        end: Alignment.bottomRight,
                                                                      ),
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.black12,
                                                                          offset: Offset(5, 5),
                                                                          blurRadius: 10,
                                                                        )
                                                                      ],
                                                                    ),
                                                                    child: Center(
                                                                      child:  Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Text(
                                                                          'Online Consult',
                                                                          style: TextStyle(
                                                                            color: Colors.white,
                                                                            fontSize: 13,
                                                                            fontWeight: FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    /*  Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                        children: [
                                                                       *//*   Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                                            child: Image.asset('assets/images/videoo.png',width: 17,height:17),
                                                                          ),*//*
                                                                          Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Text(
                                                                              'Online Consult',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 13,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),*/
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),

                                                            Expanded(flex: 1,
                                                              child: Column(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(() {
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder: (context) => Bookappointment( treatmentSpecialistList[index].id),
                                                                          ),
                                                                        );
                                                                      });
                                                                    },
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Container(
                                                                        // width: width*0.40,
                                                                        height: 40,
                                                                        decoration: BoxDecoration(
                                                                          gradient: LinearGradient(
                                                                            colors: [
                                                                              Color(0xFF2C9085),
                                                                              Color(0xFF38AF8D),
                                                                            ],
                                                                            begin: Alignment.topLeft,
                                                                            end: Alignment.bottomRight,
                                                                          ),
                                                                          borderRadius: BorderRadius.circular(10),
                                                                          boxShadow: [
                                                                            BoxShadow(
                                                                              color: Colors.black12,
                                                                              offset: Offset(5, 5),
                                                                              blurRadius: 10,
                                                                            )
                                                                          ],
                                                                        ),
                                                                        child: Center(
                                                                          child:    Padding(
                                                                            padding: const EdgeInsets.all(8.0),
                                                                            child: Text(
                                                                              'Book Appointment',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 12,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        /*  Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                                            children: [
                                                                              //   assets/images/lock.png
                                                                             *//* Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                                child: Image.asset('assets/images/lock.png',width: 17,height:17),
                                                                              ),*//*
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(8.0),
                                                                                child: Text(
                                                                                  'Book Appointment',
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 12,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),*/
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
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Center(
                                          child: Text(
                                            getTranslated(context,
                                                    treatmentSpecialist_treatmentNotAvailable)
                                                .toString(),
                                          ),
                                        );
                                },
                              )
                            : Container(
                                alignment: AlignmentDirectional.center,
                                margin: EdgeInsets.only(top: 250),
                                child: Text(
                                  getTranslated(context, treatmentSpecialist_doctorNotFound)
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: width * 0.04,
                                      color: Palette.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<BaseModel<TreatmentWishDoctor>> callApiTratmentWishDoctor() async {
    TreatmentWishDoctor response;
    Map<String, dynamic> body = {
      "lat": _lat,
      "lang": _lang,
    };
    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api2().Dio_Data2()).treatmentWishDoctorRequest(id, body);
      setState(() {
        if (response.status == 200) {
          setState(() {
            _loadding = false;
            treatmentSpecialistList.addAll(response.doctorslist!);
            for (int i = 0; i < treatmentSpecialistList.length; i++) {
              treatmentSpecialist = treatmentSpecialistList[i].treatmentdata![0].name;
            }
          });
        }
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    treatmentSpecialistList.forEach((appointmentData) {
      if (appointmentData.name!.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(appointmentData);
    });

    setState(() {});
  }
}

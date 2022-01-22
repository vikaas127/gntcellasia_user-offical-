import 'dart:ffi';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctro/api/Retrofit_Api.dart';
import 'package:doctro/api/base_model.dart';
import 'package:doctro/api/network_api.dart';
import 'package:doctro/api/server_error.dart';
import 'package:doctro/const/Palette.dart';
import 'package:doctro/const/app_string.dart';
import 'package:doctro/const/prefConstatnt.dart';
import 'package:doctro/const/preference.dart';
import 'package:doctro/doctordetail.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/model/FavoriteDoctor.dart';
import 'package:doctro/model/doctors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Specialist extends StatefulWidget {
  @override
  _SpecialistState createState() => _SpecialistState();
}

class _SpecialistState extends State<Specialist> {
  bool _loadding = false;
  String? _Address = "";
  String? _lat = "";
  String? _lang = "";
  List<doctor> doctorlist = [];
  List<bool> favoriteDoctor = [];
  List<bool> searchFavoriteDoctor = [];
  int? doctorID = 0;
  TextEditingController _search = TextEditingController();
  List<doctor> _searchResult = [];

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
    callApi();
  }
  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, 110),
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
                            margin: EdgeInsets.only(top: height * 0.01, left: width * 0.03,right: width * 0.03),
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
                                margin: EdgeInsets.only(top: height * 0.01, left: width * 0.03,right: width * 0.03),
                                child: _Address == null || _Address == ""
                                    ? Text(
                                  getTranslated(context, selectAddress).toString(),
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
                        margin: EdgeInsets.only(top: height * 0.01, right: width * 0.02,left: width * 0.02),
                        child: GestureDetector(
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 25,
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, 'Home');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: width * 0.05, right: width * 0.05, top: 10),
                  child: Container(
                    width: width * 1,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      onChanged: onSearchTextChanged,
                      decoration: InputDecoration(filled:true,fillColor: Colors.grey[400],
                        hintText: getTranslated(context, specialist_searchDoctor_hint).toString(),
                        hintStyle: TextStyle(
                          fontSize: width * 0.04,
                          color: Palette.dark_blue,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            'assets/icons/SearchIcon.svg',
                            height: 15,
                            width: 15,
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
        ),
      ),
      body: RefreshIndicator(
        onRefresh: callApi,
        child: ModalProgressHUD(
          child: _searchResult.length > 0 || _search.text.isNotEmpty
              ? _searchResult.length != 0
                  ? Container(
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _searchResult.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                           /* gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1, mainAxisSpacing: 5, childAspectRatio: 0.9),*/
                            itemBuilder: (context, index) {
                              favoriteDoctor.clear();
                              for (int i = 0; i < _searchResult.length; i++) {
                                _searchResult[i].isFaviroute == false
                                    ? favoriteDoctor.add(false)
                                    : favoriteDoctor.add(true);
                              }
                              return Column(
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
                                      width: width * 0.45,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          margin: EdgeInsets.all(width * 0.02),
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: width * 0.4,
                                                    height: width * 0.35,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                      child: CachedNetworkImage(
                                                        alignment: Alignment.center,
                                                        imageUrl: _searchResult[index].fullImage!,
                                                        fit: BoxFit.fitHeight,
                                                        placeholder: (context, url) =>
                                                            SpinKitFadingCircle(
                                                                color: Palette.blue),
                                                        errorWidget: (context, url, error) =>
                                                            Image.asset(
                                                                "assets/images/no_image.jpg"),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    right: 0,
                                                    child: Container(
                                                      child: SharedPreferenceHelper.getBoolean(
                                                                  Preferences.is_logged_in) ==
                                                              true
                                                          ? IconButton(
                                                              onPressed: () {
                                                                setState(
                                                                  () {
                                                                    favoriteDoctor[index] == false
                                                                        ? favoriteDoctor[index] =
                                                                            true
                                                                        : favoriteDoctor[index] =
                                                                            false;
                                                                    doctorID = doctorlist[index].id;
                                                                    CallApiFavoriteDoctor();
                                                                  },
                                                                );
                                                              },
                                                              icon: Icon(
                                                                Icons.favorite_outlined,
                                                                size: 25,
                                                                color:
                                                                    favoriteDoctor[index] == false
                                                                        ? Palette.white
                                                                        : Palette.red,
                                                              ),
                                                            )
                                                          : IconButton(
                                                              onPressed: () {
                                                                setState(
                                                                  () {
                                                                    Fluttertoast.showToast(
                                                                      msg: getTranslated(context, specialist_pleaseLogin_toast).toString(),
                                                                      toastLength:
                                                                          Toast.LENGTH_SHORT,
                                                                      gravity: ToastGravity.BOTTOM,
                                                                      backgroundColor:
                                                                      Palette.blue,
                                                                      textColor: Palette.white,
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              icon: Icon(
                                                                Icons.favorite_outlined,
                                                                size: 25,
                                                                color:
                                                                    favoriteDoctor[index] == false
                                                                        ? Palette.white
                                                                        : Palette.red,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: width * 0.02),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      _searchResult[index].name!,
                                                      style: TextStyle(
                                                          fontSize: width * 0.04,
                                                          color: Palette.dark_blue),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                child: _searchResult[index].treatment != null
                                                    ? Text(
                                                        _searchResult[index]
                                                            .treatment!
                                                            .name
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: width * 0.035,
                                                            color: Palette.grey),
                                                      )
                                                    : Text(
                                                  getTranslated(context, specialist_notAvailable).toString(),
                                                        style: TextStyle(
                                                            fontSize: width * 0.035,
                                                            color: Palette.grey),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          )
                        ],
                      ),
                    )
                  : Container(
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        getTranslated(context, specialist_doctorNotFound).toString(),
                        // 'Doctor Not Found.',
                        style: TextStyle(
                            fontSize: width * 0.04,
                            color: Palette.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    )
              : doctorlist.length != 0
                  ? Container(
                      child: ListView(
                      scrollDirection: Axis.vertical,
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: doctorlist.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                        /*  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1, mainAxisSpacing: 5, childAspectRatio: 0.9),*/
                          itemBuilder: (context, index) {
                            favoriteDoctor.clear();
                            for (int i = 0; i < doctorlist.length; i++) {
                              doctorlist[i].isFaviroute == false
                                  ? favoriteDoctor.add(false)
                                  : favoriteDoctor.add(true);
                            }
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Doctordetail(
                                      doctorlist[index].id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: width*0.80 ,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(

                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Container(
                                                      width: width * 0.20,
                                                      height: width * 0.20,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius.all(Radius.circular(10)),
                                                        child: CachedNetworkImage(
                                                          alignment: Alignment.center,
                                                          imageUrl: doctorlist[index].fullImage!,
                                                          fit: BoxFit.fitWidth,
                                                          imageBuilder: (context, imageProvider) => CircleAvatar(
                                                            radius:38 ,
                                                            backgroundColor: Palette.blue,
                                                            child: CircleAvatar(
                                                              radius: 38,
                                                              backgroundImage: imageProvider,
                                                            ),
                                                          ),
                                                          placeholder: (context, url) =>CircleAvatar(
                                                            radius:38 ,
                                                            backgroundColor: Palette.blue,
                                                            child: CircleAvatar(
                                                              radius: 38,
                                                              //   backgroundImage: imageProvider,
                                                            ),
                                                          ),
                                                          /*  SpinKitFadingCircle(
                                         color: Palette.blue),*/
                                                          errorWidget: (context, url, error) =>
                                                              Image.asset("assets/images/no_image.jpg"),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 28.0,vertical: 4),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.only(top: width * 0.02),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                doctorlist[index].name!,
                                                                style: TextStyle(
                                                                    fontSize: width * 0.06,
                                                                    color: Palette.dark_blue),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          child: doctorlist[index].treatment != null
                                                              ? Text(
                                                            doctorlist[index].treatment!.name.toString(),
                                                            style: TextStyle(
                                                                fontSize: width * 0.035,
                                                                color: Palette.grey),
                                                          )
                                                              : Text(
                                                            getTranslated(context, specialist_notAvailable).toString(),
                                                            style: TextStyle(
                                                                fontSize: width * 0.035,
                                                                color: Palette.grey),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: doctorlist[index].treatment != null
                                                              ? Text(
                                                            doctorlist[index].treatment!.name.toString(),
                                                            style: TextStyle(
                                                                fontSize: width * 0.035,
                                                                color: Palette.grey),
                                                          )
                                                              : Text(
                                                            getTranslated(context, specialist_notAvailable).toString(),
                                                            style: TextStyle(
                                                                fontSize: width * 0.035,
                                                                color: Palette.grey),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: Container(
                                                  child: SharedPreferenceHelper.getBoolean(
                                                      Preferences.is_logged_in) ==
                                                      true
                                                      ? IconButton(
                                                    onPressed: () {
                                                      setState(
                                                            () {
                                                          favoriteDoctor[index] == false
                                                              ? favoriteDoctor[index] = true
                                                              : favoriteDoctor[index] =
                                                          false;
                                                          doctorID = doctorlist[index].id;
                                                          CallApiFavoriteDoctor();
                                                        },
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.favorite_outlined,
                                                      size: 25,
                                                      color: favoriteDoctor[index] == false
                                                          ? Palette.white
                                                          : Palette.red,
                                                    ),
                                                  )
                                                      : IconButton(
                                                    onPressed: () {
                                                      setState(
                                                            () {
                                                          Fluttertoast.showToast(
                                                            msg: getTranslated(context, specialist_pleaseLogin_toast).toString(),
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.BOTTOM,
                                                            backgroundColor:
                                                            Palette.blue,
                                                            textColor: Palette.white,
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons.favorite_outlined,
                                                      size: 25,
                                                      color: favoriteDoctor[index] == false
                                                          ? Palette.white
                                                          : Palette.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          Container(
                                                // height: 150,
                                                margin: EdgeInsets.only(top: height * 0.02),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [

                                                    Column(
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
                                                           // '$experience  ' +
                                                                getTranslated(context, doctorDetail_year).toString(),
                                                            style: TextStyle(
                                                              fontSize: width * 0.035,
                                                              color: Palette.dark_blue,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
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
                                                    Column(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets.symmetric(vertical: width * 0.005),
                                                          child: Text(
                                                            getTranslated(context, doctorDetail_appoipatient).toString(),
                                                            style: TextStyle(
                                                              fontSize: width * 0.035,
                                                              color: Palette.grey,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            'Fees',
                                                            style: TextStyle(
                                                                fontSize: width * 0.035,
                                                                color: Palette.dark_blue,
                                                                fontWeight: FontWeight.bold

                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets.symmetric(vertical: width * 0.005),
                                                            child: Text(
                                                              getTranslated(context, doctorDetail_doctorRates).toString(),
                                                              style: TextStyle(
                                                                fontSize: width * 0.035,
                                                                color: Palette.grey,
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/icons/hart.svg',
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: width * 0.028, right: width * 0.028),
                                                                child: Text(
                                                                  'rate',
                                                                  style: TextStyle(
                                                                      fontSize: width * 0.035,
                                                                      fontWeight: FontWeight.bold
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Expanded(flex: 1,
                                                  child: GestureDetector(
                                                    onTap: () {},
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        //   width: width*0.40,
                                                        height: 35,
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
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                                                child: Image.asset('assets/images/videoo.png',width: 17,height:17),
                                                              ),
                                                              Text(
                                                                'Online Consult',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 13,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Expanded(flex: 1,
                                                  child: GestureDetector(
                                                    onTap: () {},
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Container(
                                                        // width: width*0.40,
                                                        height: 35,
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
                                                          child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              //   assets/images/lock.png
                                                              Padding(
                                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                child: Image.asset('assets/images/lock.png',width: 17,height:17),
                                                              ),
                                                              Text(
                                                                'Book Appointment',
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 13,
                                                                  fontWeight: FontWeight.w500,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                                            child: Row(children: [
                                              Expanded(flex:1,child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text('08:30 ,Today'),
                                                ],
                                              ) ),
                                              Expanded(flex:1,child:Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Text('08:30 ,Tomorrow'),
                                                ],
                                              ) ),
                                            ],),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ))
                  : Container(
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        getTranslated(context, specialist_doctorNotFound).toString(),
                        style: TextStyle(
                            fontSize: width * 0.04,
                            color: Palette.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
          inAsyncCall: _loadding,
          opacity: 0.5,
          progressIndicator: SpinKitFadingCircle(
            color: Palette.blue,
            size: 50.0,
          ),
        ),
      ),
    );
  }
  Future<BaseModel<Doctors>> callApi() async {
    Doctors response;
    Map<String, dynamic> body = {
      "lat": _lat,
      "lang": _lang,
    };
    setState(() {
      _loadding = true;
    });
    try {
      SharedPreferenceHelper.getBoolean(Preferences.is_logged_in) == true ?
      response = await RestClient(Retro_Api().Dio_Data()).doctorlist(body) :
      response = await RestClient(Retro_Api2().Dio_Data2()).doctorlist(body) ;
      setState(() {
        if (response.success == true) {
          setState(() {
            doctorlist.clear();
            _loadding = false;
            doctorlist.addAll(response.data!);
          });
        }
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
  Future<BaseModel<FavoriteDoctor>> CallApiFavoriteDoctor() async {
    FavoriteDoctor response;
    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api().Dio_Data()).favoriteDoctorRequest(doctorID);
      setState(() {
        if (response.success == true) {
          setState(
                () {
              _loadding = false;
              Fluttertoast.showToast(
                msg: '${response.msg}',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Palette.blue,
                textColor: Palette.white,
              );
              doctorlist.clear();
              callApi();
            },
          );
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

    doctorlist.forEach((appointmentData) {
      if (appointmentData.name!.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(appointmentData);
    });

    setState(() {});
  }
}

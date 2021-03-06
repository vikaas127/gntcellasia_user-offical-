import 'dart:async';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:doctro/view/Companypolices/AboutUs.dart';


import 'package:doctro/api/Retrofit_Api.dart';
import 'package:doctro/api/base_model.dart';
import 'package:doctro/api/network_api.dart';
import 'package:doctro/api/server_error.dart';
import 'package:doctro/const/Palette.dart';
import 'package:doctro/const/app_string.dart';
import 'package:doctro/const/prefConstatnt.dart';
import 'package:doctro/const/preference.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/model/Appointments.dart';
import 'package:doctro/model/Banner.dart';
import 'package:doctro/model/DetailSetting.dart';
import 'package:doctro/model/DisplayOffer.dart';
import 'package:doctro/model/FavoriteDoctor.dart';
import 'package:doctro/model/Treatments.dart';
import 'package:doctro/model/UserDetail.dart';
import 'package:doctro/model/doctors.dart';
import 'package:doctro/view/Consult/Consult.dart';
import 'package:doctro/view/Home/home.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Auth/profile.dart';
class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}
class _DashBoardState extends State<DashBoard> {
  String? _Address = "";
  String? _lat = "";
  String? _lang = "";
  String? name = "";
  String? email = "";
  String? phone_no = "";
  String? image = "";
  String user_phoneno = "";
  String user_email = "";
  String user_name = "";
  bool _loadding = false;
  List<Doctorslist> doctorlist = [];
  List<Treatmentdata> treatmentList = [];
  List<Add> banner = [];
  int treatmentId = 0;

  List<bool> favoriteDoctor = [];
  int? doctorID = 0;

  List<offer> offerList = [];

  List<UpcomingAppointment> upcomingAppointment = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int _current = 0;
  List<String?> imgList = [];
  // Search //
  TextEditingController _search = TextEditingController();
  List<Doctorslist> _searchResult = [];
  late LocationData _locationData;
  Location location = new Location();
  PageController _pageController = PageController();
  int _pageIndex = 0;
  late List<Widget> _screens ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _screens = [
      Home(),
      //  InboxScreen(isBackButtonExist: false),
      // OrderScreen(isBacButtonExist: false),
      Consult(),
      profile(),
      // NotificationScreen(isBacButtonExist: false,),

    ];
    getLocation();
    appAllDetail();
    getLiveLocation();
    SharedPreferenceHelper.getBoolean(Preferences.is_logged_in) == true ? Callapiforuserdetail() : "";
    callApiBanner();
    SharedPreferenceHelper.getBoolean(Preferences.is_logged_in) == true
        ? Timer.periodic(Duration(minutes: 10), (Timer t) => callApiAppointment())
        : "";
  }
  Future<void> getLocation() async {
    await Permission.storage.request();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? checkLat = prefs.getString('lat');
    if (checkLat != "" && checkLat != null) {
      _getAddress();
    } else {
      _locationData = await location.getLocation();
      setState(
            () {
          prefs.setString('lat', _locationData.latitude.toString());
          prefs.setString('lang', _locationData.longitude.toString());
          print("${_locationData.latitude.toString()}  ${_locationData.longitude.toString()}");
        },
      );
      _getAddress();
    }
  }
  getLiveLocation() async {
    _locationData = await location.getLocation();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('latLive', _locationData.latitude.toString());
    prefs.setString('langLive', _locationData.longitude.toString());
    print("Live==   ${_locationData.latitude.toString()}  ${_locationData.longitude.toString()}");
  }
  _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
          () {
        _Address = prefs.getString('Address');
        _lat = prefs.getString('lat');
        _lang = prefs.getString('lang');
       // CallApi_DoctorList();
        callApiTeatment();
        callApIDisplayOffer();
      },
    );
  }
  _passDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_phoneno = '$phone_no';
      user_email = '$email';
      user_name = '$name';
    });
    prefs.setString('phone_no', user_phoneno);
    prefs.setString('email', user_email);
    prefs.setString('name', user_name);
  }
  _passIsWhere() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('isWhere', "Home");
  }
  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: getTranslated(context, exit_app).toString(),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }
  @override
  Widget build(BuildContext context) {
    double width;
    double height;

    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: onWillPop,
      child: ModalProgressHUD(
        inAsyncCall: _loadding,
        opacity: 0.5,
        progressIndicator: SpinKitFadingCircle(
          color: Palette.white,
          size: 0.0,
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Color(0xff677B8A),
             // currentIndex: _index,
              selectedIconTheme: IconThemeData(color:Color(0xff2C9085)),
              selectedLabelStyle: TextStyle(color:Color(0xff2C9085)),
              currentIndex:_pageIndex ,
              onTap: (int index) {
                setState(() {
                  _pageController.jumpToPage(index);
                  _pageIndex = index;
                });

              },
              items: <BottomNavigationBarItem>[
               /* BottomNavigationBarItem(
                  icon: Icon(Icons.call),
                  label: 'Calls',
                ),*/

                BottomNavigationBarItem(

                  icon:   ImageIcon( AssetImage("assets/images/home_icon.png")),
                  label: 'Home',
                ),

                BottomNavigationBarItem(
                  icon: ImageIcon( AssetImage("assets/images/consult_icon.png")),
                  label: 'Consultation',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon( AssetImage("assets/images/account_icon.png")),
                  label: 'Account',
                ),
              ],
            ),
            key: _scaffoldKey,

            // Drawer //

            body: PageView.builder(
             controller: _pageController,
             itemCount: _screens.length,
             physics: NeverScrollableScrollPhysics(),
             itemBuilder: (context, index){
               return _screens[index];
             },
           ),
            /*GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      // Upcoming Appointment //
                      upcomingAppointment.length != 0
                          ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                                alignment: AlignmentDirectional.topStart,
                                child: Column(
                                  children: [
                                    Text(
                                      getTranslated(context, home_upcomingAppointment).toString(),
                                      style: TextStyle(fontSize: width * 0.04, color: Palette.dark_blue),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, 'Appointment');
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                                  alignment: AlignmentDirectional.topStart,
                                  child: Column(
                                    children: [
                                      Text(
                                        getTranslated(context, home_viewAll).toString(),
                                        style: TextStyle(fontSize: width * 0.035, color: Palette.primary),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 220,
                            width: width * 1,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Container(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5 <= upcomingAppointment.length ? 5 : upcomingAppointment.length,
                                    itemBuilder: (context, index) {
                                      var statusColor = Palette.green.withOpacity(0.5);
                                      if (upcomingAppointment[index].appointmentStatus!.toUpperCase() ==
                                          getTranslated(context, home_pending).toString()) {
                                        statusColor = Palette.dark_blue;
                                      } else if (upcomingAppointment[index].appointmentStatus!.toUpperCase() ==
                                          getTranslated(context, home_cancel).toString()) {
                                        statusColor = Palette.red;
                                      } else if (upcomingAppointment[index].appointmentStatus!.toUpperCase() ==
                                          getTranslated(context, home_approve).toString()) {
                                        statusColor = Palette.green.withOpacity(0.5);
                                      }
                                      return Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            width: width * 0.95,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              elevation: 10,
                                              color: index % 2 == 0 ? Palette.light_blue : Palette.white,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(top: 10, left: 12, right: 12),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                getTranslated(context, home_bookingId).toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: index % 2 == 0 ? Palette.white : Palette.primary,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                            Text(
                                                              upcomingAppointment[index].appointmentId!,
                                                              style: TextStyle(
                                                                  fontSize: 14, color: Palette.black, fontWeight: FontWeight.bold),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            upcomingAppointment[index].appointmentStatus!.toUpperCase(),
                                                            style: TextStyle(
                                                                fontSize: 14, color: statusColor, fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      top: 10,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: width * 0.15,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration: new BoxDecoration(shape: BoxShape.circle, boxShadow: [
                                                                  new BoxShadow(
                                                                    color: Palette.primary,
                                                                    blurRadius: 1.0,
                                                                  ),
                                                                ]),
                                                                child: CachedNetworkImage(
                                                                  alignment: Alignment.center,
                                                                  imageUrl: upcomingAppointment[index].doctor!.fullImage!,
                                                                  imageBuilder: (context, imageProvider) => CircleAvatar(
                                                                    radius: 50,
                                                                    backgroundColor: Palette.white,
                                                                    child: CircleAvatar(
                                                                      radius: 18,
                                                                      backgroundImage: imageProvider,
                                                                    ),
                                                                  ),
                                                                  placeholder: (context, url) =>
                                                                      SpinKitFadingCircle(color: Palette.primary),
                                                                  errorWidget: (context, url, error) =>
                                                                      Image.asset("assets/images/no_image.jpg"),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: width * 0.75,
                                                          // color: Colors.red,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                alignment: AlignmentDirectional.topStart,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      upcomingAppointment[index].doctor!.name!,
                                                                      style: TextStyle(
                                                                        fontSize: 16,
                                                                        color: index % 2 == 0 ? Palette.white : Palette.dark_blue,
                                                                      ),
                                                                      overflow: TextOverflow.ellipsis,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: AlignmentDirectional.topStart,
                                                                margin: EdgeInsets.only(top: 3),
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      upcomingAppointment[index].doctor!.treatment!.name!,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: index % 2 == 0 ? Palette.white : Palette.grey),
                                                                      overflow: TextOverflow.ellipsis,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                alignment: AlignmentDirectional.topStart,
                                                                margin: EdgeInsets.only(top: 3),
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      upcomingAppointment[index].doctor!.hospital!.address!,
                                                                      style: TextStyle(
                                                                          fontSize: 12,
                                                                          color: index % 2 == 0 ? Palette.white : Palette.grey),
                                                                      overflow: TextOverflow.ellipsis,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(top: 10),
                                                    child: Column(
                                                      children: [
                                                        Divider(
                                                          height: 2,
                                                          color: index % 2 == 0 ? Palette.white : Palette.dark_grey,
                                                          thickness: width * 0.001,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                getTranslated(context, home_dateTime).toString(),
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: index % 2 == 0 ? Palette.white : Palette.grey,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                getTranslated(context, home_patientName).toString(),
                                                                style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: index == 0
                                                                      ? Palette.white
                                                                      : index % 2 == 0
                                                                      ? Palette.white
                                                                      : Palette.grey,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                upcomingAppointment[index].date! +
                                                                    '  ' +
                                                                    upcomingAppointment[index].time!,
                                                                style: TextStyle(fontSize: 12, color: Palette.dark_blue),
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Text(
                                                                upcomingAppointment[index].patientName!,
                                                                style: TextStyle(fontSize: 12, color: Palette.dark_blue),
                                                                overflow: TextOverflow.ellipsis,
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
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                          : SizedBox(),

                      // Doctor Specialist List //
                      Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
                                  alignment: AlignmentDirectional.topStart,
                                  child: Row(
                                    children: [
                                      Text(
                                        getTranslated(context, home_specialist).toString(),
                                        style: TextStyle(fontSize: width * 0.04, color: Palette.dark_blue),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'Specialist');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(right: width * 0.05, left: width * 0.05),
                                    child: Row(
                                      children: [
                                        Text(
                                          getTranslated(context, home_viewAll).toString(),
                                          style: TextStyle(fontSize: width * 0.035, color: Palette.primary),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: height * 0.24,
                            width: width * 1,
                            margin: EdgeInsets.symmetric(vertical: width * 0.02, horizontal: width * 0.03),
                            child: _searchResult.length > 0 || _search.text.isNotEmpty
                                ? ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _searchResult.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    favoriteDoctor.clear();
                                    for (int i = 0; i < _searchResult.length; i++) {
                                      _searchResult[i].isFaviroute == false ? favoriteDoctor.add(false) : favoriteDoctor.add(true);
                                    }
                                    return GestureDetector(
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
                                        width: width * 0.4,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child: Column(
                                            children: [
                                              Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.all(width * 0.02),
                                                        width: width * 0.35,
                                                        height: height * 0.15,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                          child: CachedNetworkImage(
                                                            alignment: Alignment.center,
                                                            imageUrl: _searchResult[index].fullImage!,
                                                            fit: BoxFit.fitHeight,
                                                            placeholder: (context, url) => SpinKitFadingCircle(color: Palette.primary),
                                                            errorWidget: (context, url, error) =>
                                                                Image.asset("assets/images/no_image.jpg"),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 5,
                                                        right: 0,
                                                        child: Container(
                                                          child: SharedPreferenceHelper.getBoolean(Preferences.is_logged_in) == true
                                                              ? IconButton(
                                                            onPressed: () {
                                                              setState(
                                                                    () {
                                                                  favoriteDoctor[index] == false
                                                                      ? favoriteDoctor[index] = true
                                                                      : favoriteDoctor[index] = false;
                                                                  doctorID = _searchResult[index].id;
                                                                  CallApiFavoriteDoctor();
                                                                },
                                                              );
                                                            },
                                                            icon: Icon(
                                                              Icons.favorite_outlined,
                                                              size: 25,
                                                              color:
                                                              favoriteDoctor[index] == false ? Palette.white : Palette.red,
                                                            ),
                                                          )
                                                              : IconButton(
                                                            onPressed: () {
                                                              setState(
                                                                    () {
                                                                  Fluttertoast.showToast(
                                                                    msg: getTranslated(context, home_pleaseLogin_toast)
                                                                        .toString(),
                                                                    toastLength: Toast.LENGTH_SHORT,
                                                                    gravity: ToastGravity.BOTTOM,
                                                                    backgroundColor: Palette.primary,
                                                                    textColor: Palette.white,
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            icon: Icon(
                                                              Icons.favorite_outlined,
                                                              size: 25,
                                                              color:
                                                              favoriteDoctor[index] == false ? Palette.white : Palette.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: width * 0.4,
                                                margin: EdgeInsets.only(top: width * 0.02),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      _searchResult[index].name!,
                                                      style: TextStyle(
                                                          fontSize: width * 0.04,
                                                          color: Palette.dark_blue,
                                                          fontWeight: FontWeight.bold),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: width * 0.4,
                                                child: Column(
                                                  children: [
                                                    _searchResult[index].treatment != null
                                                        ? Text(
                                                      _searchResult[index].treatment!.name.toString(),
                                                      style: TextStyle(fontSize: width * 0.035, color: Palette.grey),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    )
                                                        : Text(
                                                      getTranslated(context, home_notAvailable).toString(),
                                                      style: TextStyle(fontSize: width * 0.035, color: Palette.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            )
                                : doctorlist.length > 0
                                ? ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 3 <= doctorlist.length ? 3 : doctorlist.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    favoriteDoctor.clear();
                                    for (int i = 0; i < doctorlist.length; i++) {
                                      doctorlist[i].isFaviroute == false ? favoriteDoctor.add(false) : favoriteDoctor.add(true);
                                    }

                                    return GestureDetector(
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
                                        width: width * 0.4,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child: Column(
                                            children: [
                                              Column(
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.all(width * 0.02),
                                                        width: width * 0.35,
                                                        height: height * 0.15,
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          child: CachedNetworkImage(
                                                            alignment: Alignment.center,
                                                            imageUrl: doctorlist[index].fullImage!,
                                                            fit: BoxFit.fitHeight,
                                                            placeholder: (context, url) =>
                                                                SpinKitFadingCircle(color: Palette.primary),
                                                            errorWidget: (context, url, error) =>
                                                                Image.asset("assets/images/no_image.jpg"),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 5,
                                                        right: 0,
                                                        child: Container(
                                                          child:
                                                          SharedPreferenceHelper.getBoolean(Preferences.is_logged_in) == true
                                                              ? IconButton(
                                                            onPressed: () {
                                                              setState(
                                                                    () {
                                                                  favoriteDoctor[index] == false
                                                                      ? favoriteDoctor[index] = true
                                                                      : favoriteDoctor[index] = false;
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
                                                                    msg: getTranslated(context, home_pleaseLogin_toast)
                                                                        .toString(),
                                                                    toastLength: Toast.LENGTH_SHORT,
                                                                    gravity: ToastGravity.BOTTOM,
                                                                    backgroundColor: Palette.primary,
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
                                                ],
                                              ),
                                              Container(
                                                width: width * 0.4,
                                                margin: EdgeInsets.only(top: width * 0.02),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      doctorlist[index].name!,
                                                      style: TextStyle(
                                                          fontSize: width * 0.04,
                                                          color: Palette.dark_blue,
                                                          fontWeight: FontWeight.bold),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                width: width * 0.4,
                                                child: Column(
                                                  children: [
                                                    doctorlist[index].treatment != null
                                                        ? Text(
                                                      doctorlist[index].treatment!.name.toString(),
                                                      style: TextStyle(fontSize: width * 0.035, color: Palette.grey),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                    )
                                                        : Text(
                                                      getTranslated(context, home_notAvailable).toString(),
                                                      style: TextStyle(fontSize: width * 0.035, color: Palette.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            )
                                : Center(
                              child: Container(
                                child: Text(
                                  getTranslated(context, home_notAvailable).toString(),
                                  style: TextStyle(fontSize: width * 0.05, color: Palette.grey, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Treatments  //
                      Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    left: width * 0.05,
                                    top: width * 0.05,
                                    right: width * 0.05,
                                  ),
                                  alignment: AlignmentDirectional.topStart,
                                  child: Row(
                                    children: [
                                      Text(
                                        getTranslated(context, home_treatments).toString(),
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Palette.dark_blue,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'Treatment');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: width * 0.05,
                                      top: width * 0.06,
                                      left: width * 0.05,
                                    ),
                                    alignment: AlignmentDirectional.topEnd,
                                    child: Row(
                                      children: [
                                        Text(
                                          getTranslated(context, home_viewAll).toString(),
                                          style: TextStyle(fontSize: width * 0.035, color: Palette.primary),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 125,
                            width: width,
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                ListView.builder(
                                  itemCount: 4 <= treatmentList.length ? 4 : treatmentList.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TreatmentSpecialist(
                                              treatmentList[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        // color: Colors.teal,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 80,
                                              alignment: AlignmentDirectional.center,
                                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                                              child: CachedNetworkImage(
                                                alignment: Alignment.center,
                                                imageUrl: treatmentList[index].fullImage!,
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) =>
                                                // CircularProgressIndicator(),
                                                SpinKitFadingCircle(
                                                  color: Palette.primary,
                                                ),
                                                errorWidget: (context, url, error) => Image.asset("assets/images/no_image.jpg"),
                                              ),
                                            ),
                                            Container(
                                              width: 70,
                                              height: 35,
                                              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                              child: Text(
                                                treatmentList[index].name!,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Palette.dark_blue,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Offer //
                      offerList.length != 0
                          ? Column(
                        children: [
                          Container(
                            alignment: AlignmentDirectional.topStart,
                            margin: EdgeInsets.only(left: width * 0.05, top: width * 0.03, right: width * 0.05),
                            child: Column(
                              children: [
                                Text(
                                  getTranslated(context, home_offers).toString(),
                                  style: TextStyle(fontSize: width * 0.04, color: Palette.dark_blue),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 180,
                            width: width * 1,
                            child: ListView.builder(
                              itemCount: offerList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Container(
                                    height: 160,
                                    width: 175,
                                    child: Card(
                                      color:
                                      index % 2 == 0 ? Palette.light_blue.withOpacity(0.9) : Palette.offer_card.withOpacity(0.9),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                            BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                            child: Container(
                                              height: 40,
                                              margin: EdgeInsets.symmetric(vertical: 5),
                                              child: Center(
                                                child: Text(
                                                  offerList[index].name!,
                                                  style:
                                                  TextStyle(fontSize: 16, color: Palette.dark_blue, fontWeight: FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                            child: Column(
                                              children: [
                                                DottedLine(
                                                  direction: Axis.horizontal,
                                                  lineLength: double.infinity,
                                                  lineThickness: 1.0,
                                                  dashLength: 3.0,
                                                  dashColor: index % 2 == 0
                                                      ? Palette.light_blue.withOpacity(0.9)
                                                      : Palette.offer_card.withOpacity(0.9),
                                                  dashRadius: 0.0,
                                                  dashGapLength: 1.0,
                                                  dashGapColor: Palette.transparent,
                                                  dashGapRadius: 0.0,
                                                )
                                              ],
                                            ),
                                          ),
                                          if (offerList[index].discountType == "amount" && offerList[index].isFlat == 0)
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              child: Text(
                                                getTranslated(context, home_flat).toString() +
                                                    ' ' +
                                                    SharedPreferenceHelper.getString(Preferences.currency_symbol).toString() +
                                                    offerList[index].discount.toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Palette.dark_blue,
                                                ),
                                              ),
                                            ),
                                          if (offerList[index].discountType == "percentage" && offerList[index].isFlat == 0)
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              // alignment: Alignment.topLeft,
                                              child: Text(
                                                offerList[index].discount.toString() +
                                                    getTranslated(context, home_discount).toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Palette.dark_blue,
                                                ),
                                              ),
                                            ),
                                          if (offerList[index].discountType == "amount" && offerList[index].isFlat == 1)
                                            Container(
                                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                              child: Text(
                                                getTranslated(context, home_flat).toString() +
                                                    SharedPreferenceHelper.getString(Preferences.currency_symbol).toString() +
                                                    offerList[index].flatDiscount.toString(),
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Palette.dark_blue,
                                                ),
                                              ),
                                            ),
                                          Container(
                                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(color: Palette.white, borderRadius: BorderRadius.circular(10)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: SelectableText(
                                                offerList[index].offerCode!,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                          : Container(),

                      // looking For //
                      Column(
                        children: [
                          Container(
                            alignment: AlignmentDirectional.topStart,
                            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                            child: Column(
                              children: [
                                Text(
                                  getTranslated(context, home_lookingFor).toString(),
                                  style: TextStyle(fontSize: width * 0.04, color: Palette.dark_blue),
                                ),
                              ],
                            ),
                          ),
                          //banners
                          Container(
                            height: 210,
                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            child: Card(
                              color: Palette.dark_white,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                alignment: Alignment.center,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                  color: Palette.transparent,
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    CarouselSlider(
                                      options: CarouselOptions(
                                        height: 200,
                                        viewportFraction: 1.0,
                                        autoPlay: true,
                                        onPageChanged: (index, index1) {
                                          setState(
                                                () {
                                              _current = index;
                                            },
                                          );
                                        },
                                      ),
                                      items: banner.map((bannerData) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return InkWell(
                                              onTap: () async {
                                                await launch(bannerData.link!);
                                              },
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        alignment: Alignment.topLeft,
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Material(
                                                              color: Palette.white,
                                                              borderRadius: BorderRadius.circular(15.0),
                                                              elevation: 2.0,
                                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                                              type: MaterialType.transparency,
                                                              child: CachedNetworkImage(
                                                                imageUrl: bannerData.fullImage!,
                                                                fit: BoxFit.fill,
                                                                height: height * 0.12,
                                                                width: width * 0.25,
                                                                placeholder: (context, url) => SpinKitFadingCircle(color: Palette.primary),
                                                                errorWidget: (context, url, error) => Image.asset("images/no_image.png"),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.symmetric(horizontal: 16),
                                                        width: width * 0.45,
                                                        child: Text(
                                                          bannerData.name!,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 25,
                                                            fontWeight: FontWeight.bold,
                                                            color: Palette.dark_blue,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.all(12),
                                                    child: Text(
                                                      bannerData.desc!,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                        color: Palette.dark_blue,
                                                      ),
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),*/
          ),
        ),
      ),
    );
  }
  Future<BaseModel<Treatments>> callApiTeatment() async {
    Treatments response;

    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api2().Dio_Data2()).treatmentsRequest();
      setState(() {
        _loadding = false;
        treatmentList.addAll(response.treatmentdata!);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
 /* Future<BaseModel<Doctors>> CallApi_DoctorList() async {
    Doctors response;

    Map<String, dynamic> body = {
      "lat": _lat,
      "lang": _lang,
    };
    setState(() {
      _loadding = true;
    });
    try {
      SharedPreferenceHelper.getBoolean(Preferences.is_logged_in) == true
          ? response = await RestClient(Retro_Api().Dio_Data()).doctorlist(body)
          : response = await RestClient(Retro_Api2().Dio_Data2()).doctorlist(body);
      setState(() {
        _loadding = false;
        doctorlist.addAll(response.doctorslist!);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }*/
  // Logout Api //
  Future logoutUser() async {
    setState(() {
      SharedPreferenceHelper.clearPref();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => DashBoard()),
        ModalRoute.withName('SplashScreen'),
      );
    });
  }
  Future<BaseModel<UserDetail>> Callapiforuserdetail() async {
    UserDetail response;

    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api().Dio_Data()).userdetailRequest(SharedPreferenceHelper.getInt(Preferences.userid).toString());
      setState(() {
        _loadding = false;
        name = response.data!.profileDetail!.name;
        email = response.data!.profileDetail!.email;
        phone_no = response.data!.profileDetail!.mobile;
        image = response.data!.profileDetail!.photo;
        _passDetail();
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
  Future<BaseModel<Banners>> callApiBanner() async {
    Banners response;

    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api2().Dio_Data2()).bannerRequest();
      setState(() {
        _loadding = false;
        if (response.data!.length != 0) {
          imgList.clear();
          for (int i = 0; i < response.data!.length; i++) {
            imgList.add(response.data![i].fullImage);
          }
        }
        banner.addAll(response.data!);
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
        _loadding = false;
        Fluttertoast.showToast(
          msg: '${response.msg}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Palette.primary,
          textColor: Palette.white,
        );
        doctorlist.clear();
      //  CallApi_DoctorList();
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
  Future<BaseModel<DisplayOffer>> callApIDisplayOffer() async {
    DisplayOffer response;

    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api2().Dio_Data2()).displayOfferRequest();
      setState(() {
        _loadding = false;
        offerList.addAll(response.data!);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
  Future<BaseModel<Appointments>> callApiAppointment() async {
    Appointments response;

    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api().Dio_Data()).appointmentsRequest();
      setState(() {
        _loadding = false;
        upcomingAppointment.addAll(response.data!.upcomingAppointment!);
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
      if (appointmentData.name!.toLowerCase().contains(text.toLowerCase())) _searchResult.add(appointmentData);
    });

    setState(() {});
  }
  Future<BaseModel<DetailSetting>> appAllDetail() async {
    DetailSetting response;

    try {
      response = await RestClient(Retro_Api2().Dio_Data2()).detailsettingRequest();
      setState(() {
        SharedPreferenceHelper.setString(Preferences.currency_symbol, response.data!.currencySymbol!);

        SharedPreferenceHelper.setString(Preferences.patientAppId, response.data!.patientAppId!);
        SharedPreferenceHelper.setString(Preferences.currency_code, response.data!.currencyCode!);
        SharedPreferenceHelper.setString(Preferences.cod, response.data!.cod.toString());
        SharedPreferenceHelper.setString(Preferences.stripe, response.data!.stripe.toString());
        SharedPreferenceHelper.setString(Preferences.paypal, response.data!.paypal.toString());
        SharedPreferenceHelper.setString(Preferences.razor, response.data!.razor.toString());
        SharedPreferenceHelper.setString(Preferences.flutterWave, response.data!.flutterwave.toString());
        SharedPreferenceHelper.setString(Preferences.payStack, response.data!.paystack.toString());

        SharedPreferenceHelper.setString(Preferences.stripe_public_key, response.data!.stripePublicKey!);
        SharedPreferenceHelper.setString(Preferences.stripe_secret_key, response.data!.stripeSecretKey!);
        SharedPreferenceHelper.setString(Preferences.paypal_sandbox_key, response.data!.paypalSandboxKey!);
        SharedPreferenceHelper.setString(Preferences.paypal_production_key, response.data!.paypalProducationKey!);
        SharedPreferenceHelper.setString(Preferences.razor_key, response.data!.razorKey!);
        SharedPreferenceHelper.setString(Preferences.flutterWave_key, response.data!.flutterwaveKey!);
        SharedPreferenceHelper.setString(Preferences.flutterWave_encryption_key, response.data!.flutterwaveEncryptionKey!);
        SharedPreferenceHelper.setString(Preferences.payStack_public_key, response.data!.paystackPublicKey!);
        // if(response.data!.mapKey != ""){
        SharedPreferenceHelper.setString(Preferences.map_key, response.data!.mapKey!);
        // }else{
        //   SharedPreferenceHelper.setString(Preferences.map_key, "AIzaSyBo7u69HyRA49RV-VPeTmaJiA3UwbZTwe0");
        // }
        SharedPreferenceHelper.setString(Preferences.patientAppId, response.data!.patientAppId!);
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }


}

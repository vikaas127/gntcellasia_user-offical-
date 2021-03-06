import 'dart:ffi';
import 'package:doctro/const/prefConstatnt.dart';
import 'package:doctro/const/preference.dart';
import 'package:doctro/view/location/AddLocation.dart';
import 'package:doctro/api/Retrofit_Api.dart';
import 'package:doctro/api/network_api.dart';
import 'package:doctro/model/ShowAddress.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../database/form_helper.dart';
import '../../api/base_model.dart';
import '../../api/server_error.dart';
import '../../const/Palette.dart';
import '../../const/app_string.dart';
import '../../localization/localization_constant.dart';
import '../../model/DeleteAddress.dart';

class ShowLocation extends StatefulWidget {
  @override
  _ShowLocationState createState() => _ShowLocationState();
}

class _ShowLocationState extends State<ShowLocation> {
  List<Data> Show_Address = [];

  bool _loadding = false;

  int id = 0;

  String? _Address = "";
  String? _lat = "";
  String? _lang = "";
  int? _addressId;
  int? addressId = 0;

  String? isWhere = "";

  late LocationData _locationData;
  Location location = new Location();

  double currentLat = 0.0;
  double currentLong = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callforShowAddress();
    getIsWhere();
  }

  _passAddress(Select_Address, Select_lat, Select_lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _Address = Select_Address;
      _lat = Select_lat;
      _lang = Select_lang;
      _addressId = addressId;
      prefs.setString('Address', _Address!);
      prefs.setString('lat', _lat!);
      prefs.setString('lang', _lang!);
      prefs.setInt('addressId', _addressId!);
    });
  }

  getIsWhere() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isWhere = prefs.getString('isWhere');
    });
    _locationData = await location.getLocation();
    currentLat = _locationData.latitude!;
    currentLong = _locationData.longitude!;
  }

  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    Show_Address.isNotEmpty == true?_loadding=false:_loadding=true;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(floatingActionButton: FloatingActionButton(onPressed: (){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddLocation(currentLong: currentLong, currentLat: currentLat),
        ),
      );
    },child:  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Icon(Icons.add)

      ),
    ),
    ),
      appBar:AppBar(backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
        child: Text(
          getTranslated(context, showLocation_title).toString(),
          style: TextStyle(fontSize: width * 0.038, fontWeight: FontWeight.bold, color: Palette.dark_blue),
        ),
      ) ,leading:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            child: Icon(
              Icons.arrow_back_ios,color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ) ,),

      body:Show_Address.isNotEmpty == true? ModalProgressHUD(
        inAsyncCall: _loadding,
        opacity: 0.5,
        progressIndicator: SpinKitFadingCircle(
          color: Palette.primary,
          size: 50.0,
        ),
        child: Container(
          height: height * 1,

          child: Show_Address.isNotEmpty == true
              ? ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: Show_Address.length,
                      itemBuilder: (context, index) {
                        addressId = Show_Address[index].id;
                        return InkWell(
                          onTap: () {
                            setState(
                              () {
                                if (isWhere == "Home") {
                                  _passAddress(Show_Address[index].address, Show_Address[index].longitudeCoordinate, Show_Address[index].longitudeCoordinate);
                                  Navigator.pushReplacementNamed(context, "Dashboard");
                                } else if (isWhere == "MadicinePayment") {
                                  _passAddress(Show_Address[index].address, Show_Address[index].latitudeCoordinate, Show_Address[index].latitudeCoordinate);
                                  Navigator.pushReplacementNamed(context, "MadicinePayment");
                                }
                              },
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 0),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 50, right: 50),
                                  alignment: AlignmentDirectional.topStart,
                                  child: Show_Address[index].address != null
                                      ? Text(
                                          Show_Address[index].city!.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Palette.black,
                                          ),
                                        )
                                      : Text(
                                          getTranslated(context, showLocation_label).toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Palette.blue,
                                          ),
                                        ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10, top: 5, right: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          size: 25,
                                          color: Palette.primary,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                        child: Container(
                                          width: width * 0.8,
                                          child: Text(
                                            Show_Address[index].address!,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.justify,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Palette.dark_grey,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 0, left: 50, right: 50),
                                  alignment: AlignmentDirectional.topStart,
                                  child: GestureDetector(
                                    onTap: () {
                                      FormHelper.showMessage(
                                        context,
                                        getTranslated(context, showLocation_removeAddress_alert_title).toString(),
                                        getTranslated(context, showLocation_removeAddress_alert_text).toString(),
                                        getTranslated(context, No).toString(),
                                        () {
                                          Navigator.of(context).pop();
                                        },
                                        buttonText2: getTranslated(context, Yes).toString(),
                                        isConfirmationDialog: true,
                                        onPressed2: () {
                                          callApiForDeleteAddress(Show_Address[index].id);
                                          Navigator.of(context).pop();
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        getTranslated(context, showLocation_removeAddress).toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Palette.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(15),
                                  child: DottedLine(
                                    direction: Axis.horizontal,
                                    lineLength: double.infinity,
                                    lineThickness: 1.0,
                                    dashLength: 4.0,
                                    dashColor: Palette.blue,
                                    dashRadius: 0.0,
                                    dashGapLength: 4.0,
                                    dashGapColor: Palette.transparent,
                                    dashGapRadius: 0.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )
              : Container(
                  width: width,
                  child: Center(
                    child: Text(
                      getTranslated(context, showLocation_noAddress).toString(),
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: Palette.dark_blue,
                      ),
                    ),
                  ),
                ),
        ),
      ):
      Container(child: Center(child: Column(
        children: [
          //assets/images/nodata.png
          SizedBox(height: height*0.25,),
          Image.asset(
            'assets/images/nodata.png',
            width: height*0.20,
            height: height*0.20,
            fit: BoxFit.cover,
          ),
          Text("No  Location Added",textAlign: TextAlign.center, style: TextStyle(
              color: Colors.black,
              fontFamily: 'Open Sans',
              fontSize: 16,
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
              height: 1
          ),),
        ],
      )),),
    );
  }

  Future<BaseModel<ShowAddress>> callforShowAddress() async {
    ShowAddress response;
    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api().Dio_Data()).showaddressRequest(SharedPreferenceHelper.getInt(Preferences.userid));
      Show_Address.clear();
      if (response.status == 200) {
        setState(() {
          _loadding = false;
          Show_Address.addAll(response.data!);
        });
      }
    } catch (error, stacktrace) {

      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Future<BaseModel<DeleteAddress>> callApiForDeleteAddress(address_id) async {
    DeleteAddress response;
    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api().Dio_Data()).deleteaddressRequest(address_id);
      if (response.success == true) {
        setState(() {
          _loadding = false;
          Fluttertoast.showToast(
            msg: response.msg!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Palette.blue,
            textColor: Palette.white,
          );
          callforShowAddress();
        });
      }
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}

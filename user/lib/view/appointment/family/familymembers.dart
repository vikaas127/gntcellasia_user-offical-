import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctro/api/Retrofit_Api.dart';
import 'package:doctro/api/apis.dart';
import 'package:doctro/api/network_api.dart';
import 'package:doctro/const/app_string.dart';
import 'package:doctro/const/prefConstatnt.dart';
import 'package:doctro/const/preference.dart';

import 'package:doctro/model/TreatmentWishDoctor.dart';
import 'package:doctro/view/appointment/doctordetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/base_model.dart';
import '../../../api/server_error.dart';
import '../../../const/Palette.dart';

import '../../../localization/localization_constant.dart';
import 'addfamily.dart';
import 'models/m_familymember.dart';


class Familymembers extends StatefulWidget {


  Familymembers() {

  }

  @override
  FamilymembersState createState() => FamilymembersState();
}

class FamilymembersState extends State<Familymembers> {
  bool _loadding = false;
  String? _Address = "";
  String? _lat = "";
  String? _lang = "";
  int? id = 0;
  List<Data> fmemberList = [];
  String treatmentName = "";
  String? treatmentSpecialist = "";
  TextEditingController _search = TextEditingController();
  List<Data> _searchResult = [];
  String? SelectMember = "";
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
    callApiFamilyMembers();
  }
  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    return Scaffold(

      body:fmemberList.isNotEmpty == true?  ModalProgressHUD(
        inAsyncCall: _loadding,
        opacity: 0.5,
        progressIndicator: SpinKitFadingCircle(
          color: Palette.primary,
          size: 50.0,
        ),
        child:    Container(


          child:fmemberList.isNotEmpty==true? ListView(
            scrollDirection: Axis.horizontal,

            children: [

                   fmemberList.length != 0
                  ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: fmemberList.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                /* gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1, mainAxisSpacing: 5, childAspectRatio: 0.85),*/
                itemBuilder: (context, index) {
                  return fmemberList.length != null
                      ? Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            SelectMember =
                                fmemberList[index].name;
                          });
                        },

                        child: Container(
                          height: width * 0.26 ,
                          width: width * 0.20,
                          child:   Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Card(
                                color: SelectMember ==
                                    fmemberList[index].name
                                    ? Color(0xff2C9085)
                                    : Palette.dash_line,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(32.0),
                                ),child:
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(

                                  height: 45.0,
                                  width: 45.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(35),
                                    ),
                                    child: fmemberList[index].photo!=null ?
                                    CachedNetworkImage(
                                      alignment: Alignment.center,
                                      imageUrl:'${Apis.baseUrlImages}${fmemberList[index].photo!}'

                                      ,fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          SpinKitFadingCircle(
                                              color: Palette.primary),
                                      errorWidget: (context, url,
                                          error) =>
                                          Image.asset(
                                              "assets/images/no_image.jpg"),
                                    ):
                                    Image.asset(
                                        "assets/images/no_image.jpg"),
                                  ),
                                ),
                              ),),
                              SizedBox(height: 2,),
                              Container(

                                child:   Column(crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text(
                                          fmemberList[index].name!.toString().toUpperCase(),
                                          style: TextStyle(color: SelectMember ==
                                              fmemberList[index].name
                                              ? Palette.primary
                                              : Palette.grey,fontSize: 13,fontWeight: FontWeight.bold)
                                      ),
                                    ),
                                    Center(
                                      child: Text(
                                          fmemberList[index].relation!.toString().toUpperCase(),
                                          style: TextStyle(color: Palette.grey,fontSize: 10,fontWeight: FontWeight.bold)
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
                  )
                      : Center(
                    child: Column(
                      children: [
                        //assets/images/nodata.png
                        Image.asset(
                        "assets/images/nodata.png"),

                        Text(
                          getTranslated(context,
                              treatmentSpecialist_treatmentNotAvailable)
                              .toString(),
                        ),
                      ],
                    ),
                  );
                },
              )
                  : Container(
                alignment: AlignmentDirectional.center,
                margin: EdgeInsets.only(top: 250),
                child: Text(
                  "No member Added",

                  style: TextStyle(
                      fontSize: width * 0.04,
                      color: Palette.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ):Container(child:
          Column(
            children: [
              //assets/images/nodata.png
              Image.asset(
                  "assets/images/nodata.png",height: 70,width: 70,),

              Text(
                getTranslated(context,
                    treatmentSpecialist_treatmentNotAvailable)
                    .toString(),
              ),
            ],
          ),
          ),
        ),
      ):
    Container(child:
    Center(child: Column(
    children: [
    //assets/images/nodata.png

    Image.asset(
    'assets/images/nodata.png',
    width: height*0.10,
    height: height*0.10,
    fit: BoxFit.cover,
    ),
    Text("No Member found",textAlign: TextAlign.center, style: TextStyle(
    color: Colors.black,
    fontFamily: 'Open Sans',
    fontSize: 10,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
    height: 1
    ),),
    ],
    )))

    );
  }
  Future<BaseModel<M_familymember>> callApiFamilyMembers() async {
    M_familymember response;
    Map<String, dynamic> body = {
      "lat": _lat,
      "lang": _lang,
    };
    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api2().Dio_Data2()).familymemberRequest(SharedPreferenceHelper.getInt(Preferences.userid), body);
      setState(() {
        if (response.status == 200) {
          setState(() {
            _loadding = false;
            fmemberList.addAll(response.data!);
            for (int i = 0; i < fmemberList.length; i++) {
              treatmentSpecialist = fmemberList[i].name;
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

    fmemberList.forEach((appointmentData) {
      if (appointmentData.name!.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(appointmentData);
    });

    setState(() {});
  }
}

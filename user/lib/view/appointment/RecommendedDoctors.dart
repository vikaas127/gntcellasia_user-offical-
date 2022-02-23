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

import '../../../localization/localization_constant.dart';
import 'doctordetail.dart';

class RecomendedSpecialist extends StatefulWidget {
  int? id=44;

  TreatmentSpecialist(int? id) {
    this.id = id;
  }

  @override
  RecomendedSpecialistState createState() => RecomendedSpecialistState();
}

class RecomendedSpecialistState extends State<RecomendedSpecialist> {
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

      body: ModalProgressHUD(
        inAsyncCall: _loadding,
        opacity: 0.5,
        progressIndicator: SpinKitFadingCircle(
          color: Palette.primary,
          size: 50.0,
        ),
        child:    Container(

      //    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [

                   treatmentSpecialistList.length != 0
                  ? ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: treatmentSpecialistList.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
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
                          height: width * 0.40,
                          width: width * 0.36,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Row(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                                      color: Palette.primary),
                                              errorWidget: (context, url,
                                                  error) =>
                                                  Image.asset(
                                                      "assets/images/nodoctor.png"),
                                            ):Image.asset(
                                                "assets/images/nodoctor.png"),
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Container(
                                          margin: EdgeInsets.only(top: width * 0.02,left: width*0.02),
                                          child:   Column(crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Text(
                                                  treatmentSpecialistList[index].name!.toString().toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: width * 0.035,
                                                      fontWeight: FontWeight.bold,
                                                      color: Palette.dark_blue),
                                                ),
                                              ),



                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                /*decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5.0) //                 <--- border radius here
                                                  ),
                                                ),*/
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
                                                      Text('|'),
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
                                              ),


                                            ],
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),


                                ],
                              ),

                            ],
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
          //    treatmentSpecialist = treatmentSpecialistList[i].treatmentdata![0].name;
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../HealthTipsDetail.dart';
import '../api/Retrofit_Api.dart';
import '../api/network_api.dart';
import '../model/HealthTip.dart';
import 'api/base_model.dart';
import 'api/server_error.dart';
import 'const/Palette.dart';
import 'const/app_string.dart';
import 'localization/localization_constant.dart';

class HealthTips extends StatefulWidget {
  @override
  _HealthTipsState createState() => _HealthTipsState();
}

class _HealthTipsState extends State<HealthTips> {
  bool _loadding = false;
  List<Data> healthtip = [];

  String? _Address = "";

  @override
  void initState() {
    callApi();
    _getAddress();

    // TODO: implement initState
    super.initState();
  }

  _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        _Address = (prefs.getString('Address'));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      inAsyncCall: _loadding,
      opacity: 0.5,
      progressIndicator: SpinKitFadingCircle(
        color:  Palette.blue,
        size: 50.0,
      ),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color:  Palette.dark_blue,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          backgroundColor:  Palette.white,
          title: Text(
            getTranslated(context, healthTips_title).toString(),
            style: TextStyle(fontSize: 18, color: Color(0xFF003165), fontWeight: FontWeight.bold),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: healthtip.length != 0
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width,
                      color:  Palette.white,
                      margin: EdgeInsets.symmetric(vertical: height * 0.015),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Text(
                          getTranslated(context, healthTips_subTitle).toString(),
                          // 'Today\'s Health Tips',
                          style: TextStyle(
                              fontSize: width * 0.04,
                              color:  Palette.dark_blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: healthtip.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: width * 0.03,
                                      vertical: height * 0.002,
                                    ),
                                    width: width * 1,
                                    height: 120,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HealthTipsDetail(
                                              healthtip[index].id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        color:  Palette.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        elevation: 5,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                horizontal: width * 0.015,
                                                vertical: height * 0.015,
                                              ),
                                              child: Container(
                                                width: width * 0.24,
                                                height: 100,
                                                child: CachedNetworkImage(
                                                  alignment: Alignment.center,
                                                  imageUrl: healthtip[index].fullImage!,
                                                  fit: BoxFit.fill,
                                                  placeholder: (context, url) =>
                                                      SpinKitFadingCircle(
                                                    color:  Palette.blue,
                                                  ),
                                                  errorWidget: (context, url, error) => Image.asset(
                                                    "assets/images/no_image.jpg",
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  width: width * 0.6,
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 5, left: 7),
                                                        alignment: AlignmentDirectional.topStart,
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                healthtip[index].title!,
                                                                style: TextStyle(
                                                                    fontSize: width * 0.035,
                                                                    color:  Palette.dark_blue,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: height * 0.01, left: 7),
                                                        alignment: AlignmentDirectional.topStart,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              healthtip[index].blogRef!,
                                                              style: TextStyle(
                                                                fontSize: width * 0.03,
                                                                color:  Palette.dark_blue,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Container(
                                                          height: 45.3,
                                                          margin: EdgeInsets.only(
                                                            bottom: height * 0.01,
                                                          ),
                                                          child: Html(
                                                            data: healthtip[index].desc,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    )
                  ],
                )
              : Container(
                  alignment: AlignmentDirectional.center,
                  margin: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    getTranslated(context, healthTips_noTips).toString(),
                    style: TextStyle(
                        fontSize: width * 0.04,
                        color:  Palette.grey,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ),
    );
  }


  Future<BaseModel<HealthTip>> callApi() async {
    HealthTip response;
    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api2().Dio_Data2()).healthtipRequest();
      setState(() {
        _loadding = false;
        if (response.success == true) {
          setState(
                () {
              _loadding = false;
              healthtip.addAll(response.data!);
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
}

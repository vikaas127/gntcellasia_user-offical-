import 'dart:convert';
import 'dart:ffi';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:doctro/api/apis.dart';
import 'package:doctro/model/Timeslot.dart';
import 'package:doctro/view/appointment/Bookappointment.dart';
import 'package:doctro/api/Retrofit_Api.dart';
import 'package:doctro/api/network_api.dart';
import 'package:doctro/const/prefConstatnt.dart';
import 'package:doctro/const/preference.dart';
import 'package:doctro/view/appointment/Review_Appointment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/base_model.dart';
import '../../api/server_error.dart';
import '../../const/Palette.dart';
import '../../const/app_string.dart';
import '../../database/form_helper.dart';
import '../../localization/localization_constant.dart';
import '../../model/Docterdetail.dart';
import 'RecommendedDoctors.dart';

class Doctordetail extends StatefulWidget {
  int? id;

  Doctordetail(int? id) {
    this.id = id;
  }

  @override
  _DoctordetailState createState() => _DoctordetailState(id);
}

class _DoctordetailState extends State<Doctordetail> with
    TickerProviderStateMixin {
  bool _loadding = false;
  String? selectTime = "";
  List<Tab> tabList = [];
  TabController? _tabController;
  List< EducationDetail>  educationaldetail=[];
  int? id = 0;
  String? name = "";
  String? expertise = "";
  String? appointmentFees = "";
  String? experience = "";
  dynamic rate = 0.0;
  String? desc = "";
  String education = "";
  String certificate = "";
  String? fullImage = "";
  String? treatmentname = "";
  String? mobileNo = "";
  List<String?> collage = [];
  List<String?> de_year = [];
  List<String?> award = [];
  List<String?> ce_year = [];
  List<Hosiptal> hosiptaldetail = [];
  List<Hospitalgallery> hosiptalGallery = [];
  List<Reviews> reviews = [];
  _DoctordetailState(int? id) {
    this.id = id;
  }
  DateTime? todayDate;
 // int? id = 0;
  String New_Date = "";
  String New_Dateuser = "";
  String pass_BookDate = "";
  String pass_BookTime = "";
  String pass_BookID = "";
  String? Booking_Id = "";
  List<Slots> timelist = [];
  late DateTime _firstTimeSelected;

void initState() {
  print("vikkkkaas");
  New_Date = DateUtilforpass().formattedDate(DateTime.now());
  print(New_Date);
  Future.delayed(Duration.zero, () {
    tabList.add(
      new Tab(
        child: Container(
          child: Text(
            getTranslated(context, doctorDetail_tab1_title).toString(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    tabList.add(
      new Tab(
        child: Container(
          child: Text(
            getTranslated(context, doctorDetail_tab2_title).toString(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    tabList.add(
      new Tab(
        child: Container(
          child: Text(
            getTranslated(context, doctorDetail_tab3_title).toString(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    _tabController = new TabController(vsync: this, length: tabList.length);
    _doctordetail();
  });

  super.initState();


    todayDate = DateTime.now();
    _firstTimeSelected = DateTime.now();


    setState(() {

      TimeSlot( New_Date);
    });
}
  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }
  Future<BaseModel<Timeslot>> TimeSlot( String New_Date) async {print("timeslot${New_Date}");
    Timeslot response;
    timelist.clear();
    Map<String, dynamic> body = {
      "doctor_id": id,
      "date": New_Date,
    };
    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api().Dio_Data()).timeslot(body);
      print(response.slots.toString());
      if (response.status == 200) {
        setState(() {
          _loadding = false;
          timelist.addAll(response.slots!);
        });
      }
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
    Size size = MediaQuery.of(context).size;
    return Container(

      child: Scaffold(

        body:tabList.length!=0? DefaultTabController(initialIndex: 1,
      length: tabList.length,
      child:
        CustomScrollView(
          slivers: <Widget>[



           SliverAppBar( elevation: 0,
             leading: IconButton(
             icon: Icon(
               Icons.arrow_back_ios,
               size: 20,
               color: Palette.dark_blue,
             ),
             onPressed: () {
               Navigator.pop(context);
             },
           ),title:Text(
             getTranslated(context, doctorDetail_title).toString(),
             style: TextStyle(fontSize: 18, color: Palette.dark_blue, fontWeight: FontWeight.bold),
           ),
             actions: [//assets/images/share.png
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Image.asset('assets/images/bookmark.png',width: 20,height:20),
               ),
               InkWell(onTap: (){
                 Share.share('http://brtechgeeks.pythonanywhere.com/api/doctors/{$id}');
               },
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Image.asset('assets/images/share.png',width: 20,height:20),
                 ),
               )
             ],
             backgroundColor: Colors.white,
              pinned: true,floating: true,
              expandedHeight: height*0.395,

              flexibleSpace:FlexibleSpaceBar(
                  background:
                  Container(decoration: BoxDecoration(
                // color: Colors.white,
                image: DecorationImage(alignment: Alignment.topCenter,
                  image: AssetImage("assets/images/intro_header.png",),
                  fit: BoxFit.fitWidth,
                ),
              ),
                    child:   Expanded(
                    flex: 3,
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(height: height*0.075,),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.0170),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                /*   GestureDetector(
                                onTap: () {
                                  launch("tel:$mobileNo");
                                },
                                child: Container(
                                  child: SvgPicture.asset(
                                    'assets/icons/call.svg',
                                  ),
                                ),
                              ),*/
                                Container(
                                  width: width * 0.20,
                                  height: width * 0.20,
                                  child: CachedNetworkImage(
                                    alignment: Alignment.center,
                                    imageUrl: '${Apis.baseUrl}$fullImage',
                                    imageBuilder: (context, imageProvider) => CircleAvatar(
                                       radius:50 ,
                                        backgroundColor: Palette.blue,
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: imageProvider,
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                    // CircularProgressIndicator(),
                                    SpinKitFadingCircle(color: Palette.blue),
                                    errorWidget: (context, url, error) =>ClipRRect(
                                      borderRadius: BorderRadius.circular(38.0),
                                      child:
                                        Image.asset("assets/images/no_image.jpg"),),
                                  ),
                                ),
                                /*    GestureDetector(
                                onTap: () {
                                  launch("sms:$mobileNo");
                                },
                                child: Container(
                                  child: SvgPicture.asset(
                                    'assets/icons/msg.svg',
                                  ),
                                ),
                              ),*/
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: width * 0.04),
                            child: Text(
                              '$name',
                              style: Theme.of(context).textTheme.headline1
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: width * 0.01),
                            child: Text(
                              '$treatmentname',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Palette.grey,
                              ),
                            ),
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
                                        '$experience  ' +
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
                                        SharedPreferenceHelper.getString(Preferences.currency_symbol).toString() + '$appointmentFees',
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
                                      child: Text('$appointmentFees',
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
                                              '$rate',
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
                        ],
                      ),
                    ),
                  ) ,

              )


              ),

            ),
            SliverPersistentHeader(pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  indicator:BoxDecoration(color: Colors.black12,
                      borderRadius: BorderRadius.all(
                          Radius.circular(25.0) //                 <--- border radius here
                      ),

                      border: Border.all(color: Colors.grey)
                  ),

                  labelStyle: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                  labelColor: Palette.primary,
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.transparent,
                  tabs: tabList,
                  unselectedLabelColor: Palette.dark_blue,
                ),
              ),),

            SliverFillRemaining(child:ModalProgressHUD(
              inAsyncCall: _loadding,
              opacity: 0.5,
              progressIndicator: SpinKitFadingCircle(
                color: Palette.blue,
                size: 50.0,
              ),
              child:new TabBarView(
                controller: _tabController,
                children: [
                  //tab1
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Divider(thickness: 1.5,),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: width * 0.05,
                                top: size.height * 0.02,
                                right: width * 0.05),
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              getTranslated(context, doctorDetail_personalBio).toString(),
                              style:
                              Theme.of(context).textTheme.headline1,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: width * 0.05, top: height * 0.01, right: width * 0.05),
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              '$desc',
                              style: TextStyle(fontSize: 13, color: Palette.grey),
                              textAlign: TextAlign.justify,
                              maxLines: 4,
                            ),
                          ),
                        ),
                        Divider(thickness: 1.5,),
                        hosiptaldetail.length!=0 ?Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.05,

                                    right: width * 0.02),
                                alignment: AlignmentDirectional.topStart,
                                child: Row(crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(flex:2,
                                      child: Text("Clinic Detail",
                                        style:Theme.of(context).textTheme.headline1

                                      ),
                                    ),
                                    Expanded(flex:1,
                                      child: InkWell(onTap: (){
                                        setState(() {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[

                                                      Container(height: 350,child: ListView(scrollDirection: Axis.vertical,shrinkWrap: true,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(18.0),
                                                            child: Container(
                                                              decoration:BoxDecoration(
                                                                border: Border.all(
                                                                    width: 3.0
                                                                ),
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(5.0) //                 <--- border radius here
                                                                ),
                                                              ),

                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Column(
                                                                  children: [
                                                                    Text("${hosiptaldetail[0].name}"),
                                                                    Text("${hosiptaldetail[0].city}"),

                                                                  ],
                                                                ),
                                                              ) ,),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(18.0),
                                                            child: Container(
                                                              decoration:BoxDecoration(
                                                                border: Border.all(
                                                                    width: 3.0
                                                                ),
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(5.0) //                 <--- border radius here
                                                                ),
                                                              ),

                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Column(
                                                                  children: [
                                                                    Text("${hosiptaldetail[0].name}"),
                                                                    Text("${hosiptaldetail[0].city}"),

                                                                  ],
                                                                ),
                                                              ) ,),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(18.0),
                                                            child: Container(
                                                              decoration:BoxDecoration(
                                                                border: Border.all(
                                                                    width: 3.0
                                                                ),
                                                                borderRadius: BorderRadius.all(
                                                                    Radius.circular(5.0) //                 <--- border radius here
                                                                ),
                                                              ),

                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Column(
                                                                  children: [
                                                                    Text("${hosiptaldetail[0].name}"),
                                                                    Text("${hosiptaldetail[0].city}"),

                                                                  ],
                                                                ),
                                                              ) ,),
                                                          ),

                                                        ],),)
                                                    ],
                                                  );
                                              });




                                        });
                                      },
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 0.0),
                                          child: Text("View ${hosiptaldetail.length} more clinics ",
                                            style:TextStyle(decoration: TextDecoration.underline,

                                                color: Colors.grey,fontSize: 11,fontWeight: FontWeight.bold)

                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.05,
                                    top: size.height * 0.02,
                                    right: width * 0.02),
                                alignment: AlignmentDirectional.topStart,
                                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(flex:2,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/hospital.svg',
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Text("${hosiptaldetail[1].name!.substring(0,4 ).trim()}",
                                                  style:Theme.of(context).textTheme.headline1

                                                ),
                                                Text("${hosiptaldetail[1].address!.trim()}",
                                                  style:TextStyle(

                                                      color: Colors.grey,fontSize: 10,fontWeight: FontWeight.bold)



                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(flex:1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 28.0),
                                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Fees: ",
                                              style:
                                              TextStyle(fontSize: width * 0.04, color: Palette.dark_blue,fontStyle: FontStyle.normal,fontWeight: FontWeight.bold),
                                            ),
                                            Text("199 ",
                                              style:
                                              TextStyle(fontSize: width * 0.04, color: Palette.primary,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),


                          ],
                        ):Container(height:20),
                        Divider(thickness: 1.5,),
                     // datepicker
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DatePicker(
                            DateTime.now(),
                            height:54,width:90,
                            dayTextStyle:TextStyle(fontSize: 0) ,
                            dateTextStyle: TextStyle(fontSize: 10),
                            initialSelectedDate: DateTime.now(),
                            selectionColor: Color(0xff2C9085),
                            selectedTextColor: Colors.white,
                            deactivatedColor: Colors.black12,
                            onDateChange: (date) {

                              // New date selected
                              setState(() {
                                New_Date = DateUtilforpass().formattedDate(date);
                                TimeSlot(New_Date);
                              });
                            },
                          ),
                        ),
                        //slots
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            child: 0 < timelist.length
                                ? Column(
                              children: [

                                Container(

                                  child: GridView.builder(
                                    itemCount: timelist.length >= 4?4:timelist.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 2,
                                      mainAxisSpacing: 2,
                                      crossAxisCount: 4,
                                      childAspectRatio: 1.2,
                                    ),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectTime =
                                                    timelist[index].startAt;
                                              });
                                            },
                                            child: Container(
                                              height: 47,
                                              width: width * 0.25,
                                              child: Card(
                                                color: selectTime ==
                                                    timelist[index].startAt
                                                    ? Color(0xff2C9085)
                                                    : Palette.dash_line,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(10.0),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.all(10),
                                                      child: Text(
                                                        timelist[index].startAt!,
                                                        style: TextStyle(
                                                          color: selectTime ==
                                                              timelist[index]
                                                                  .startAt
                                                              ? Palette.white
                                                              : Color(0xff2C9085),),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                                : Container(
                              height: height * 0.4,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: Text(
                                  getTranslated(context, bookAppointment_selectOtherDate).toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: width * 0.04,
                                      color: Palette.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
//view all slots
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, 'Bookappointment');
                          },
                          child: Container(decoration: BoxDecoration(
                            border: Border.all(color: Palette.green,
                                width: 1.0
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0) //         <--- border radius here
                            ),
                          ),
                              margin: EdgeInsets.only(right: width * 0.05, left: width * 0.05),
                              child:   Center(
                                child: Padding(
                                  padding: const EdgeInsets.all( 8.0),
                                  child: Text("View All Slots",
                                    style: TextStyle(fontSize: width * 0.035, color: Palette.green,fontStyle: FontStyle.italic),
                                  ),
                                ),
                              )
                          ),
                        ),
                        Divider(thickness: 1.5,),
                        Container(height: 80,width: width,
                            child:hosiptaldetail.length!=0? ListView.builder(shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: hosiptaldetail[0].hospitalgallery!.length,
                                itemBuilder: (context,index){
                              return  Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(height: 50,width: 80,child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child:Image.network("${Apis.baseUrl}${hosiptaldetail[0].hospitalgallery![index].fullImage}",fit:BoxFit.fitHeight ,),),
                              ));
                            }):Container(),),
                        Divider(thickness: 1.5,),
                        Container(height: height*0.26,width: width,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text("Recommended Doctors Near By you",style: Theme.of(context).textTheme.headline1),

                                    ],
                                  ),
                                ),
                                Container(height: 159,width: width,
                                    child: RecomendedSpecialist( )),
                              ],
                            ))
                      ],
                    ),
                  ),

                  //tab 2
                  ListView(scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Education",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: educationaldetail.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                left: width * 0.05, top: width * 0.02, right: width * 0.05),
                            alignment: AlignmentDirectional.topStart,
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                    "assets/icons/education.svg",
                                    semanticsLabel: 'Acme Logo'
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: AlignmentDirectional.topStart,
                                        child: Text(
                                          educationaldetail[index].name!.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: width * 0.03, color: Palette.dark_blue),
                                        ),
                                      ),
                                      Container(
                                        alignment: AlignmentDirectional.topStart,
                                        child: Text(
                                          educationaldetail[index].univercity!,
                                          style: TextStyle(
                                              fontSize: width * 0.03, color: Palette.grey),
                                        ),
                                      ),
                                      Container(
                                        alignment: AlignmentDirectional.topStart,
                                        child: Text(
                                          educationaldetail[index].passingYear!,
                                          style: TextStyle(
                                            fontSize: width * 0.03,
                                            color: Palette.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Exprience",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: hosiptaldetail.length,
                        itemBuilder: (context, index) {
                          return
                            Container(width: width,
                              child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(flex: 1,
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/icons/hospital.svg",
                                            semanticsLabel: 'Acme Logo'
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(flex: 6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: width / 3,
                                          child:hosiptaldetail[index].city!=null?
                                          Text(
                                            hosiptaldetail[index].city!,
                                            style: TextStyle(
                                                fontSize: width * 0.03, color: Palette.grey),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ):Text(""),
                                        ),

                                        Container(
                                          child: Text(
                                            hosiptaldetail[index].name!,maxLines: 2,
                                            style: TextStyle(
                                                fontSize: width * 0.03, color: Palette.grey),
                                          ),
                                        ),
                                        Container(
                                          width: width ,
                                          child: Text("",
                                            //  hosiptaldetail[index].address!,
                                            style: TextStyle(
                                                fontSize: width * 0.03, color: Palette.grey),
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            );
                        },
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: width * 0.05,
                              top: size.height * 0.02,
                              right: width * 0.05),
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            getTranslated(context, doctorDetail_certificate).toString(),
                            style:
                            TextStyle(fontSize: width * 0.04, color: Palette.dark_blue),
                          ),
                        ),
                      ),
                    ],
                  ),


                  //tab 3
                  reviews.length != 0
                      ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: width * 0.05,
                                  top: size.height * 0.02,
                                  right: width * 0.05),
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                getTranslated(context, doctorDetail_review).toString(),
                                style: TextStyle(
                                    fontSize: width * 0.04, color: Palette.dark_blue),
                              ),
                            ),
                          ),
                          reviews.length != 0
                              ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: reviews.length,
                            itemBuilder: (context, index) {
                              String date = DateUtil().formattedDate(
                                  DateTime.parse(reviews[index].createdAt!));
                              return Container(
                                margin: EdgeInsets.only(
                                  left: width * 0.02,
                                  right: width * 0.02,
                                ),
                                width: width * 0.87,
                                height: height * 0.13,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: ListTile(
                                        isThreeLine: true,
                                        leading: SizedBox(
                                          child: Container(
                                            height: height * 0.062,
                                            width: width * 0.125,
                                            decoration: new BoxDecoration(
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  new BoxShadow(
                                                    color: Palette.blue,
                                                    blurRadius: 1.0,
                                                  ),
                                                ]),
                                            child: CachedNetworkImage(
                                              alignment: Alignment.center,
                                              imageUrl:
                                              reviews[index].user!.image!,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                  CircleAvatar(
                                                    radius: 50,
                                                    backgroundColor: Palette.white,
                                                    child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundImage: imageProvider,
                                                    ),
                                                  ),
                                              placeholder: (context, url) =>
                                                  SpinKitFadingCircle(
                                                      color: Palette.dark_blue),
                                              errorWidget: (context, url, error) =>
                                                  Image.asset(
                                                    "assets/images/no_image.jpg",
                                                  ),
                                            ),
                                          ),
                                        ),
                                        title: Column(
                                          children: [
                                            Container(
                                              alignment:
                                              AlignmentDirectional.topStart,
                                              margin: EdgeInsets.only(
                                                top: height * 0.01,
                                              ),
                                              child: Text(
                                                reviews[index].user!.name!,
                                                style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Container(
                                              alignment:
                                              AlignmentDirectional.topStart,
                                              child: Text(
                                                '$date',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Palette.grey),
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Container(
                                          child: RatingBarIndicator(
                                            rating: reviews[index].rate!.toDouble(),
                                            itemBuilder: (context, index) => Icon(
                                              Icons.star,
                                              color: Palette.blue,
                                            ),
                                            itemCount: 5,
                                            itemSize: width * 0.04,
                                            direction: Axis.horizontal,
                                          ),
                                        ),
                                        subtitle: Container(
                                          margin: EdgeInsets.only(top: width * 0.015),
                                          alignment: AlignmentDirectional.topStart,
                                          child: Text(
                                            reviews[index].review!,
                                            style: TextStyle(
                                                fontSize: 12, color: Palette.grey),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                              : SizedBox(),
                        ],
                      ))
                      : Container(
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      getTranslated(context, doctorDetail_noReview).toString(),
                      // "No Review",
                      style: TextStyle(fontSize: width * 0.04, color: Palette.dark_blue),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),):Container(),

        bottomNavigationBar: Container(height: height*0.095,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Divider(thickness: 2,),
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('NEXT AVALIBLE AT',
                            style: TextStyle(fontSize: width * 0.035, color: Palette.black,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text('6.30 AM, Tomorrow',
                            style: TextStyle(fontSize: width * 0.025, color: Palette.black,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                    ),
                    Expanded(flex: 1,
                      child: ElevatedButton(

                        child: Text(
                          getTranslated(context, doctorDetail_bookAppointment).toString(),
                          style: TextStyle(fontSize: width * 0.04, color: Palette.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          SharedPreferenceHelper.getBoolean(Preferences.is_logged_in) == true
                              ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Bookappointment(id),
                            ),
                          )
                              : FormHelper.showMessage(
                            context,
                            getTranslated(context, doctorDetail_appointmentBook_alert_title).toString(),
                            getTranslated(context, doctorDetail_appointmentBook_alert_text).toString(),
                            getTranslated(context, cancel).toString(),
                                () {
                              Navigator.of(context).pop();
                            },
                            buttonText2: getTranslated(context, login).toString(),
                            // "Login",
                            isConfirmationDialog: true,
                            onPressed2: () {
                              Navigator.pushNamed(context, 'SignIn');
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<BaseModel<Doctordetails>> _doctordetail() async {
    Doctordetails response;
    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api2().Dio_Data2()).doctoedetailRequest(id);
      if (response.status == 200) {
        setState(
          () {
            _loadding = false;
            id = response.data!.id;
            name = response.data!.name;
         //   rate = response.data!.amount!.toDouble();
            experience = response.data!.workExperience;
            appointmentFees = response.data!.amount;
            desc = response.data!.description;
            expertise = response.data!.expertise!.name;
            fullImage = response.data!.photo;
            treatmentname = response.data!.treatmentdata!.name;
            reviews.addAll(response.data!.reviews!);

            hosiptaldetail.addAll(response.data!.hosiptal!);

              educationaldetail = response.data!.educationDetail!;

            var convert_certificate = response.data!.consultationfeeDetail!;
            award.clear();
            ce_year.clear();

              award.add(convert_certificate.description);
              ce_year.add(convert_certificate.amount);

          },
        );
      }
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white, // ADD THE COLOR YOU WANT AS BACKGROUND.
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
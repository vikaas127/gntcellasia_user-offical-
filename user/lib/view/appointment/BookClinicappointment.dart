import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctro/api/Retrofit_Api.dart';
import 'package:doctro/api/apis.dart';
import 'package:doctro/api/network_api.dart';
import 'package:doctro/model/Appointments.dart';
import 'package:doctro/model/Docterdetail.dart' as ds;
import 'package:doctro/model/Timeslot.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:doctro/models/Plans.dart' as plans;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutterwave/core/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_constants.dart';
import 'package:flutterwave/utils/flutterwave_currency.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../payment/StripePaymentScreen.dart';
import '../../../const/prefConstatnt.dart';
import '../../../const/preference.dart';
import '../../api/base_model.dart';
import '../../api/server_error.dart';
import '../../const/Palette.dart';
import '../../const/app_string.dart';
import '../../localization/localization_constant.dart';
import '../../model/DetailSetting.dart';
import '../../model/apply_offer.dart';
import '../../model/bookappointments.dart';
import '../payment/razorpay_payment.dart';
import 'RecommendedDoctors.dart';
import 'family/addfamily.dart';
import 'family/familymembers.dart';

enum SingingCharacter { Paypal, Razorpay, Stripe, FlutterWave, PayStack, COD }

class BookClinicappointment extends StatefulWidget {
  int? id;

  BookClinicappointment(int? id) {
    this.id = id;
  }

  @override
  _BookClinicappointmentState createState() => _BookClinicappointmentState(id);
}

class _BookClinicappointmentState extends State<BookClinicappointment> {
  bool _loadding = false;

  late PlatformFile file;

  bool isPaymentClicked = false;
  String? Payment_Token = "";

  List<String> reportImages = [];

  // RazorPay //
  static const platform = const MethodChannel("razorpay_flutter");
  late Razorpay _razorpay;

  // PayStack //

  // FlutterWave //
  final String txref = "";
  final String amount = "";
  final String currency = FlutterwaveCurrency.RWF;

  // Detail_Setting & Payment_Detail //
  String? businessname = "";
  String? logo = "";
  String? razorpay_key = "";
  int? cod = 0;
  int? stripe = 0;
  int? paypal = 0;
  int? razor = 0;
  int? flutterwave = 0;
  int? paystack = 0;

  String? user_phoneno = "";
  String? user_email = "";
  String? user_name = "";

  // Payment count //
  SingingCharacter? _character;
  int? selectedRadio;
  late var str;
  var parts;
  var paymenttype;
  var start_part;

  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  String? selectTime = "";

  String? name = "";
  String? expertise = "";
  String? appointmentFees = "app";
  dynamic newAppointmentFees = 100.0;
  String? experience = "";
  dynamic rate = 0;
  String? desc = "";
  String education = "";
  String certificate = "";
  String? fullImage = "";
  String? treatmentname = "";
  String? hospitalName = "";
  String? hospitalAddress = "";

  List<ds.Hosiptal> hosiptal = [];
  List<Hospital> hosiptalGallery = [];

  TextEditingController appointment_for = TextEditingController();
  TextEditingController patient_name = TextEditingController();
  TextEditingController illness_information = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController patient_address = TextEditingController();
  TextEditingController phone_no = TextEditingController();
  TextEditingController drug_effect = TextEditingController();
  TextEditingController note = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController payment_status = TextEditingController();

  TextEditingController _Offer = TextEditingController();

  String reportImage = "";
  String reportImage1 = "";
  String reportImage2 = "";

  final picker = ImagePicker();

  List<Slot> timelist = [];



  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();




  List<String> AppointmentFor = [];
  String? Select_Appointmentfor;

  List<String> Drugeffects = [];
  String? Select_Drugeffects;

  int? id = 0;
  String New_Date = "";
  String New_Dateuser = "";

  String pass_BookDate = "";
  String pass_BookTime = "";
  String pass_BookID = "";

  String? Booking_Id = "";

  //Discount //
  String discountType = "";
  int? isFlat = 0;
  int? flatDiscount = 0;
  int? discount = 0;
  int? minDiscount = 0;
  DateTime? todayDate;
  double prAmount = 0;
List<plans.Data> _plist=[];
  _BookClinicappointmentState(int? id) {
    this.id = id;
  }

  _getdetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        user_phoneno = prefs.getString('phone_no');
        user_email = prefs.getString('email');
        user_name = prefs.getString('name');
      },
    );
  }
  Future<BaseModel<plans.Plans>> callforPlans() async {
    plans.Plans response;
    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api().Dio_Data()).showPlans();
      _plist.clear();
      if (response.status == 200) {
        setState(() {
          _loadding = false;
          _plist.addAll(response.data!);
        });
      }
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }



  var publicKey = SharedPreferenceHelper.getString(Preferences.payStack_public_key);
  final plugin = PaystackPlugin();
  String? paymentToken = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _doctordetail();
    _getdetail();
    selectedRadio = 0;

    callforPlans();
    Future.delayed(Duration.zero, () {
      AppointmentFor = [
        getTranslated(context, bookAppointment_mySelf).toString(),
        getTranslated(context, bookAppointment_patient).toString()
      ];
      Drugeffects = [getTranslated(context, Yes).toString(), getTranslated(context, No).toString()];
    });


  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  // RazorPay Clear //
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
  Map<String, bool> values = {
    'Pay Online': true,
    'Pay at Clinic': false,
  };

  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(width, size.height * 0.12),
          child: Container( decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/intro_header.png"),
              fit: BoxFit.cover,
            ),
          ),
            child: Column(
              children: [
                SafeArea(

                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0,right: 20,top: 30),
                          child: Container(


                            child: GestureDetector(
                              child: Icon(Icons.arrow_back_ios_outlined,size: 24,),
                              onTap: () {
                                setState(() {
                                  Navigator.pop(context);
                                });


                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: 6,
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(width: 50,
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [SizedBox(height: 20,),
                                    Container(
                                      width: width * 0.12,
                                      height: width * 0.12,
                                      child: CachedNetworkImage(
                                        alignment: Alignment.center,
                                        imageUrl: '${Apis.baseUrlImages}$fullImage',
                                        imageBuilder: (context, imageProvider) => CircleAvatar(
                                          radius: 45,
                                          backgroundColor: Palette.image_circle,
                                          child: CircleAvatar(
                                            radius: 45,
                                            backgroundImage: imageProvider,
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            SpinKitPulse(color: Palette.primary),
                                        errorWidget: (context, url, error) =>ClipRRect(
                                          borderRadius: BorderRadius.circular(28.0),
                                          child:
                                            Image.asset("assets/images/nodoctor.png"),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(width: 160,
                                    alignment: AlignmentDirectional.topStart,
                                    child: Column(
                                      children: [
                                        Text(
                                          '${hospitalName?.toUpperCase()}',
                                          style: TextStyle(
                                              fontSize: width * 0.027, color: Palette.dark_blue),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(width: 160,
                                    alignment: AlignmentDirectional.topStart,
                                    margin: EdgeInsets.only(top: width * 0.01),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${name?.toUpperCase()}',
                                          style: TextStyle(fontWeight: FontWeight.bold,
                                              fontSize: width * 0.028, color: Palette.black),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(width: 160,
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: width * 0.01),
                                          child: Column(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/location1.svg',
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(

                                          alignment: AlignmentDirectional.topStart,
                                          margin: EdgeInsets.only(top: width * 0.01, left: width * 0.02,right: width * 0.02),
                                          child: Column(
                                            children: [
                                              Text(
                                                '$hospitalAddress',
                                                style: TextStyle(
                                                  fontSize: width * 0.03,
                                                  color: Palette.grey,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),

                            ],
                          ),

                      ),


                    ],
                  ),
                ),
                Divider(thickness: 2,)
              ],
            ),
          ),
        ),
        body: ModalProgressHUD(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
            child: Container(
              child: Form(
                key: _formkey,
                child: ListView(scrollDirection: Axis.vertical,shrinkWrap: true,
               //   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      height: width * 0.38,
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
                                              child: fullImage!=null ?CachedNetworkImage(
                                                alignment: Alignment.center,
                                                imageUrl:'${Apis.baseUrlImages}$fullImage'

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
                                          hospitalName!,
                                          textAlign: TextAlign.left, style: TextStyle(
                                            color: Color.fromRGBO(9, 44, 76, 1),
                                            fontFamily: 'Open Sans',
                                            fontSize: 17,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.bold,
                                            height: 1),
                                        ),
                                      ),
                                     Row(
                                        children: [
                                          Text(
                                              name.toString(),
                                              textAlign: TextAlign.left, style: TextStyle(
                                                color: Color.fromRGBO(103, 123, 138, 1),
                                                fontFamily: 'Open Sans',
                                                fontSize: 12,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.normal,
                                              )),
                                          Text(
                                              name
                                                  .toString(),
                                              textAlign: TextAlign.left, style: TextStyle(
                                            color: Color.fromRGBO(103, 123, 138, 1),
                                            fontFamily: 'Open Sans',
                                            fontSize: 12,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.normal,
                                          )),
                                        ],
                                      ),



                                      Text(
                                        name
                                            .toString(),
                                        style: TextStyle(
                                            color: Color.fromRGBO(9, 44, 76, 1),
                                            fontFamily: 'Open Sans',
                                            fontSize: 12,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.normal,
                                            height: 1
                                        ),
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
                                                      textAlign: TextAlign.left, style: TextStyle(
                                                        color: Color.fromRGBO(103, 123, 138, 1),
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 12,
                                                        letterSpacing: 0,
                                                        fontWeight: FontWeight.normal,
                                                        height: 1
                                                    ),),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      '8  ' +
                                                          getTranslated(context, doctorDetail_year).toString(),
                                                      textAlign: TextAlign.left, style: TextStyle(
                                                        color: Color.fromRGBO(103, 123, 138, 1),
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 14,
                                                        letterSpacing: 0,
                                                        fontWeight: FontWeight.bold,
                                                        height: 1
                                                    ),
                                                    ),
                                                  ),],
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
                                                      textAlign: TextAlign.left, style: TextStyle(
                                                        color: Color.fromRGBO(103, 123, 138, 1),
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 12,
                                                        letterSpacing: 0,
                                                        fontWeight: FontWeight.normal,
                                                        height: 1),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      SharedPreferenceHelper.getString(Preferences.currency_symbol).toString() + 'Fees',
                                                      textAlign: TextAlign.left, style: TextStyle(
                                                        color: Color.fromRGBO(103, 123, 138, 1),
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 14,
                                                        letterSpacing: 0,
                                                        fontWeight: FontWeight.bold,
                                                        height: 1),
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
                                                      textAlign: TextAlign.left, style: TextStyle(
                                                        color: Color.fromRGBO(103, 123, 138, 1),
                                                        fontFamily: 'Open Sans',
                                                        fontSize: 12,
                                                        letterSpacing: 0,
                                                        fontWeight: FontWeight.normal,
                                                        height: 1
                                                    ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Text('Fees',
                                                      textAlign: TextAlign.left, style: TextStyle(
                                                          color: Color.fromRGBO(103, 123, 138, 1),
                                                          fontFamily: 'Open Sans',
                                                          fontSize: 12,

                                                          letterSpacing: 0,
                                                          fontWeight: FontWeight.bold,
                                                          height: 1),
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

                          ],
                        ),
                      ),
                    ),

                 Divider(height: 1,),
                 //Clinic Detail
                    Card(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(child:
                      Column(
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/hospital.svg',
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("In Clinic Appointment time"),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Today , 2:00 PM",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("in 5 hours 50 mintues "),
                              ),
                            ],
                          ),
                          Row(
                            children: [

                              Text("Kasper Multispeciality Clinic , Noida",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("GentCellAsia",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Palette.primary)),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text("Appointment confirmed instantly",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 13,color: Palette.black)),
                              )
                            ],
                          ),
                          SizedBox(height: 20,),

                        ],
                      ),),
                    ),),
                 //Offer
                    Card(
                      child: Container( height: 100,
                        decoration:BoxDecoration(
                          border: Border.all(
                              width: 1.0
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(5.0) //                 <--- border radius here
                          ),
                        ),
                        child:Row(
                          children: [
                            //assets/icons/call.svg
                            Expanded(flex:1,
                              child:Image .asset(
                                'assets/images/offer.png',height: 40,width: 40,
                              ),
                            ),
                            Expanded(flex: 4,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Apply Coupon Code",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Palette.black)),
                                  Text("Unlock offers with coupon codes"),
                                ],
                              ),
                            ),
                            Expanded(flex:2,
                                child: Text("Apply ",style: TextStyle(fontSize: 20),)
                            ),
                          ],
                        ) ,),
                    ),
                  //  offers
                    Card(
                      child: Container( height: 100,
                        decoration:BoxDecoration(
                          border: Border.all(
                              width: 1.0
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(5.0) //                 <--- border radius here
                          ),
                        ),
                        child:Row(
                          children: [
                            //assets/icons/call.svg
                            Expanded(flex:1,
                              child: SvgPicture.asset(
                                'assets/icons/profile.svg',
                              ),
                            ),
                            Expanded(flex: 4,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Appointment for",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Palette.black)),
                                  Text("Vikas Yadav"),
                                ],
                              ),
                            ),
                            Expanded(flex:2,
                                child: Text("Change ",style: TextStyle(fontSize: 20),)
                            ),
                          ],
                        ) ,),
                    ),
                    Divider(thickness: 1.5,),
                    Card(
                      child: ListView(shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: values.keys.map((String key) {
                          return new CheckboxListTile(
                            title: new Text(key,style: TextStyle(fontSize: 15,color: Colors.black),),
                            value: values[key],
                            onChanged: (bool ?value) {
                              setState(() {
                                values[key] = value!;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),



                  ],
                ),
              ),
            ),
          ),
          inAsyncCall: _loadding,
          opacity: 0.5,
          progressIndicator: CircularProgressIndicator(),
        ),
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
                          Text('1000',
                            style: TextStyle(fontSize: width * 0.035, color: Palette.black,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text('View Bill',
                            style: TextStyle(fontSize: width * 0.025, color: Palette.black,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),

                    ),
                    Expanded(flex: 1,
                      child: ElevatedButton(

                        child: Text(
                          " Pay & Confirm ",
                          style: TextStyle(fontSize: width * 0.03, color: Palette.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          setState(
                                  () {
                                    Navigator.push(
                                        context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => RazorpayPayment(
                                    email: "vikas090497@gmail.com",

                                    apiKey: "rzp_test_hq1R5eUC8jskkB",
                                    secretKey: "2aRGphmV230dyP1ZXRCDw97W",

                                    currency: currency ?? "INR",
                                    grandTotal: 2000,
                                    cartId: "2",
                                  ),
                                ));

                                //  openCheckout_razorpay();
                                print('Razorpay');
                              }

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

  filePicker() async {
    String reportImage;
    File _Proimage;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      file = result.files.first;
    } else {
      // User canceled the picker
      print('User canceled the picker');
    }
  }
  Future<BaseModel<Bookappointments>> CallApiBook() async {
    Bookappointments response;
    Map<String, dynamic> body = {
      "appointment_for": Select_Appointmentfor,
      "patient_name": patient_name.text,
      "illness_information": illness_information.text,
      "age": age.text,
      "patient_address": patient_address.text,
      "phone_no": phone_no.text,
      "drug_effect": Select_Drugeffects,
      "note": note.text,
      "date": New_Date,
      "time": selectTime,
      "payment_type": paymenttype,
      "payment_status": _character!.index == 5 ? 0 : 1,
      "payment_token": _character!.index == 5 ? "" : Payment_Token,
      "amount": newAppointmentFees != 0.0 ? newAppointmentFees.toString() : appointmentFees,
      "doctor_id": id,
      "report_image": reportImages.length != 0 ? reportImages : "",
    };
    setState(() {
      Preferences.onLoading(context);
    });
    try {
      response = await RestClient(Retro_Api().Dio_Data()).bookappointment(body);
      if (response.success == true) {
        // Navigator.pushNamed(context, "Appointment");
        setState(() {
          Preferences.hideDialog(context);
          Booking_Id = response.data;

          Fluttertoast.showToast(
            msg: '${response.msg}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );

          Navigator.pushReplacementNamed(context, 'BookSuccess');
        });
      } else {
        Preferences.hideDialog(context);
      }
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }


  bool checkPaymentIsSuccessful(final ChargeResponse response) {
    Payment_Token = response.data!.flwRef;
    Payment_Token != "" && Payment_Token!.isNotEmpty
        ? CallApiBook()
        : Fluttertoast.showToast(msg: getTranslated(context, bookAppointment_paymentNotComplete_toast).toString(), toastLength: Toast.LENGTH_SHORT);
    return response.data!.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data!.currency == this.currency &&
        response.data!.amount == this.amount &&
        response.data!.txRef == this.txref;
  }
  // PayStack //
  payStackFunction() async {
    var amountToPaystack = "$newAppointmentFees" != "0.0"
        ? num.parse('$newAppointmentFees') * 100
        : num.parse('$appointmentFees') * 100;
    Charge charge = Charge()
      ..amount = amountToPaystack as int
      ..reference = _getReference()
      ..currency = SharedPreferenceHelper.getString(Preferences.currency_code)
          // "ZAR"
      ..email = '$user_email';
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );
    if (response.status == true) {
      Payment_Token = response.reference;
      Payment_Token != "" && Payment_Token!.isNotEmpty
          ? CallApiBook()
          : Fluttertoast.showToast(msg: getTranslated(context, bookAppointment_paymentNotComplete_toast).toString(), toastLength: Toast.LENGTH_SHORT);
      setState(() {
        paymentToken = response.reference;
      });
    } else {
      print('error');
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }






  // Call Doctor Detail Api //
  Future<BaseModel<ds.Doctordetails>> _doctordetail() async {
    ds.Doctordetails response;
    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api().Dio_Data()).doctoedetailRequest(id);
      if (response.status == 200) {
        setState(() {
          _loadding = false;
          name = response.data!.doctor![0].name;
          rate = response.data!.doctor![0].title;
          experience = response.data!.doctor![0].workExperience;
          appointmentFees = response.data!.doctor![0].title;
          desc = response.data!.doctor![0].description;
         // expertise = response.data!.doctor![0].expertise!.name;
          fullImage = response.data!.doctor![0].photo;
          treatmentname = response.data!.treatmentdata!.name;
          hosiptal.addAll(response.data!.hosiptal!);
         /* for (int i = 0; i < hosiptal.length; i++) {
            hospitalName = response.data!.hosiptal![i].name;
            hospitalAddress = response.data!.hosiptal![i].address;
          }*/
         // hosiptalGallery.addAll(response.data!.hosiptal![0].hospitalGallery!);
        });
      }
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
  Future<BaseModel<DetailSetting>> _detailsetting() async {
    DetailSetting response;

    try {
      response = await RestClient(Retro_Api().Dio_Data()).detailsettingRequest();
      if (response.success == true) {
        razorpay_key = response.data!.razorKey;
        businessname = response.data!.businessName;
        logo = response.data!.logo;
        cod = response.data!.cod;
        stripe = response.data!.stripe;
        paypal = response.data!.paypal;
        flutterwave = response.data!.flutterwave;
        razor = response.data!.razor;
        paystack = response.data!.paystack;
      }
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }
  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }





  //  Offer //


  Future<BaseModel<ApplyOffer>> CallApiApplyOffer() async {
    ApplyOffer response;
    var offerDateToday = "$todayDate";
    String offerDate = DateUtilforpass().formattedDate(DateTime.parse(offerDateToday));
    Map<String, dynamic> body = {
      "offer_code": _Offer.text,
      "date": offerDate,
      "doctor_id": id,
      "from": "appointment",
    };
    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api().Dio_Data()).applyOfferRequest(body);
      if (response.success == true) {
        setState(() {
          _loadding = false;
          discountType = response.data!.discountType!.toUpperCase();
          flatDiscount = response.data!.flatDiscount;
          isFlat = response.data!.isFlat;
          minDiscount = response.data!.minDiscount;
          discount = response.data!.discount;

          if (discountType == "AMOUNT" && isFlat == 1) {
            if (int.parse('$appointmentFees') > flatDiscount!) {
              if (flatDiscount! < minDiscount!) {
                newAppointmentFees = int.parse('$appointmentFees') - int.parse('$flatDiscount');
              } else {
                newAppointmentFees = int.parse('$appointmentFees') - int.parse('$minDiscount');
              }
              Fluttertoast.showToast(
                msg: getTranslated(context, bookAppointment_offerApply_toast).toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
              );
            } else {
              Fluttertoast.showToast(
                msg: getTranslated(context, bookAppointment_worthMore_toast).toString() + SharedPreferenceHelper.getString(Preferences.currency_symbol).toString() + '$flatDiscount.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
              );
            }
          } else if (discountType == "AMOUNT" && isFlat == 0) {
            if (int.parse('$appointmentFees') > discount!) {
              if (discount! < minDiscount!) {
                newAppointmentFees = int.parse('$appointmentFees') - int.parse('$discount');
              } else {
                newAppointmentFees = int.parse('$appointmentFees') - int.parse('$minDiscount');
              }
              Fluttertoast.showToast(
                msg: getTranslated(context, bookAppointment_offerApply_toast).toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
              );
            } else {
              Fluttertoast.showToast(
                msg: getTranslated(context, bookAppointment_worthMore_toast).toString() + SharedPreferenceHelper.getString(Preferences.currency_symbol).toString() + '$discount.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
              );
            }
          } else if (discountType == "PERCENTAGE") {
            setState(() {
              prAmount = (int.parse('$appointmentFees') * int.parse('$discount')) / 100;
              if (prAmount <= minDiscount!) {
                newAppointmentFees = double.parse('$appointmentFees') - double.parse('$prAmount');
              } else {
                newAppointmentFees =
                    double.parse('$appointmentFees') - double.parse('$minDiscount');
              }
            });
            Fluttertoast.showToast(
              msg: int.parse('$appointmentFees') >= prAmount ||
                  int.parse('$appointmentFees') >= minDiscount!
                  ? getTranslated(context, bookAppointment_offerApply_toast).toString()
                  : getTranslated(context, bookAppointment_itemWorth_toast).toString() + '$prAmount' + getTranslated(context, bookAppointment_orMore_toast).toString(),
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
            );
            newAppointmentFees = int.parse('$appointmentFees') >= prAmount ||
                int.parse('$appointmentFees') >= minDiscount!
                ? newAppointmentFees
                : appointmentFees;
          }
        });
      } else {
        setState(() {
          _loadding = false;
          Fluttertoast.showToast(
            msg: '${response.msg}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        });
      }
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }




}


// Date Format pass Api
class DateUtilforpass {
  static const DATE_FORMAT = 'yyyy-MM-dd';

  String formattedDate(DateTime dateTime) {
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

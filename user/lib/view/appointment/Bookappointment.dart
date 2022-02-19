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
import 'RecommendedDoctors.dart';
import 'family/addfamily.dart';
import 'family/familymembers.dart';

enum SingingCharacter { Paypal, Razorpay, Stripe, FlutterWave, PayStack, COD }

class Bookappointment extends StatefulWidget {
  int? id;

  Bookappointment(int? id) {
    this.id = id;
  }

  @override
  _BookappointmentState createState() => _BookappointmentState(id);
}

class _BookappointmentState extends State<Bookappointment> {
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
  String? appointmentFees = "";
  dynamic newAppointmentFees = 0.0;
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
  File? _Proimage;
  File? _Proimage1;
  File? _Proimage2;
  final picker = ImagePicker();

  List<Slots> timelist = [];

  DateTime? _selectedDate;
  late DateTime _firstTimeSelected;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _Step1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _Step2 = GlobalKey<FormState>();

  final GlobalKey<FormState> _offerFormKey = GlobalKey<FormState>();

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
  _BookappointmentState(int? id) {
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

  _pass_DateTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        pass_BookDate = '$New_Dateuser';
        pass_BookTime = '$selectTime';
        pass_BookID = '$Booking_Id';
        prefs.setString('BookDate', pass_BookDate);
        prefs.setString('BookTime', pass_BookTime);
        prefs.setString('BookID', pass_BookID);
      },
    );
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
   // _detailsetting();
    callforPlans();
    Future.delayed(Duration.zero, () {
      AppointmentFor = [
        getTranslated(context, bookAppointment_mySelf).toString(),
        getTranslated(context, bookAppointment_patient).toString()
      ];
      Drugeffects = [getTranslated(context, Yes).toString(), getTranslated(context, No).toString()];
    });

    // RazorPay //
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // PayStack //
    plugin.initialize(
        publicKey: SharedPreferenceHelper.getString(Preferences.payStack_public_key)!);
    todayDate = DateTime.now();
    _firstTimeSelected = DateTime.now();
    date
      ..text = DateFormat('dd-MM-yyyy').format(_firstTimeSelected)
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: date.text.length, affinity: TextAffinity.upstream),
      );
    var temp = '$_firstTimeSelected';
    // Date Formate  dispaly user
    New_Dateuser = DateUtil().formattedDate(DateTime.parse(temp));
    // // Date Formate pass Api
    New_Date = DateUtilforpass().formattedDate(DateTime.parse(temp));

    date.text = New_Dateuser;

    setState(() {
      TimeSlot();
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
                      Expanded(flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0,right: 8,top: 30),
                          child: Container(


                            child: GestureDetector(
                              child: Icon(Icons.arrow_back),
                              onTap: () {
                                Navigator.pop(context);

                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: 7,
                        child: Container(

                          child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [SizedBox(height: 20,),
                                    Container(
                                      width: width * 0.12,
                                      height: width * 0.12,
                                      child: CachedNetworkImage(
                                        alignment: Alignment.center,
                                        imageUrl: '${Apis.baseUrl}$fullImage',
                                        imageBuilder: (context, imageProvider) => CircleAvatar(
                                          radius: 45,
                                          backgroundColor: Palette.image_circle,
                                          child: CircleAvatar(
                                            radius: 45,
                                            backgroundImage: imageProvider,
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            SpinKitPulse(color: Palette.blue),
                                        errorWidget: (context, url, error) =>ClipRRect(
                                          borderRadius: BorderRadius.circular(28.0),
                                          child:
                                            Image.asset("assets/images/no_image.jpg"),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                                child: Container(


                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
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
                                      Container(
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
                                      Container(
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
                                              width: width * 0.5,
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
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      Expanded(flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0,right: 10),
                          child: SvgPicture.asset(
                            'assets/icons/call.svg',
                            height: 30.0,
                            width: 30.0,
                            allowDrawingOutsideViewBox: true,
                          ),
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
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text('Book a video consultation for',style: Theme.of(context).textTheme.headline1)),
                    Container(height: 103,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 18.0,bottom: 40,right: 5),
                            child: Container(height: 114,
                              child: InkWell(onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddFamilymember(

                                    ),
                                  ),
                                );
                              },
                                child: Container( child:SvgPicture.asset(
                                  'assets/icons/addmember.svg',
                                  height: 60.0,
                                  width: 60.0,
                                  allowDrawingOutsideViewBox: true,
                                ),),
                              ),
                            ),
                          ),
                          Container(height: 103,width: width-110, child: Familymembers( )),
                        ],
                      ),
                    ),
                    Divider(thickness: 1.5,),
                    DatePicker(
                      DateTime.now(),
                      height:54,width:100,
                      dayTextStyle:TextStyle(fontSize: 0) ,
                      dateTextStyle: TextStyle(fontSize: 12),
                      initialSelectedDate: DateTime.now(),
                      selectionColor: Color(0xff2C9085),
                      selectedTextColor: Colors.white,
                      deactivatedColor: Colors.black12,
                      onDateChange: (date) {

                        // New date selected
                        setState(() {
                          New_Date = DateUtilforpass().formattedDate(date);
                          TimeSlot();
                        });
                      },
                    ),
                    Divider(thickness: 1.5,),
                    Container(height: height*0.44,
                      child: ListView(shrinkWrap: true,

                        scrollDirection: Axis.vertical,
                        children: [

                          /*     Container(
                              height: width * 0.1,
                              width: width * 1,
                              margin: EdgeInsets.only(top: width * 0.02),
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Palette.dash_line,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: TextFormField(
                                  focusNode: AlwaysDisabledFocusNode(),
                                  controller: date,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: getTranslated(context, bookAppointment_appointmentDate_hint).toString(),
                                    hintStyle: TextStyle(
                                        fontSize: width * 0.038, color: Palette.dark_blue),
                                  ),
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return getTranslated(context, bookAppointment_appointmentDate_validator).toString();
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),*/
                          // // if(date.text != null)
                          Container(height: 40,width: width,

                            child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/icons/img.png',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Morning",style: Theme.of(context).textTheme.headline1,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("(8.00 to 11.59)",style: Theme.of(context).textTheme.headline3,),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: 0 < timelist.length
                                ? Column(
                              children: [
                                /*  Container(
                                    alignment: AlignmentDirectional.center,
                                    margin: EdgeInsets.only(top: width * 0.05),
                                    child: Column(
                                      children: [
                                        Text(
                                          getTranslated(context, bookAppointment_appointmentTime_title).toString(),
                                          style: TextStyle(
                                              fontSize: width * 0.04,
                                              color: Palette.dark_blue),
                                        )
                                      ],
                                    ),
                                  ),*/
                                Container(
                                  margin: EdgeInsets.only(top: width * 0.04),
                                  child: GridView.builder(
                                    itemCount: timelist.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                      crossAxisCount: 3,
                                      childAspectRatio: 2.2,
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
                                              height: 50,
                                              width: width * 0.3,
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
                                                                : Color(0xff2C9085)),
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
                        ],
                      ),
                    ),
                 /*  Expanded(
                      child:
                     *//* Stepper(
                        type: stepperType,
                        physics: ScrollPhysics(),
                        onStepCancel: null,
                        currentStep: _currentStep,
                        onStepTapped: (step) => tapped(step),
                        onStepContinue: continued,
                        steps: <Step>[


                          // Step 2 //


                          // Step 3 //
                         *//**//* Step(
                            title: new Text(
                                getTranslated(context, bookAppointment_payment_title).toString(),
                            ),
                            content: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).requestFocus(new FocusNode());
                              },
                              child: Container(
                                height: height /1.5,
                                width: MediaQuery.of(context).size.width,
                                child: ListView(
                                  shrinkWrap: false,
                                  scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    Form(
                                      key: _offerFormKey,
                                      child: Container(
                                        height: height * 0.1,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: width * 0.5,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: width * 0.03),
                                              padding:
                                                  EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                                              decoration: BoxDecoration(
                                                  color: Palette.dark_white,
                                                  borderRadius: BorderRadius.circular(10)),
                                              child: TextFormField(
                                                controller: _Offer,
                                                keyboardType: TextInputType.text,
                                                textCapitalization: TextCapitalization.words,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(
                                                      RegExp('[a-zA-Z0-9]'))
                                                ],
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: getTranslated(context, bookAppointment_offerCode_hint).toString(),
                                                  hintStyle: TextStyle(
                                                    fontSize: width * 0.04,
                                                    color: Palette.dark_grey,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                validator: (String? value) {
                                                  if (value!.isEmpty) {
                                                    return getTranslated(context, bookAppointment_offerCode_validator).toString();
                                                  }
                                                  return null;
                                                },
                                                onSaved: (String? name) {},
                                              ),
                                            ),
                                            Container(
                                              width: width * 0.3,
                                              height: height * 0.05,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: width * 0.03),
                                              padding:
                                                  EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (_offerFormKey.currentState!.validate()) {
                                                    CallApiApplyOffer();
                                                  }
                                                },
                                                child: Text(
                                                    getTranslated(context, bookAppointment_apply_button).toString(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        paypal == 1
                                            ? Container(
                                                margin: EdgeInsets.all(5),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Palette.dark_grey.withOpacity(0.2),
                                                        spreadRadius: 2,
                                                        blurRadius: 7,
                                                        offset: Offset(
                                                            0, 3), // changes position of shadow
                                                      ),
                                                    ],
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Palette.white),
                                                height: MediaQuery.of(context).size.height * 0.08,

                                                child: RadioListTile<SingingCharacter>(
                                                  controlAffinity: ListTileControlAffinity.trailing,

                                                  title: Container(
                                                    width: MediaQuery.of(context).size.width / 5,

                                                    child: Row(
                                                      children: [
                                                        Image.network(
                                                          "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/PayPal_Logo_Icon_2014.svg/1200px-PayPal_Logo_Icon_2014.svg.png",
                                                          height: 30,
                                                          width: 50,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width *
                                                              0.01,
                                                        ),
                                                        Text(
                                                          'PayPal',
                                                          style: TextStyle(
                                                              fontSize: 16, color: Palette.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  value: SingingCharacter.Paypal,
                                                  activeColor: Palette.black,
                                                  groupValue: _character,
                                                  onChanged: (SingingCharacter? value) {
                                                    setState(() {
                                                      _character = value;
                                                      isPaymentClicked = true;
                                                    });
                                                  },
                                                ),
                                              )
                                            : Container(),
                                        razor == 1
                                            ? Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Palette.dark_grey.withOpacity(0.2),
                                                        spreadRadius: 2,
                                                        blurRadius: 7,
                                                        offset: Offset(
                                                            0, 3), // changes position of shadow
                                                      ),
                                                    ],
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Palette.white),
                                                height: MediaQuery.of(context).size.height * 0.08,
                                                // width: MediaQuery.of(context).size.width / 2.2,
                                                child: RadioListTile<SingingCharacter>(
                                                  controlAffinity: ListTileControlAffinity.trailing,
                                                  // contentPadding: EdgeInsets.only(left: 10),
                                                  title: Container(
                                                    width: MediaQuery.of(context).size.width / 5,
                                                    child: Row(
                                                      children: [
                                                        Image.network(
                                                          "https://avatars.githubusercontent.com/u/7713209?s=280&v=4",
                                                          height: 30,
                                                          width: 50,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width *
                                                              0.01,
                                                        ),
                                                        Text('RazorPay',
                                                            style: TextStyle(
                                                                fontSize: 16, color: Palette.black)),
                                                      ],
                                                    ),
                                                  ),
                                                  value: SingingCharacter.Razorpay,
                                                  activeColor: Palette.black,
                                                  groupValue: _character,
                                                  onChanged: (SingingCharacter? value) {
                                                    setState(
                                                      () {
                                                        _character = value;
                                                        isPaymentClicked = true;
                                                      },
                                                    );
                                                  },
                                                ),
                                              )
                                            : Container(),
                                        stripe == 1
                                            ? Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Palette.grey.withOpacity(0.2),
                                                        spreadRadius: 2,
                                                        blurRadius: 7,
                                                        offset: Offset(
                                                            0, 3), // changes position of shadow
                                                      ),
                                                    ],
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Palette.white),
                                                height: MediaQuery.of(context).size.height * 0.08,
                                                // width: MediaQuery.of(context).size.width / 2.2,
                                                child: RadioListTile<SingingCharacter>(
                                                  controlAffinity: ListTileControlAffinity.trailing,
                                                  // contentPadding: EdgeInsets.only(left: 10),
                                                  title: Container(
                                                    width: MediaQuery.of(context).size.width / 5,
                                                    child: Row(
                                                      children: [
                                                        Image.network(
                                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3PGzfbaZZzR0j8rOWBjWJPGWnkPzkm12f5A&usqp=CAU",
                                                          height: 30,
                                                          width: 50,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width *
                                                              0.01,
                                                        ),
                                                        Text('Stripe',
                                                            style: TextStyle(
                                                                fontSize: 16, color: Palette.black)),
                                                      ],
                                                    ),
                                                  ),
                                                  value: SingingCharacter.Stripe,
                                                  activeColor: Palette.black,
                                                  groupValue: _character,
                                                  onChanged: (SingingCharacter? value) {
                                                    setState(() {
                                                      _character = value;
                                                      isPaymentClicked = true;
                                                    });
                                                  },
                                                ))
                                            : Container(),
                                        flutterwave == 1
                                            ? Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Palette.dark_grey.withOpacity(0.2),
                                                        spreadRadius: 2,
                                                        blurRadius: 7,
                                                        offset: Offset(
                                                            0, 3), // changes position of shadow
                                                      ),
                                                    ],
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Palette.white),
                                                height: MediaQuery.of(context).size.height * 0.08,
                                                // width: MediaQuery.of(context).size.width / 2.2,
                                                child: RadioListTile<SingingCharacter>(
                                                  controlAffinity: ListTileControlAffinity.trailing,
                                                  // contentPadding: EdgeInsets.only(left: 10),
                                                  title: Container(
                                                    width: MediaQuery.of(context).size.width / 5,
                                                    // color: Colors.red,
                                                    child: Row(
                                                      children: [
                                                        Image.network(
                                                          "https://cdn.filestackcontent.com/OITnhSPCSzOuiVvwnH7r",
                                                          height: 30,
                                                          width: 50,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width *
                                                              0.01,
                                                        ),
                                                        Flexible(
                                                          child: Text('Flutterwave',
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                  fontSize: 16, color: Palette.black)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  value: SingingCharacter.FlutterWave,
                                                  activeColor: Palette.black,
                                                  groupValue: _character,
                                                  onChanged: (SingingCharacter? value) {
                                                    setState(() {
                                                      _character = value;
                                                      isPaymentClicked = true;
                                                    });
                                                  },
                                                ))
                                            : Container(),
                                        paystack == 1
                                            ? Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Palette.dark_grey.withOpacity(0.2),
                                                        spreadRadius: 2,
                                                        blurRadius: 7,
                                                        offset: Offset(
                                                            0, 3), // changes position of shadow
                                                      ),
                                                    ],
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Palette.white),
                                                height: MediaQuery.of(context).size.height * 0.08,
                                                // width: MediaQuery.of(context).size.width / 2.2,
                                                child: RadioListTile<SingingCharacter>(
                                                  controlAffinity: ListTileControlAffinity.trailing,
                                                  // contentPadding: EdgeInsets.only(left: 10),
                                                  title: Container(
                                                    width: MediaQuery.of(context).size.width / 5,
                                                    child: Row(
                                                      children: [
                                                        Image.network(
                                                          "https://website-v3-assets.s3.amazonaws.com/assets/img/hero/Paystack-mark-white-twitter.png",
                                                          height: 30,
                                                          width: 50,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(context).size.width *
                                                              0.01,
                                                        ),
                                                        Text('Paystack',
                                                            style: TextStyle(
                                                                fontSize: 16, color: Palette.black)),
                                                      ],
                                                    ),
                                                  ),
                                                  value: SingingCharacter.PayStack,
                                                  activeColor: Palette.black,
                                                  groupValue: _character,
                                                  onChanged: (SingingCharacter? value) {
                                                    setState(() {
                                                      _character = value;
                                                      isPaymentClicked = true;
                                                    });
                                                  },
                                                ),
                                              )
                                            : Container(),
                                        cod == 1
                                            ? Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Palette.dark_grey.withOpacity(0.2),
                                                        spreadRadius: 2,
                                                        blurRadius: 7,
                                                        offset: Offset(
                                                            0, 3), // changes position of shadow
                                                      ),
                                                    ],
                                                    borderRadius: BorderRadius.circular(10),
                                                    color: Palette.white),
                                                height: MediaQuery.of(context).size.height * 0.08,
                                                // width: MediaQuery.of(context).size.width / 2.2,
                                                child: RadioListTile<SingingCharacter>(
                                                  controlAffinity: ListTileControlAffinity.trailing,
                                                  // contentPadding: EdgeInsets.only(left: 10),
                                                  title: Text(
                                                    'COD (Case On Delivery)',
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style:
                                                        TextStyle(fontSize: 16, color: Palette.black),
                                                  ),
                                                  value: SingingCharacter.COD,
                                                  activeColor: Palette.black,
                                                  groupValue: _character,
                                                  onChanged: (SingingCharacter? value) {
                                                    setState(() {
                                                      _character = value;
                                                      isPaymentClicked = true;
                                                    });
                                                  },
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            isActive: _currentStep >= 0,
                            state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
                          ),*//**//*
                        ],
                      *//**//*  controlsBuilder: (BuildContext context, {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(),
                              SizedBox(),
                            ],
                          );
                        },
                      ),*//**//*
                    ),*//*),*/
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
                          Text('SELECTED SLOT',
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
                          "Confirm Appointment",
                          style: TextStyle(fontSize: width * 0.03, color: Palette.white),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
    setState(() {
    showModalBottomSheet(
    context: context,
    builder: (context) {
    return
    Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
    Padding(
    padding: const EdgeInsets.all(4.0),
    child: Container(height: 50,child: ListView(shrinkWrap: true,scrollDirection: Axis.horizontal,
    children: [
    Padding(
    padding: const EdgeInsets.all(4.0),
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
    child: Text("hindi"),
    ) ,),
    ),
    Container(
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
    child: Text("English"),
    ) ,),
    Container(
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
    child: Text("Punjabi"),
    ) ,),
    Container(
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
    child: Text("Tamil"),
    ) ,),
    Container(
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
    child: Text("Telgu"),
    ) ,)

    ],),),
    ),
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
    Text("${_plist[0].name}"),
    Text("${_plist[0].amount}"),
    Text("${_plist[0].name}"),
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
    Text("${_plist[1].name}"),
    Text("${_plist[1].amount}"),
    Text("${_plist[1].name}"),
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
    Text("${_plist[2].name}"),
    Text("${_plist[2].amount}"),
    Text("${_plist[2].name}"),
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
                         /* SharedPreferenceHelper.getBoolean(Preferences.is_logged_in) == true
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
                          );*/


                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      /*  Container(
          height: 50,
          child: RaisedButton(child: Text("Next"),onPressed: (){
            setState(() {
    showModalBottomSheet(
    context: context,
    builder: (context) {
    return
    Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(height: 50,child: ListView(shrinkWrap: true,scrollDirection: Axis.horizontal,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
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
                child: Text("hindi"),
              ) ,),
            ),
            Container(
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
                child: Text("English"),
              ) ,),
            Container(
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
                child: Text("Punjabi"),
              ) ,),
            Container(
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
                child: Text("Tamil"),
              ) ,),
            Container(
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
                child: Text("Telgu"),
              ) ,)

          ],),),
      ),
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
                 Text("${_plist[0].name}"),
                 Text("${_plist[0].amount}"),
                 Text("${_plist[0].name}"),
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
                 Text("${_plist[1].name}"),
                 Text("${_plist[1].amount}"),
                 Text("${_plist[1].name}"),
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
                 Text("${_plist[2].name}"),
                 Text("${_plist[2].amount}"),
                 Text("${_plist[2].name}"),
               ],
             ),
           ) ,),
       ),
     ],),)
    ],
    );
    });




            });
          },)
        */
        /*  ElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentStep == 0)
                  Text(
                    getTranslated(context, bookAppointment_continue_button).toString(),
                    style: TextStyle(fontSize: width * 0.04, color: Palette.white),
                  ),
                if (_currentStep == 1)
                  Text(
                    getTranslated(context, bookAppointment_continue_button).toString(),
                    style: TextStyle(fontSize: width * 0.04, color: Palette.white),
                  ),
                if (_currentStep == 2)
                  '$newAppointmentFees' == "0.0"
                      ? Text(
                    getTranslated(context, bookAppointment_pay_button).toString() + SharedPreferenceHelper.getString(Preferences.currency_symbol).toString() + '$appointmentFees',
                          style: TextStyle(fontSize: width * 0.04, color: Palette.white),
                        )
                      : Text(
                    getTranslated(context, bookAppointment_pay_button).toString() + SharedPreferenceHelper.getString(Preferences.currency_symbol).toString() + '$newAppointmentFees',
                          style: TextStyle(fontSize: width * 0.04, color: Palette.white),
                        )
              ],
            ),
            onPressed: () {
              setState(
                () {
                  if (_currentStep == 0 && _Step1.currentState!.validate()) {
                    continued();
                  } else if (_currentStep == 1 &&
                      date != null &&
                      selectTime != null &&
                      selectTime != "" &&
                      selectTime != "null") {
                    continued();
                  } else if (_currentStep == 2) {
                    str = "$_character";
                    parts = str.split(".");
                    start_part = parts[0].trim();
                    paymenttype = parts.sublist(1).join('.').trim();

                    if (_character!.index == 0) {
                      print('Paypal');
                    } else if (_character!.index == 1) {
                      openCheckout_razorpay();
                      print('Razorpay');
                    } else if (_character!.index == 2) {
                      print('Stripe');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StripePaymentScreen(
                            selectAppointmentFor: Select_Appointmentfor,
                            patientName: patient_name.text,
                            illnessInformation: illness_information.text,
                            age: age.text,
                            patientAddress: patient_address.text,
                            phoneNo: phone_no.text,
                            selectDrugEffects: Select_Drugeffects,
                            note: note.text,
                            newDate: New_Date,
                            selectTime: selectTime,
                            appointmentFees: "$newAppointmentFees" != "0.0"
                                ? '$newAppointmentFees'
                                : '$appointmentFees',
                            doctorId: id,
                            newDateUser: New_Dateuser,
                            reportImages: reportImages,
                          ),
                        ),
                      );
                    } else if (_character!.index == 3) {
                      beginPayment();
                      print('FlutterWave');
                    } else if (_character!.index == 4) {
                      print('PayStack');
                      payStackFunction();
                    } else if (_character!.index == 5) {
                      print('cod');
                      setState(() {
                        CallApiBook();
                      });
                    }
                  }
                },
              );
            },
          ),
          *//*
        ),*/
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
          _pass_DateTime();
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
  // RazorPay Code //
  void openCheckout_razorpay() async {
    var map = {
      'key': SharedPreferenceHelper.getString(Preferences.razor_key),
      'amount': "$newAppointmentFees" != "0.0"
          ? num.parse('$newAppointmentFees') * 100
          : num.parse('$appointmentFees') * 100,
      'name': '$businessname',
      'currency': SharedPreferenceHelper.getString(Preferences.currency_code),
      'image': '$logo',
      'description': '',
      'send_sms_hash': 'true',
      'prefill': {'contact': '$user_phoneno', 'email': '$user_email'},
      'external': {
        'wallets': ['paytm']
      }
    };
    var options = map;

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }
  // RazorPay Success Method //
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);
    // Fluttertoast.showToast(msg: "SUCCESS: ", toastLength: Toast.LENGTH_SHORT);
    Payment_Token = response.paymentId;
    Payment_Token != "" && Payment_Token!.isNotEmpty
        ? CallApiBook()
        : Fluttertoast.showToast(msg: getTranslated(context, bookAppointment_paymentNotComplete_toast).toString(), toastLength: Toast.LENGTH_SHORT);
  }
  // RazorPay Error Method //
  void _handlePaymentError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message,
    //     toastLength: Toast.LENGTH_SHORT);
  }
  // RazorPay Wallet Method //
  void _handleExternalWallet(ExternalWalletResponse response) {
    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: " + response.walletName, toastLength: Toast.LENGTH_SHORT);
  }
  // FlutterWave Code //
  beginPayment() async {
    final Flutterwave flutterwave = Flutterwave.forUIPayment(
      context: this.context,
      encryptionKey: SharedPreferenceHelper.getString(Preferences.flutterWave_encryption_key)!,
      publicKey: SharedPreferenceHelper.getString(Preferences.flutterWave_key)!,
      currency: SharedPreferenceHelper.getString(Preferences.currency_code)!,
      // this.currency,
      amount: "$newAppointmentFees" != "0.0" ? '$newAppointmentFees' : '$appointmentFees',
      email: "$user_email",
      fullName: "$user_name",
      txRef: DateTime.now().toIso8601String(),
      isDebugMode: true,
      phoneNumber: "$user_phoneno",
      acceptCardPayment: true,
      acceptUSSDPayment: false,
      acceptAccountPayment: false,
      acceptFrancophoneMobileMoney: false,
      acceptGhanaPayment: false,
      acceptMpesaPayment: false,
      acceptRwandaMoneyPayment: false,
      acceptUgandaPayment: false,
      acceptZambiaPayment: false,
    );

    try {
      final ChargeResponse response = await flutterwave.initializeForUiPayments();
      if (response == null) {
        // user didn't complete the transaction. Payment wasn't successful.
      } else {
        final isSuccessful = checkPaymentIsSuccessful(response);
        if (isSuccessful) {
          // provide value to customer
        } else {
          // check message
          print("response message ${response.message}");
        }
      }
    } catch (error, stacktrace) {
      // handleError(error);
      print("error is ${stacktrace}");
    }
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

  // Call Doctor Time Api //


  Future<BaseModel<Timeslot>> TimeSlot() async {
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

  // Select Date Method //
  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 366)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: Palette.blue,
              onPrimary: Palette.white,
              surface: Palette.blue,
              onSurface: Palette.black,
            ),
            dialogBackgroundColor: Palette.white,
          ),
          child: child!,
        );
      },
    );
    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      date..text = DateFormat('dd-MM-yyyy').format(_selectedDate!)..selection = TextSelection.fromPosition(
          TextPosition(offset: date.text.length, affinity: TextAffinity.upstream),
        );
      var temp = '$_selectedDate';
      // Date Formate  dispaly user
      New_Dateuser = DateUtil().formattedDate(DateTime.parse(temp));
      // Date Formate pass Api
      New_Date = DateUtilforpass().formattedDate(DateTime.parse(temp));
    }
    TimeSlot();
  }

  // Select Image //
  void _ProimgFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(
      () {
        if (pickedFile != null) {
          SharedPreferenceHelper.setString(Preferences.reportImage, pickedFile.path);
          _Proimage = File(SharedPreferenceHelper.getString(Preferences.reportImage)!);
          List<int> imageBytes = _Proimage!.readAsBytesSync();
          reportImage = base64Encode(imageBytes);
          if (reportImage != null) {
            reportImages.add(reportImage);
          }
        } else {
          print('No image selected.');
        }
      },
    );
  }

  void _ProimgFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        SharedPreferenceHelper.setString(Preferences.reportImage, pickedFile.path);
        _Proimage = _Proimage = File(SharedPreferenceHelper.getString(Preferences.reportImage)!);
        List<int> imageBytes = _Proimage!.readAsBytesSync();
        reportImage = base64Encode(imageBytes);
        if (reportImage != null) {
          reportImages.add(reportImage);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  // Select Image1 //
  void _ProimgFromGallery1() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(
      () {
        if (pickedFile != null) {
          SharedPreferenceHelper.setString(Preferences.reportImage1, pickedFile.path);
          _Proimage1 = File(SharedPreferenceHelper.getString(Preferences.reportImage1)!);
          List<int> imageBytes = _Proimage1!.readAsBytesSync();
          reportImage1 = base64Encode(imageBytes);
          if (reportImage1 != null) {
            reportImages.add(reportImage1);
          }
        } else {
          print('No image selected.');
        }
      },
    );
  }

  void _ProimgFromCamera1() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        SharedPreferenceHelper.setString(Preferences.reportImage1, pickedFile.path);
        _Proimage1 = _Proimage1 = File(SharedPreferenceHelper.getString(Preferences.reportImage1)!);
        List<int> imageBytes = _Proimage1!.readAsBytesSync();
        reportImage1 = base64Encode(imageBytes);
        if (reportImage1 != null) {
          reportImages.add(reportImage1);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  // Select Image2 //
  void _ProimgFromGallery2() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(
      () {
        if (pickedFile != null) {
          SharedPreferenceHelper.setString(Preferences.reportImage2, pickedFile.path);
          _Proimage2 = File(SharedPreferenceHelper.getString(Preferences.reportImage2)!);
          List<int> imageBytes = _Proimage2!.readAsBytesSync();
          reportImage2 = base64Encode(imageBytes);
          if (reportImage2 != null) {
            reportImages.add(reportImage2);
          }
        } else {
          print('No image selected.');
        }
      },
    );
  }

  void _ProimgFromCamera2() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        SharedPreferenceHelper.setString(Preferences.reportImage2, pickedFile.path);
        _Proimage2 = _Proimage2 = File(SharedPreferenceHelper.getString(Preferences.reportImage2)!);
        List<int> imageBytes = _Proimage2!.readAsBytesSync();
        reportImage2 = base64Encode(imageBytes);
        if (reportImage2 != null) {
          reportImages.add(reportImage2);
        }
      } else {
        print('No image selected.');
      }
    });
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

  // Image Function //
  void _ChooseProfileImage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(
                      getTranslated(context, fromGallery).toString(),
                    ),
                    onTap: () {
                      _ProimgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    getTranslated(context, fromCamera).toString(),
                  ),
                  onTap: () {
                    _ProimgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _ChooseProfileImage1() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(
                      getTranslated(context, fromGallery).toString(),
                    ),
                    onTap: () {
                      _ProimgFromGallery1();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    getTranslated(context, fromCamera).toString(),
                  ),
                  onTap: () {
                    _ProimgFromCamera1();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _ChooseProfileImage2() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(
                      getTranslated(context, fromGallery).toString(),
                    ),
                    onTap: () {
                      _ProimgFromGallery2();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    getTranslated(context, fromCamera).toString(),
                  ),
                  onTap: () {
                    _ProimgFromCamera2();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Date Format  Dispaly user
class DateUtil {
  static const DATE_FORMAT = 'dd-MM-yyyy';

  String formattedDate(DateTime dateTime) {
    return DateFormat(DATE_FORMAT).format(dateTime);
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

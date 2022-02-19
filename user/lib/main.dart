import 'package:doctro/view/appointment/specialist/Specialist.dart';
import 'package:doctro/view/location/AddLocation.dart';
import 'package:doctro/view/productsell/Addtocart.dart';
import 'package:doctro/view/productsell/AllPharamacy.dart';
import 'package:doctro/view/appointment/Book_success.dart';
import 'package:doctro/view/appointment/Bookappointment.dart';
import 'package:doctro/view/appointment/Favoritedoctor.dart';
import 'package:doctro/HealthTips.dart';
import 'package:doctro/HealthTipsDetail.dart';

import 'package:doctro/view/productsell/MedicineDescription.dart';
import 'package:doctro/view/Offers/Offer.dart';
import 'package:doctro/view/productsell/PharamacyDetail.dart';
import 'package:doctro/view/appointment/Review_Appointment.dart';
import 'package:doctro/Setting.dart';
import 'package:doctro/view/Auth/SignIn.dart';

import 'package:doctro/view/appointment/treatment/Treatment.dart';
import 'package:doctro/view/appointment/treatment/TreatmentSpecialist.dart';
import 'package:doctro/const/preference.dart';
import 'package:doctro/view/appointment/doctordetail.dart';
import 'package:doctro/view/Auth/forgotpassword.dart';
import 'package:doctro/view/location/Showlocation.dart';
import 'package:doctro/view/productsell/phoneverification.dart';
import 'package:doctro/view/Auth/profile.dart';
import 'package:doctro/view/Auth/signup.dart';
import 'package:doctro/Myprescription.dart';
import 'package:doctro/view/appointment/Appointment.dart';
import 'package:doctro/ChangeLanguage.dart';
import 'package:doctro/view/Auth/splash.dart';
import 'package:doctro/view/Auth/otp_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:doctro/view/Auth/ChangePassword.dart';
import 'package:doctro/view/productsell/MedicineOrder.dart';
import 'package:doctro/view/productsell/MedicineOrderDetail.dart';
import 'package:doctro/view/productsell/MedicinePayment.dart';
import 'package:doctro/view/payment/StripePaymentScreen.dart';
import 'package:doctro/view/payment/StripePaymentScreenMedicine.dart';
import 'package:doctro/view/Notification/notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'view/Companypolices/AboutUs.dart';

import 'view/Companypolices/PrivacyPolicy.dart';
import 'const/Palette.dart';
import 'localization/language_localization.dart';
import 'localization/localization_constant.dart';
import 'view/Consult/Consult.dart';
import 'view/Dashboard/Dashboard.dart';
import 'view/appointment/healthisuse.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceHelper.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    getPermission();
  }

  @override
  void didChangeDependencies() {
    getLocale().then((local) => {
          setState(() {
            this._locale = local;
          })
        });
    super.didChangeDependencies();
  }

  getPermission() async {
    if (await Permission.location.isRestricted) {
      Permission.location.request();
      if (await Permission.location.isRestricted || await Permission.location.isDenied) {
        Permission.location.request();
      }
    }
    if (await Permission.storage.isDenied) {
      Permission.storage.request();
      if (await Permission.storage.isDenied || await Permission.storage.isDenied) {
        Permission.storage.request();
      }
    }
  }

  Map<int, Color> color =
  {
    50:Color.fromRGBO(136,14,79, .1),
    100:Color.fromRGBO(136,14,79, .2),
    200:Color.fromRGBO(136,14,79, .3),
    300:Color.fromRGBO(136,14,79, .4),
    400:Color.fromRGBO(136,14,79, .5),
    500:Color.fromRGBO(136,14,79, .6),
    600:Color.fromRGBO(136,14,79, .7),
    700:Color.fromRGBO(136,14,79, .8),
    800:Color.fromRGBO(136,14,79, .9),
    900:Color.fromRGBO(136,14,79, 1),
  };

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    if (_locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return MaterialApp(
        title: 'Doctro',
        locale: _locale,
        supportedLocales: [
          Locale(ENGLISH, 'US'),
          Locale(SPANISH, 'ES'),
          Locale(ARABIC, 'AE'),
        ],
        localizationsDelegates: [
          LanguageLocalization.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocal, supportedLocales) {
          for (var local in supportedLocales) {
            if (local.languageCode == deviceLocal!.languageCode &&
                local.countryCode == deviceLocal.countryCode) {
              return deviceLocal;
            }
          }
          return supportedLocales.first;
        },

        debugShowCheckedModeBanner: false,
        //home: Splash(),
        initialRoute: "splash",
     //   themeMode: ThemeMode.dark,
        theme: ThemeData(  fontFamily: 'OpenSans',
          primarySwatch: MaterialColor(0xff2C9085, color),
          accentColor: Color(0xff2C9085),
          primaryColor: Color(0xff2C9085),textTheme: TextTheme(headline1: TextStyle(color: Color(0xff092C4C),fontSize: 15,fontWeight: FontWeight.bold),
              headline2: TextStyle(color: Color(0xff092C4C),fontSize: 13,fontWeight: FontWeight.bold,),headline3: TextStyle(color: Color(0xff092C4C),fontSize: 12,fontWeight: FontWeight.bold)),
          splashColor: Palette.transparent,
          highlightColor: Palette.transparent,
        ),
        routes: {'OtpPage':(context)=>OtpPage(Phone:'(919999999999',Otp: '34',phonecode: "91",),
          'splash':(context)=>Splash(),
          '/':(context) => DashBoard(),
          'SignIn': (context) => SignIn(),
          'signup': (context) => signup(),
          'forgotpassword': (context) => forgotpassword(),
          'phoneverification': (context) => phoneverification(0),
          'Home': (context) => Consult(),
          'Dashboard':(context) =>DashBoard(),
          'Treatment': (context) => Treatment(),
          'Healthisse': (context) => Healthisse(),

          'Favoritedoctor': (context) => Favoritedoctor(),
          'Specialist': (context) => Specialist(),
          'Doctordetail': (context) => Doctordetail(0),
          'Bookappointment': (context) => Bookappointment(0),
          'Appointment': (context) => Appointment(),
          'Myprescription': (context) => Myprescription(),
          'HealthTips': (context) => HealthTips(),
          'HealthTipsDetail': (context) => HealthTipsDetail(0),
          'Setting': (context) => Setting(),
          'Addtocart': (context) => Addtocart(),
          'Offer': (context) => Offer(),
          'profile': (context) => profile(),
          'ShowLocation': (context) => ShowLocation(),
          'AddLocation': (context) => AddLocation(),
          'BookSuccess': (context) => BookSuccess(),
          'Review': (context) => Review(),
          'MedicineDescription': (context) => MedicineDescription(0),
          'AllPharamacy': (context) => AllPharamacy(),
          'PharamacyDetail': (context) => PharamacyDetail(0),
          'MadicinePayment': (context) => MadicinePayment(),
          'MedicineOrder': (context) => MedicineOrder(),
          'MedicineOrderDetail': (context) => MedicineOrderDetail(),
          'TreatmentSpecialist': (context) => TreatmentSpecialist(0),
          'notifications': (context) => notifications(),
          'StripePaymentScreen': (context) => StripePaymentScreen(),
          'StripePaymentScreenMedicine': (context) => StripePaymentScreenMedicine(),
          'ChangePassword': (context) => ChangePassword(),
          'PrivacyPolicy': (context) => PrivacyPolicy(),
          'AboutUs': (context) => AboutUs(),
          'ChangeLanguage': (context) => ChangeLanguage(),
        },
      );
    }
  }
}

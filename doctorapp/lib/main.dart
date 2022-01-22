import 'package:doctro/localization/language_localization.dart';
import 'package:doctro/screens/ChangePassword.dart';
import 'package:doctro/screens/SignIn.dart';
import 'package:doctro/screens/ViewAllAppointment.dart';
import 'package:doctro/screens/ViewAllNotification.dart';
import 'package:doctro/screens/changeLanguage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'constant/prefConstatnt.dart';
import 'localization/localization_constant.dart';
import 'screens/forgotpassword.dart';
import 'screens/signup.dart';
import 'screens/phoneverification.dart';
import 'screens/loginhome.dart';
import 'screens/patient_information.dart';
import 'screens/cancelappointment.dart';
import 'screens/appointment_history.dart';
import 'screens/rate&review.dart';
import 'screens/notifications.dart';
import 'screens/profile.dart';
import 'screens/payment.dart';
import 'package:doctro/constant/preferences.dart';
import 'package:doctro/screens/SubScription.dart';
import 'package:doctro/screens/PaymentGetway.dart';
import 'package:doctro/screens/SubscriptionHistory.dart';
import 'package:doctro/screens/ScheduleTimings.dart';
import 'package:doctro/screens/StripePayment.dart';

Future<void> main() async {
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
  get skip => null;

  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
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

  @override
  Widget build(BuildContext context) {

    if (_locale == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: loginhome(),
        locale: _locale,
        supportedLocales: [
          Locale(ENGLISH, 'US'),
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
        initialRoute: SharedPreferenceHelper.getBoolean(Preferences.is_logged_in) == true
            ? 'loginhome'
            : 'SignIn',
        routes: {
          'SignIn': (context) => SignIn(),
          'signup': (Context) => createaccount(),
          'forgotpassword': (Context) => forgotpassword(),
          'phoneverification': (Context) => phoneverification(),
          'ViewAllAppointment': (Context) => ViewAllAppointment(),
          'loginhome': (Context) => loginhome(),
          'patientinformation': (Context) => patientinformation(0),
          'cancelappoitment': (Context) => cancelappointment(),
          'appointmenthistory': (Context) => appointmenthistory(),
          'rateandreview': (Context) => rateandreview(),
          'notifications': (Context) => notifications(),
          'profile': (Context) => profile(),
          'payment': (Context) => payment(),
          'subscription': (Context) => SubScription(),
          'paymentgetway': (Context) => PaymentGetway('',0,0),
          'Subscription History': (Context) => SubscriptionHistory(),
          'Schedule Timings': (Context) => ScheduleTimings(),
          'Change Password': (Context) => ChangePassword(),
          'Change Language': (Context) => ChangeLanguage(),
          'ViewAllNotification': (Context) => ViewAllNotification(),
          'Stripe' :(Context) => Stripe(),
        },
      );
    }
  }
}
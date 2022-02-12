import 'dart:async';

import 'package:doctro/const/prefConstatnt.dart';
import 'package:doctro/const/preference.dart';
import 'package:doctro/view/Dashboard/Dashboard.dart';
import 'package:doctro/view/Auth/intro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
   return Splash_state();
  }

}
class Splash_state extends State<Splash>{
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3),
            ()=> SharedPreferenceHelper.getBoolean(Preferences.is_logged_in)!= true?
                Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                    Intro()
            )
        ): Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                        DashBoard()
                )
            )
    );
  }
  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Container(
        decoration: BoxDecoration(
         // color: Colors.white,
          image: DecorationImage(
            image: AssetImage("assets/images/splashScreen.png"),
            fit: BoxFit.cover,
          ),
        ),

        child:Center(child: Image.asset("assets/images/splash.png",width:w*0.60 ,height: 70,))
      //  FlutterLogo(size:MediaQuery.of(context).size.height)
    );
  }
}


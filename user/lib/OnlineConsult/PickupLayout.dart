
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/datas/user.dart';
import 'package:dating_app/models/user_model.dart';
import 'package:dating_app/screens/Call/models/UserModel.dart';
import 'package:dating_app/screens/Call/utilites/AppConstants.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'PickUpScreen.dart';
import 'models/CallModel.dart';

class PickupLayout extends StatelessWidget {
  final Widget? child;
  final User ? usermoel;

  PickupLayout({this.child,this.usermoel});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: callService.callStream(uid: usermoel!.userId),
      builder: (context, snap) {
        if (snap.hasData && snap.data!.data() != null) {
          CallModel call = CallModel.fromJson(snap.data!.data() as Map<String, dynamic>);

          if (!call.hasDialed!) {
            return PickUpScreen(callModel: call);
          } else
            return child!;
        }
        return child!;
      },
    );
  }
}

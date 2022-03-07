
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:doctro/model/Docterdetail.dart';
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
      stream: callService.callStream(uid: usermoel!.userId.toString()),
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

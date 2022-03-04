import 'dart:math';
import 'package:dating_app/screens/Call/AgoraVideoCallScreen.dart';
import 'package:dating_app/screens/Call/AgoraVoiceCallScreen.dart';
import 'package:dating_app/screens/Call/localDB/LogRepository.dart';
import 'package:dating_app/screens/Call/models/CallModel.dart';
import 'package:dating_app/screens/Call/models/LogModel.dart';
import 'package:dating_app/screens/Call/models/UserModel.dart';
import 'package:dating_app/screens/Call/utilites/AppConstants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';

class CallFunctions {
  static dial({required context, required UserModel from, required UserModel to}) async {
    CallModel callModel = CallModel(
      callerId: from.uid,
      callerName: from.name,
      callerPhotoUrl: from.photoUrl,
      channelId: Random().nextInt(1000).toString(),
      receiverId: to.uid,
      receiverName: to.name,
      receiverPhotoUrl: to.photoUrl,
    );
    LogModel log = LogModel(
      callerName: from.name,
      callerPic: from.photoUrl,
      callStatus: CALLED_STATUS_DIALLED,
      receiverName: to.name,
      receiverPic: to.photoUrl,
      timestamp: DateTime.now().toString(),
    );
    bool callMade = await callService.makeCall(callModel: callModel);
    callModel.hasDialed = true;
    if (callMade) {
    //  notificationService.sendPushNotifications("${from.name}", "${from.name.validate()} is Video calling you", receiverPlayerId: to.oneSignalPlayerId);
   //   LogRepository.addLogs(log);
      AgoraVideoCallScreen(callModel: callModel).launch(context);
    }
  }

  static voiceDial({required context, required UserModel from, required UserModel to}) async {
    CallModel callModel = CallModel(
      callerId: from.uid,
      callerName: from.name,
      callerPhotoUrl: from.photoUrl,
      channelId: Random().nextInt(1000).toString(),
      receiverId: to.uid,
      receiverName: to.name,
      receiverPhotoUrl: to.photoUrl,
    );

    LogModel log = LogModel(
      callerName: from.name,
      callerPic: from.photoUrl,
      callStatus: CALLED_STATUS_DIALLED,
      receiverName: to.name,
      receiverPic: to.photoUrl,
      timestamp: DateTime.now().toString(),
    );

    bool callMade = await callService.makeCall(callModel: callModel, isVoiceCall: true);
    callModel.hasDialed = true;
    if (callMade) {
      //add calls to local db
      notificationService.sendPushNotifications("${from.name}", "${from.name.validate()} is Voice calling you", receiverPlayerId: to.oneSignalPlayerId);
      LogRepository.addLogs(log);
      AgoraVoiceCallScreen(callModel: callModel).launch(context);
    }
  }
}

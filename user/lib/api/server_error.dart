import 'package:dio/dio.dart' hide Headers;
import 'package:fluttertoast/fluttertoast.dart';

class ServerError implements Exception {
  int? _errorCode;
  String _errorMessage = "";

  ServerError.withError({error}) {
    _handleError(error);
  }

  getErrorCode() {
    return _errorCode;
  }

  getErrorMessage() {
    return _errorMessage;
  }

  _handleError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        _errorMessage = "Connection timeout";
        // Constants.toastMessage('Connection timeout');
        Fluttertoast.showToast(msg: 'Connection timeout', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        break;
      case DioErrorType.sendTimeout:
        _errorMessage = "Receive timeout in send request";
        // Constants.toastMessage('Receive timeout in send request');
        Fluttertoast.showToast(msg: 'Receive timeout in send request', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        break;
      case DioErrorType.receiveTimeout:
        _errorMessage = "Receive timeout in connection";
        // Constants.toastMessage('Receive timeout in connection');
        Fluttertoast.showToast(msg: 'Receive timeout in connection', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        break;
      case DioErrorType.response:
        _errorMessage = "Received invalid status code: ${error.response!.data}";
        try {
          if (error.response!.data['errors']['name'] != null) {
            // Constants.toastMessage(error.response!.data['errors']['name'][0]);
            Fluttertoast.showToast(
                msg: '${error.response!.data['errors']['name'][0]}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            return;
          } else if (error.response!.data['errors']['phone'] != null) {
            // Constants.toastMessage(error.response!.data['errors']['phone'][0]);
            Fluttertoast.showToast(
                msg: '${error.response!.data['errors']['phone'][0]}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            return;
          } else if (error.response!.data['errors']['email_id'] != null) {
            // Constants.toastMessage(error.response!.data['errors']['email_id'][0]);
            Fluttertoast.showToast(
                msg: '${error.response!.data['errors']['email_id'][0]}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            return;
          } else if (error.response!.data['errors']['phone_code'] != null) {
            // Constants.toastMessage(error.response!.data['errors']['email_id'][0]);
            Fluttertoast.showToast(
                msg: '${error.response!.data['errors']['phone_code'][0]}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            return;
          } else if (error.response!.data['errors']['dob'] != null) {
            // Constants.toastMessage(error.response!.data['errors']['email_id'][0]);
            Fluttertoast.showToast(
                msg: '${error.response!.data['errors']['dob'][0]}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            return;
          } else if (error.response!.data['errors']['gender'] != null) {
            // Constants.toastMessage(error.response!.data['errors']['email_id'][0]);
            Fluttertoast.showToast(
                msg: '${error.response!.data['errors']['gender'][0]}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            return;
          } else if (error.response!.data['errors']['password'] != null) {
            // Constants.toastMessage(error.response!.data['errors']['email_id'][0]);
            Fluttertoast.showToast(
                msg: '${error.response!.data['errors']['password'][0]}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            return;
          } else if (error.response!.data['errors']['time'] != null) {
            // Constants.toastMessage(error.response!.data['errors']['email_id'][0]);
            Fluttertoast.showToast(
                msg: '${error.response!.data['errors']['time'][0]}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            return;
          } else if (error.response!.data['errors']['date'] != null) {
            // Constants.toastMessage(error.response!.data['errors']['email_id'][0]);
            Fluttertoast.showToast(
                msg: '${error.response!.data['errors']['date'][0]}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            return;
          } else if (error.response!.data['errors']['payment_type'] != null) {
            // Constants.toastMessage(error.response!.data['errors']['email_id'][0]);
            Fluttertoast.showToast(
                msg: '${error.response!.data['errors']['payment_type'][0]}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            return;
          } else if (error.response!.data['msg'] != null) {
            // Constants.toastMessage(error.response!.data['errors']['email_id'][0]);
            Fluttertoast.showToast(msg: '${error.response!.data['msg']}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            return;
          } else {
            // Constants.toastMessage(error.response!.data['message'].toString());
            Fluttertoast.showToast(
                msg: '${error.response!.data['message'].toString()}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            return;
          }
        } catch (error1, stacktrace) {
          // Constants.toastMessage(error.response!.data.toString());
          if (error.response!.data['msg'] != null) {
            // Constants.toastMessage(error.response!.data['errors']['email_id'][0]);
            Fluttertoast.showToast(msg: '${error.response!.data['msg']}', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            return;
          } else {
            Fluttertoast.showToast(msg: 'Exception occurred', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
            print("Exception occurred: $error stackTrace: $stacktrace apiError: ${error.response!.data}");
          }
        }
        break;
      case DioErrorType.cancel:
        _errorMessage = "Request was cancelled";
        // Constants.toastMessage('Request was cancelled');
        Fluttertoast.showToast(msg: 'Request was cancelled', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        break;
      case DioErrorType.other:
        _errorMessage = "Connection failed. Please check internet connection";
        // Constants.toastMessage('Connection failed. Please check internet connection');
        Fluttertoast.showToast(
            msg: 'Connection failed. Please check internet connection', toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
        break;
    }
    return _errorMessage;
  }
}

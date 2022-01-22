import 'dart:convert';
import 'package:doctro/constant/app_string.dart';
import 'package:doctro/constant/color_constant.dart';
import 'package:doctro/constant/prefConstatnt.dart';
import 'package:doctro/constant/preferences.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/model/purchaseSubscription.dart';
import 'package:doctro/retrofit/api_header.dart';
import 'package:doctro/retrofit/base_model.dart';
import 'package:doctro/retrofit/server_error.dart';
import 'package:doctro/retrofit/network_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stripe_payment/stripe_payment.dart';

class Stripe extends StatefulWidget {

  String? plan;
  int? value;
  int? id;

  Stripe({
    this.plan,
    this.id,
    this.value});

  @override
  _StripeState createState() => _StripeState();
}

class _StripeState extends State<Stripe> {

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String _CardNo = "";
  String _Cvv = "";
  String? _Date = "";
  String? _Year = "";

  //stripe variable
  String? Payment_Token = "";

  //decode pass id
  String? plan ;
  int? id;

  late var str;
  var parts;
  var year;
  var date;

  var _error;
  var _paymentToken;

  @override
  void initState() {

    super.initState();
    StripePayment.setOptions(StripeOptions(
      publishableKey: SharedPreferenceHelper.getString(Preferences.stripPublicKey),
      merchantId: "Test",
      androidPayMode: 'test',
    ),
    );
  }

  _passAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _CardNo = cardNumber;
      _Cvv = cvvCode;
      _Date = date;
      _Year = year;
    });
    prefs.setString('CardNo', _CardNo);
    prefs.setString('Cvv', _Cvv);
    prefs.setString('Date', _Date!);
    prefs.setString('Year', _Year!);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cardBgColor: stripe_card_color,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        themeColor: loginButton,
                        cardNumberDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: getTranslated(context,stripe_number).toString(),
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: getTranslated(context,stripe_expiry_date).toString(),
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: getTranslated(context,stripe_cvv).toString(),
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: getTranslated(context,stripe_card_holder).toString(),
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            primary: stripe_card_color,
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            child: Text(
                              getTranslated(context,payment_gateway_pay).toString(),
                              style: TextStyle(
                                color: colorWhite,
                                fontFamily: 'halter',
                                fontSize: 14,
                                package: 'flutter_credit_card',
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              _passAddress();

                              str = "$expiryDate";
                              parts = str.split("/");
                              date = parts[0].trim();
                              year = parts.sublist(1).join('/').trim();

                              int exMoth = int.parse(date.toString());
                              int exyear = int.parse(year.toString());

                              CreditCard testCard = CreditCard(
                                number: cardNumber,
                                expMonth: exMoth,
                                expYear: exyear,
                              );

                              await StripePayment.createTokenWithCard(
                                testCard,
                              ).then(
                                    (token) {
                                  _scaffoldKey.currentState!.showSnackBar(
                                    SnackBar(
                                      content: Text('Received ${token.tokenId}'),
                                    ),
                                  );
                                  Payment_Token = token.tokenId;

                                  Payment_Token != "" && Payment_Token!.isNotEmpty
                                      ? purchasesubscriptions()
                                      : Fluttertoast.showToast(
                                      gravity: ToastGravity.BOTTOM,
                                      msg: getTranslated(context,payment_not_complete).toString(), toastLength: Toast.LENGTH_SHORT);

                                  setState(
                                        () {
                                      _paymentToken = token;
                                    },
                                  );
                                },
                              ).catchError(setError);
                            }
                          }
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<BaseModel<PurchaseSubscription>> purchasesubscriptions() async {
    var parsedata = json.decode(widget.plan!);

    Map<String, dynamic> body = {
      "subscription_id": widget.id,
      "payment_token": Payment_Token,
      "payment_status": 1,
      "payment_type":"Stripe",
      "duration": ("${parsedata[widget.value]['month']}"),
      "amount": ("${parsedata[widget.value]['price']}"),
    };

    PurchaseSubscription response;
    try {
      response = await RestClient(RetroApi().dioData()).purchasesubscriptionrequest(body);
      setState(() {
        Fluttertoast.showToast(
          gravity: ToastGravity.BOTTOM,
          msg: getTranslated(context,payment_success).toString(),);
        Navigator.pushNamed(context, "loginhome") ;
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void setError(dynamic error) {
    _scaffoldKey.currentState!
        .showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }
}
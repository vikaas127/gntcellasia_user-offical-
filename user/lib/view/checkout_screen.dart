import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';



class CheckoutScreen extends StatefulWidget {
  final String? customerEmail;
  final bool isOneCheckout;
  const CheckoutScreen({
    Key? key,
    this.customerEmail,
    this.isOneCheckout = false,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with WidgetsBindingObserver {
  final _guestAddressFormKey = GlobalKey<FormState>();
  late PageController _pageController;

  bool _keyboardVisible = false;

  int _currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);

    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page?.round() ?? 0;
      });
    });
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance!.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != _keyboardVisible) {
      setState(() {
        _keyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageController.page == 0) {
          return true;
        } else {
          _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
          return false;
        }
      },
      child:Container()
    );
  }
}



class CheckOutProgress {
  String title;
  IconData icon;
  CheckOutProgress({
    required this.title,
    required this.icon,
  });
}

List<CheckOutProgress> _progressItems = [
  CheckOutProgress(
    title: "LocaleKeys.shipping.tr()",
    icon: Icons.local_shipping,
  ),
  CheckOutProgress(
    title: "LocaleKeys.order_details.tr()",
    icon: Icons.receipt,
  ),
  CheckOutProgress(
    title: "LocaleKeys.payment.tr()",
    icon: Icons.payment,
  ),
];

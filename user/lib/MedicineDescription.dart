import 'dart:ffi';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctro/api/Retrofit_Api.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/network_api.dart';
import '../const/prefConstatnt.dart';
import '../const/preference.dart';
import '../database/db_service.dart';
import '../database/form_helper.dart';
import '../models/data_model.dart';
import 'api/base_model.dart';
import 'api/server_error.dart';
import 'const/Palette.dart';
import 'const/app_string.dart';
import 'localization/localization_constant.dart';
import 'model/Medicinedetails.dart';

class MedicineDescription extends StatefulWidget {
  int? id;

  MedicineDescription(int? id) {
    this.id = id;
  }

  ProductModel? model;

  @override
  _MedicineDescriptionState createState() => _MedicineDescriptionState(id);
}

class _MedicineDescriptionState extends State<MedicineDescription> {
  bool _loadding = false;

  ProductModel? model;
  late DBService dbService;

  bool visibility = true;

  late PlatformFile file;

  String fileName = "";
  String filePath = "";

  int? id = 0;
  int? medicineid = 0;
  String? medicinename = "";
  int? medicinepricePrStrip = 0;
  String? medicinedescription = "";
  String? medicineworks = "";
  String? medicineimage = "";
  int? medicinenumberOfMedicine = 0;
  int? medicinetotalStock = 0;
  int quantity = 1;
  int? prescriptionRequired = 0;

  int? pharamacyId = 0;

  int? listOfPharmacyId = 0;
  int? ShippingStatus;
  String? pharmacyLat = "";
  String? pharmacyLang = "";
  List<String>? minValue = [];
  List<String>? maxValue = [];
  List<String>? charges = [];

  bool isInCart = false;

  _MedicineDescriptionState(int? id) {
    this.id = id;
  }

  String name = "";
  String price = "";

  List<ProductModel> products = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callApimedicine();
    dbService = new DBService();
    model = new ProductModel();

    _getPharamacyId();
    // _getCardPharmacyId();
  }

  _getPharamacyId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        pharamacyId = prefs.getInt('pharamacyId');
        ShippingStatus = prefs.getInt('ShippingStatus');
        pharmacyLat = prefs.getString('pharmacyLat');
        pharmacyLang = prefs.getString('pharmacyLang');
        minValue = prefs.getStringList('minValue');
        maxValue = prefs.getStringList('maxValue');
        charges = prefs.getStringList('charges');
      },
    );
  }

  _getCardPharmacyId() async {
    Future<List<ProductModel>> _futureOfList = dbService.getProducts();
    products.clear();
    products = await _futureOfList;
    if (products != null) {
      listOfPharmacyId = products[0].pharmacyId;
      for (int i = 0; i < products.length; i++) {
        if (products[i].medicineId == medicineid) {
          setState(() {
            isInCart = true;
            visibility = false;
          });
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return ModalProgressHUD(
      inAsyncCall: _loadding,
      opacity: 0.5,
      progressIndicator: SpinKitFadingCircle(
        color: Palette.blue,
        size: 50.0,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Palette.dark_blue,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'Addtocart');
                },
                icon: (Icon(
                  Icons.shopping_cart_outlined,
                  color: Palette.blue,
                )),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 0),
                height: 40,
                width: width * 1,
                color: Palette.white,
                child: Center(
                  child: Text(
                    '$medicinename',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Palette.blue,
                    ),
                  ),
                ),
              ),
              Container(
                width: width * 1,
                height: height * 0.2,
                child: Row(
                  children: [
                    Container(
                      width: width * 0.3,
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: CachedNetworkImage(
                        alignment: Alignment.center,
                        imageUrl: '$medicineimage',
                        placeholder: (context, url) => SpinKitFadingCircle(
                          color: Palette.blue,
                        ),
                        errorWidget: (context, url, error) => Image.asset("assets/images/no_image.jpg"),
                      ),
                    ),
                    Container(
                      width: width * 0.55,
                      margin: EdgeInsets.symmetric(vertical: 25, horizontal: 0),
                      child: Column(
                        children: [
                          Container(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              '$medicinename',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Palette.dark_blue,
                              ),
                            ),
                          ),
                          Container(
                            alignment: AlignmentDirectional.topStart,
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                            child: Row(
                              children: [
                                Container(
                                  child: Text(
                                    getTranslated(context, medicineDescription_price).toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.dark_blue,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    SharedPreferenceHelper.getString(Preferences.currency_symbol).toString() +
                                        '$medicinepricePrStrip ' +
                                        '/ ' +
                                        getTranslated(context, medicineDescription_strip).toString(),
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Palette.blue),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            alignment: AlignmentDirectional.topStart,
                            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 0),
                            child: Row(
                              children: [
                                Container(
                                  child: Text(
                                    getTranslated(context, medicineDescription_strip1).toString(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.dark_blue,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '$medicinenumberOfMedicine ' + getTranslated(context, medicineDescription_tablet).toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.blue,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            alignment: AlignmentDirectional.topStart,
                            height: 33,
                            child: Container(
                              width: width * 0.26,
                              decoration:
                                  BoxDecoration(border: Border.all(color: Palette.dark_blue), borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      decrease();
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      color: Palette.blue,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5, right: 5),
                                        child: Icon(
                                          Icons.remove,
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: double.infinity,
                                    width: 30,
                                    color: Palette.white,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5, right: 5),
                                      child: Center(
                                        child: Text(
                                          '$quantity',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Palette.dark_blue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      increase();
                                    },
                                    child: Container(
                                      height: double.infinity,
                                      color: Palette.blue,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5, right: 5),
                                        child: Icon(Icons.add_outlined, size: 25),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: Column(
                  children: [
                    DottedLine(
                      direction: Axis.horizontal,
                      lineLength: double.infinity,
                      lineThickness: 1.0,
                      dashLength: 4.0,
                      dashColor: Palette.blue,
                      dashRadius: 0.0,
                      dashGapLength: 4.0,
                      dashGapColor: Palette.transparent,
                      dashGapRadius: 0.0,
                    )
                  ],
                ),
              ),
              Container(
                alignment: AlignmentDirectional.topStart,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  getTranslated(context, medicineDescription_description).toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Palette.dark_blue,
                  ),
                ),
              ),
              Container(
                alignment: AlignmentDirectional.topStart,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Html(
                  data: "$medicinedescription",
                ),
              ),
              Container(
                alignment: AlignmentDirectional.topStart,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  getTranslated(context, medicineDescription_howItWork).toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Palette.dark_blue,
                  ),
                ),
              ),
              Container(
                alignment: AlignmentDirectional.topStart,
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Html(
                  data: "$medicineworks",
                ),
              ),
              prescriptionRequired == 1
                  ? Column(
                      children: [
                        Container(
                          child: Text(
                            getTranslated(context, medicineDescription_addPrescriptionPdf).toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Palette.dark_blue,
                            ),
                          ),
                        ),
                        Container(
                          child: fileName != ""
                              ? ElevatedButton(
                                  child: Text(
                                    getTranslated(context, medicineDescription_selected).toString(),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Palette.dark_grey1),
                                  ),
                                  onPressed: () {},
                                )
                              : ElevatedButton(
                                  child: Text(
                                    getTranslated(context, medicineDescription_selectPdf).toString(),
                                  ),
                                  onPressed: () {
                                    filePicker();
                                  },
                                ),
                        ),
                        fileName != ""
                            ? Container(
                                child: Text(
                                  fileName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Palette.dark_blue,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: height * 0.05,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: visibility == true ? Palette.blue : Palette.dark_grey,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                visibility == true
                    ? Text(
                        getTranslated(context, medicineDescription_addToCart_button).toString(),
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Palette.white,
                        ),
                      )
                    : Text(
                        getTranslated(context, medicineDescription_viewCart_button).toString(),
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: Palette.white,
                        ),
                      ),
              ],
            ),
            onPressed: () {
              if (SharedPreferenceHelper.getBoolean(Preferences.is_logged_in) == true) {
                if (prescriptionRequired == 0) {
                  if (visibility == true && isInCart == false) {
                    if (pharamacyId == listOfPharmacyId || listOfPharmacyId == 0) {
                      setState(() {
                        visibility = false;
                      });
                      this.model!.productName = medicinename;
                      this.model!.medicineId = medicineid;
                      this.model!.quntity = quantity;
                      this.model!.price = medicinepricePrStrip;
                      this.model!.pharmacyId = pharamacyId;
                      this.model!.shippingStatus = ShippingStatus;
                      this.model!.pLat = pharmacyLat;
                      this.model!.pLang = pharmacyLang;
                      this.model!.prescriptionFilePath = filePath;
                      this.model!.medicineStock = medicinetotalStock;

                      dbService.addProduct(model).then(
                        (value) {
                          Fluttertoast.showToast(
                            msg: getTranslated(context, medicineDescription_medicineAddToCart_toast).toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                        },
                      );
                    } else {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(getTranslated(context, medicineDescription_clearCartDetail_alert_title).toString()),
                          content: Text(getTranslated(context, medicineDescription_clearCartDetail_alert_text).toString()),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Text(getTranslated(context, cancel).toString()),
                            ),
                            TextButton(
                              onPressed: () async {
                                late List<ProductModel> products;
                                await dbService.getProducts().then((value) {
                                  products = value;
                                });
                                assert(products.isNotEmpty);
                                dbService.deleteTable(products[0]).then((value) {
                                  setState(() {
                                    listOfPharmacyId = 0;
                                    if (visibility == true) {
                                      if (listOfPharmacyId == 0) {
                                        setState(() {
                                          visibility = false;
                                        });
                                        this.model!.productName = medicinename;
                                        this.model!.medicineId = medicineid;
                                        this.model!.quntity = quantity;
                                        this.model!.price = medicinepricePrStrip;
                                        this.model!.pharmacyId = pharamacyId;
                                        this.model!.shippingStatus = ShippingStatus;
                                        this.model!.pLat = pharmacyLat;
                                        this.model!.pLang = pharmacyLang;
                                        this.model!.prescriptionFilePath = filePath;
                                        this.model!.medicineStock = medicinetotalStock;

                                        dbService.addProduct(model).then(
                                          (value) {
                                            Fluttertoast.showToast(
                                              msg: getTranslated(context, medicineDescription_medicineAddToCart_toast).toString(),
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                            );
                                          },
                                        );
                                      }
                                    }
                                    Navigator.of(context).pop();
                                  });
                                });
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    Navigator.pushNamed(context, 'Addtocart');
                    setState(() {});
                  }
                } else if (prescriptionRequired == 1 && fileName != "") {
                  if (SharedPreferenceHelper.getBoolean(Preferences.is_logged_in) == true) {
                    if (visibility == true && isInCart == false) {
                      if (pharamacyId == listOfPharmacyId || listOfPharmacyId == 0) {
                        setState(() {
                          visibility = false;
                        });
                        this.model!.productName = medicinename;
                        this.model!.medicineId = medicineid;
                        this.model!.quntity = quantity;
                        this.model!.price = medicinepricePrStrip;
                        this.model!.pharmacyId = pharamacyId;
                        this.model!.shippingStatus = ShippingStatus;
                        this.model!.pLat = pharmacyLat;
                        this.model!.pLang = pharmacyLang;
                        this.model!.prescriptionFilePath = filePath;
                        this.model!.medicineStock = medicinetotalStock;

                        dbService.addProduct(model).then(
                          (value) {
                            Fluttertoast.showToast(
                              msg: getTranslated(context, medicineDescription_medicineAddToCart_toast).toString(),
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                          },
                        );
                      } else {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(
                              getTranslated(context, medicineDescription_clearCartDetail_alert_title).toString(),
                            ),
                            content: Text(
                              getTranslated(context, medicineDescription_clearCartDetail_alert_text).toString(),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Text(
                                  getTranslated(context, cancel).toString(),
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  late List<ProductModel> products;
                                  await dbService.getProducts().then((value) {
                                    products = value;
                                  });
                                  assert(products.isNotEmpty);
                                  dbService.deleteTable(products[0]).then((value) {
                                    setState(() {
                                      listOfPharmacyId = 0;
                                      if (visibility == true) {
                                        if (listOfPharmacyId == 0) {
                                          setState(() {
                                            visibility = false;
                                          });
                                          this.model!.productName = medicinename;
                                          this.model!.medicineId = medicineid;
                                          this.model!.quntity = quantity;
                                          this.model!.price = medicinepricePrStrip;
                                          this.model!.pharmacyId = pharamacyId;
                                          this.model!.shippingStatus = ShippingStatus;
                                          this.model!.pLat = pharmacyLat;
                                          this.model!.pLang = pharmacyLang;
                                          this.model!.prescriptionFilePath = filePath;
                                          this.model!.medicineStock = medicinetotalStock;
                                          dbService.addProduct(model).then(
                                            (value) {
                                              Fluttertoast.showToast(
                                                msg: getTranslated(context, medicineDescription_medicineAddToCart_toast).toString(),
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                            },
                                          );
                                        }
                                      }
                                      Navigator.of(context).pop();
                                    });
                                  });
                                },
                                child: Text(
                                  getTranslated(context, medicineDescription_oK).toString(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      Navigator.pushNamed(context, 'Addtocart');
                      setState(() {});
                    }
                  } else {
                    FormHelper.showMessage(
                      context,
                      getTranslated(context, medicineDescription_buyMedicine_alert_title).toString(),
                      getTranslated(context, medicineDescription_buyMedicine_alert_text).toString(),
                      getTranslated(context, medicineDescription_cancel).toString(),
                      () {
                        Navigator.of(context).pop();
                      },
                      buttonText2: getTranslated(context, login).toString(),
                      isConfirmationDialog: true,
                      onPressed2: () {
                        Navigator.pushNamed(context, 'SignIn');
                      },
                    );
                  }
                }
                else if (prescriptionRequired == 1 && fileName == "") {
                  Fluttertoast.showToast(
                    msg: getTranslated(context, medicineDescription_pleaseSelectPdf_toast).toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Palette.blue,
                    textColor: Palette.white,
                  );
                }
              } else {
                FormHelper.showMessage(
                  context,
                  getTranslated(context, medicineDescription_buyMedicine_alert_title).toString(),
                  getTranslated(context, medicineDescription_buyMedicine_alert_text).toString(),
                  getTranslated(context, medicineDescription_cancel).toString(),
                  () {
                    Navigator.of(context).pop();
                  },
                  buttonText2: getTranslated(context, login).toString(),
                  isConfirmationDialog: true,
                  onPressed2: () {
                    Navigator.pushNamed(context, 'SignIn');
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  filePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      file = result.files.first;

      setState(() {
        fileName = file.name;
      });
    } else {
      print('User canceled the picker');
    }
  }

  void increase() {
    setState(() {
      if (quantity == medicinetotalStock) {
        Fluttertoast.showToast(msg: getTranslated(context, medicineDescription_outOfStock_toast).toString());
      } else {
        quantity = quantity + 1;
      }
    });
  }

  void decrease() {
    setState(() {
      quantity == 1 ? 1 : quantity = quantity - 1;
    });
  }

  Future<BaseModel<Medicinedetails>> callApimedicine() async {
    Medicinedetails response;

    setState(() {
      _loadding = true;
    });
    try {
      response = await RestClient(Retro_Api2().Dio_Data2()).medicinedetails(id);
      setState(() {
        if (response.success == true) {
          setState(
            () {
              _loadding = false;
              medicineid = response.data!.id;
              medicinename = response.data!.name;
              medicinepricePrStrip = response.data!.pricePrStrip;
              medicinedescription = response.data!.description;
              medicineworks = response.data!.works;
              medicinenumberOfMedicine = response.data!.numberOfMedicine;
              medicineimage = response.data!.fullImage;
              medicinetotalStock = response.data!.totalStock;
              prescriptionRequired = response.data!.prescriptionRequired;
              _getCardPharmacyId();
            },
          );
        }
      });
    } catch (error, stacktrace) {
      print("Exception occur: $error stackTrace: $stacktrace");
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}

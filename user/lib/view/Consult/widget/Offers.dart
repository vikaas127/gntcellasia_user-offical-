import 'package:doctro/const/Palette.dart';
import 'package:doctro/const/app_string.dart';
import 'package:doctro/const/prefConstatnt.dart';
import 'package:doctro/const/preference.dart';
import 'package:doctro/localization/localization_constant.dart';
import 'package:doctro/model/DisplayOffer.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Offers extends StatelessWidget{
  List<offer> offerList;

  Offers({required this.offerList,});
  @override
  Widget build(BuildContext context) {
    double width;
    double height;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return   offerList.length != 0
        ? Column(
      children: [
        Container(
          alignment: AlignmentDirectional.topStart,
          margin: EdgeInsets.only(left: width * 0.05, top: width * 0.03, right: width * 0.05),
          child: Column(
            children: [
              Text(
                getTranslated(context, home_offers).toString(),
                style: TextStyle(fontSize: width * 0.04, color: Palette.dark_blue),
              ),
            ],
          ),
        ),
        Container(
          height: 180,
          width: width * 1,
          child: ListView.builder(
            itemCount: offerList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Container(
                  height: 160,
                  width: 175,
                  child: Card(
                    color:
                    index % 2 == 0 ? Palette.light_blue.withOpacity(0.9) : Palette.offer_card.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          child: Container(
                            height: 40,
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Center(
                              child: Text(
                                offerList[index].name!,
                                style:
                                TextStyle(fontSize: 16, color: Palette.dark_blue, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                          child: Column(
                            children: [
                              DottedLine(
                                direction: Axis.horizontal,
                                lineLength: double.infinity,
                                lineThickness: 1.0,
                                dashLength: 3.0,
                                dashColor: index % 2 == 0
                                    ? Palette.light_blue.withOpacity(0.9)
                                    : Palette.offer_card.withOpacity(0.9),
                                dashRadius: 0.0,
                                dashGapLength: 1.0,
                                dashGapColor: Palette.transparent,
                                dashGapRadius: 0.0,
                              )
                            ],
                          ),
                        ),
                        if (offerList[index].discountType == "amount" && offerList[index].isFlat == 0)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Text(
                              getTranslated(context, home_flat).toString() +
                                  ' ' +
                                  SharedPreferenceHelper.getString(Preferences.currency_symbol).toString() +
                                  offerList[index].discount.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Palette.dark_blue,
                              ),
                            ),
                          ),
                        if (offerList[index].discountType == "percentage" && offerList[index].isFlat == 0)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            // alignment: Alignment.topLeft,
                            child: Text(
                              offerList[index].discount.toString() +
                                  getTranslated(context, home_discount).toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Palette.dark_blue,
                              ),
                            ),
                          ),
                        if (offerList[index].discountType == "amount" && offerList[index].isFlat == 1)
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Text(
                              getTranslated(context, home_flat).toString() +
                                  SharedPreferenceHelper.getString(Preferences.currency_symbol).toString() +
                                  offerList[index].flatDiscount.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Palette.dark_blue,
                              ),
                            ),
                          ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(color: Palette.white, borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: SelectableText(
                              offerList[index].offerCode!,
                              style: TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    )
        : Container();
  }

}
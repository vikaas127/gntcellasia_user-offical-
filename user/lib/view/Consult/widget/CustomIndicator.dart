import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomIndicator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CustomIndicatorState();
  }
}

class CustomIndicatorState extends State<CustomIndicator> {

  int currentPos = 0;
  List<String> listPaths =  [
    'assets/images/consult.png',
    'assets/images/consult.png',
    'assets/images/consult.png'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CarouselSlider.builder(
                    itemCount: listPaths.length,
                    options: CarouselOptions(height: 140,
                        aspectRatio: 16/9,
                        viewportFraction: 1.0,
                        autoPlay: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentPos = index;
                          });
                        }
                    ),
                    itemBuilder: (context,index,int ){
                      return Container(
                          child: MyImageView(listPaths[index]));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: listPaths.map((url) {
                      int index = listPaths.indexOf(url);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentPos == index
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ]
            )
        ),
      ),
    );
  }
}

class MyImageView extends StatelessWidget{

  String imgPath;

  MyImageView(this.imgPath);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(

      margin: EdgeInsets.symmetric(horizontal: 2),
      child: Image.asset(imgPath,),
    );
  }

}
class MyImageViewHome extends StatelessWidget{

  String imgPath;

  MyImageViewHome(this.imgPath);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(

      margin: EdgeInsets.symmetric(horizontal: 2),
      child: Image.asset(imgPath,),
    );
  }

}
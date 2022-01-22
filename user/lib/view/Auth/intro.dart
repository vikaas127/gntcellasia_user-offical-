import 'dart:io';

import 'package:doctro/view/Dashboard/Dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SignIn.dart';
import 'signup.dart';
class Intro extends StatefulWidget {
  @override
  _IntroState createState() => _IntroState();
}
class _IntroState extends State<Intro> {

  List<SliderModel> mySLides = <SliderModel>[];
  int slideIndex = 0;
  late PageController controller;

  Widget _buildPageIndicator(bool isCurrentPage){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySLides = getSlides();
    controller = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [const Color(0xff3C8CE7), const Color(0xff00EAFF)])),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(width: w,
          height: MediaQuery.of(context).size.height - 100,
          child: PageView(
            controller: controller,
            onPageChanged: (index) {
              setState(() {
                slideIndex = index;
              });
            },
            children: <Widget>[
              SlideTile(
                imagePath: mySLides[0].getImageAssetPath(),
                title: mySLides[0].getTitle(),
                desc: mySLides[0].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[1].getImageAssetPath(),
                title: mySLides[1].getTitle(),
                desc: mySLides[1].getDesc(),
              ),
              SlideTile(
                imagePath: mySLides[2].getImageAssetPath(),
                title: mySLides[2].getTitle(),
                desc: mySLides[2].getDesc(),
              )
            ],
          ),
        ),
        bottomSheet: slideIndex != 2 ? Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          child: Container( decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/introbottom.png"),
              fit: BoxFit.fitWidth,
            ),
          ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  onPressed: (){
                    controller.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.linear);
                  },
                  splashColor: Colors.blue[50],
                  child: Text(
                    "SKIP",
                    style: TextStyle(fontSize:18,color: Color(0xFF2C9085), fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      for (int i = 0; i < 3 ; i++) i == slideIndex ? _buildPageIndicator(true): _buildPageIndicator(false),
                    ],),
                ),
                FlatButton(
                  onPressed: (){
                    print("this is slideIndex: $slideIndex");
                    controller.animateToPage(slideIndex + 1, duration: Duration(milliseconds: 500), curve: Curves.linear);
                  },
                  splashColor: Colors.blue[50],
                  child: Text(
                    "NEXT",
                    style: TextStyle(fontSize:18,color: Color(0xFF2C9085), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ): InkWell(
          onTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
            (context) =>
                SignIn()
            ));
          },
          child: Container(
            height: Platform.isIOS ? 70 : 60,
            color: Color(0xFF2C9085),
            alignment: Alignment.center,
            child: Text(
              "GET STARTED NOW",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
class SlideTile extends StatelessWidget {
  String imagePath, title, desc;

  SlideTile({required this.imagePath, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    double h=MediaQuery.of(context).size.height;
    double w=MediaQuery.of(context).size.width;
    return Container(
    //  padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              child: Image.asset(
                'assets/images/intro_header.png',height: 120 ,width: w,fit:BoxFit.fitWidth ,)),
          Image.asset(imagePath),
          SizedBox(
            height: 40,
          ),
          Text(title, textAlign: TextAlign.center,style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20
          ),),
          SizedBox(
            height: 20,
          ),
          Text(desc, textAlign: TextAlign.center,style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14))
        ],
      ),
    );
  }
}
class SliderModel{

  String imageAssetPath;
  String title;
  String desc;

  SliderModel({required this.imageAssetPath,required this.title,required this.desc});

  void setImageAssetPath(String getImageAssetPath){
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle){
    title = getTitle;
  }

  void setDesc(String getDesc){
    desc = getDesc;
  }

  String getImageAssetPath(){
    return imageAssetPath;
  }

  String getTitle(){
    return title;
  }

  String getDesc(){
    return desc;
  }

}


List<SliderModel> getSlides(){

  List<SliderModel> slides = <SliderModel>[];
  SliderModel sliderModel = new SliderModel(desc: '', title: '', imageAssetPath: '');

  //1
  sliderModel.setDesc("Complete health app for all your medical needs - Book Lab Tests & Health Check-ups, consult an expert over audio, video, or chat online");
  sliderModel.setTitle("Online Medical & Healthcare");
  sliderModel.setImageAssetPath("assets/images/into1.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel(desc: '', title: '', imageAssetPath: '');

  //2
  sliderModel.setDesc("Complete health app for all your medical needs - Book Lab Tests & Health Check-ups, consult an expert over audio, video, or chat online");
  sliderModel.setTitle("Online Medical & Healthcare ");
  sliderModel.setImageAssetPath("assets/images/into1.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel(title: '', imageAssetPath: '', desc: '');

  //3
  sliderModel.setDesc("Food delivery or pickup from local restaurants, Explore restaurants that deliver near you.");
  sliderModel.setTitle("Online Medical & Healthcare");
  sliderModel.setImageAssetPath("assets/images/into1.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel(desc: '', title: '', imageAssetPath: '');

  return slides;
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'res.dart';
import 'services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:emudeck/phonebook.dart';
import 'feedback.dart';
import 'urgentReq.dart';
import 'profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:emudeck/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emudeck/myRequests.dart';
import 'serviceReq.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class adminDash extends StatefulWidget {
  const adminDash({Key? key}) : super(key: key);

  @override
  _adminDashState createState() => _adminDashState();
}

class _adminDashState extends State<adminDash> {

  DateTime date=DateTime.now();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2160),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          backgroundColor: bck_dark,
          appBar: AppBar(
            title: Text("Admin Dashboard".toUpperCase(),style: TextStyle(color: bck_Ldark),),
            centerTitle: true,
            actionsIconTheme: IconThemeData(
              color: icon_yellow,
            ),
            automaticallyImplyLeading: false,
            elevation: 0.0,
            backgroundColor: bck_dark,
            //leadingWidth: ScreenUtil().setWidth(400),
          ),
          body: Container(
            //padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                    flex:1,
                    child: Container(
                      //color: Colors.white,
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
                                width: ScreenUtil().screenWidth*0.45,
                                height: ScreenUtil().screenWidth*0.22,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(50.0))),
                                    color: text_light
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  formatDate(date),
                                  style: TextStyle(
                                      fontFamily: "Nunito",
                                      color: bck_Ldark,
                                      fontSize:ScreenUtil().setSp(50.0)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
                                padding: EdgeInsets.symmetric(vertical: 5.0,horizontal: 5.0),
                                width: ScreenUtil().screenWidth*0.45,
                                height: ScreenUtil().screenWidth*0.22,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(50.0))),
                                    color: bck_Ldark
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("24",style: TextStyle(color: text_light,fontSize: ScreenUtil().setSp(100.0)),),
                                    AutoSizeText("New requests in the last week",style: TextStyle(color: text_light),maxLines: 1,)
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            width: ScreenUtil().screenWidth*0.45,
                            height: ScreenUtil().screenWidth*0.45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(50.0))),
                              color: bck_Ldark
                            ),
                            alignment: Alignment.center,
                            child: CircularPercentIndicator(
                              progressColor: icon_yellow,
                              backgroundColor: bck_dark,
                              percent: 0.3,
                              restartAnimation: true,
                              animateFromLastPercent: true,
                              animation: true,
                              animationDuration: 2,
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("300/1000",style: TextStyle(fontFamily: "Nunito",color: text_light,),),
                                  Text("Requests completed",style: TextStyle(fontFamily: "Nunito",color: text_light,),)
                                ],
                              ),
                              radius: ScreenUtil().screenWidth*0.2,
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    flex:1,
                    child: Container()),
              ],
            ),
          ),
        );
      },
    );
  }
}

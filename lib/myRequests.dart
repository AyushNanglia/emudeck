import 'package:emudeck/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'res.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'requestModel.dart';

class myRequests extends StatefulWidget {
  const myRequests({Key? key}) : super(key: key);

  @override
  _myRequestsState createState() => _myRequestsState();
}

class _myRequestsState extends State<myRequests> {

  String user_psrn="";

  Widget reqCard_direct(DocumentSnapshot obj){
    Color labelColor=obj["resolved"]==true?Colors.green:Colors.red;
    /*switch(serviceType){
      case
    }*/
    String date_created_inverted=obj["created_at"].split(" ")[0];
    String date_created=date_created_inverted.split("-")[2]+"/"+date_created_inverted.split("-")[1]
        +"/"+date_created_inverted.split("-")[0].substring(2,4);
    String status=obj["resolved"]==false?"Pending":"Resolved";
    return GestureDetector(
      onTap: ()=>reqDetails(obj,date_created),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: ScreenUtil().screenHeight*0.15,
        width: ScreenUtil().screenWidth*0.85,
        decoration: BoxDecoration(
          color: bck_Ldark,
          borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(50.0))),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 20,
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(obj["service_type"],style: TextStyle(color: text_light,
                                  fontSize:ScreenUtil().setSp(70.0)),),
                              Text(status,style: TextStyle(color: Colors.grey,
                                  fontSize:ScreenUtil().setSp(50.0),fontStyle: FontStyle.italic
                                  ,fontWeight: FontWeight.w100),)
                            ],
                          ),
                          Text(obj["service_subtype"],style: TextStyle(color: text_light),)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Created: $date_created",style: TextStyle(color: text_light),),
                          Visibility(
                              visible: obj["resolved"],
                              child: Text("Resolved: ${obj["resolved_date"]}",style: TextStyle(color: text_light),)
                          )
                        ],
                      )
                    ],
                  ),
                )),
            Expanded(flex: 1,
              child: Container(
                //height: ScreenUtil().screenHeight*0.15,
                //width: ScreenUtil().screenWidth*0.9,
                decoration: BoxDecoration(
                  color: labelColor,
                  borderRadius: BorderRadius.horizontal(right:Radius.circular(ScreenUtil().setSp(50.0))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget weekdayCard(String days){
    List<String> weekdayList=days.split(" ");
    return Container(
      height: 30.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weekdayList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 1.0),
              //color: text_light,
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: bck_Ldark,
                  ),
                  child: Text(weekdayList.elementAt(index),style: TextStyle(color: text_light),))
          );
        },
      ),
    );
  }

  Widget timeCard(String startTime, String endTime){
    //List<String> weekdayList=days.split(" ");
    return Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        height: 30.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 1.0),
                //color: text_light,
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: icon_yellow,
                    ),
                    child: Text(startTime,style: TextStyle(color: bck_dark),))
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 1.0),
                //color: text_light,
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: icon_yellow,
                    ),
                    child: Text(endTime,style: TextStyle(color: bck_dark),))
            )


          ],
        )
    );
  }

  Future reqDetails(DocumentSnapshot obj,String date_created){
    bool schedule=obj["service_schedule"]=="Anytime"?false:true;
    return showDialog(
        context: context,
        builder: (BuildContext context)=>AlertDialog(
          backgroundColor: bck_dark,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(30.0)))
          ),
          title: SizedBox(
            height: ScreenUtil().screenHeight*0.1,
            width: ScreenUtil().screenWidth*0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(obj["service_type"],style: TextStyle(color: text_light,
                    fontSize: ScreenUtil().setSp(70.0)),),
                AutoSizeText(obj['service_subtype'],maxLines: 1,style: TextStyle(color: text_light,
                    fontSize: ScreenUtil().setSp(50.0)),)
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              height: ScreenUtil().screenHeight*0.3,
              width: ScreenUtil().screenWidth*0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  schedule==true?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      weekdayCard(obj["service_day"]),
                      timeCard(obj["service_time_start"], obj["service_time_end"]),
                    ],
                  )
                  :
                  Text("Preferred service schedule: ANYTIME",style: TextStyle(color: text_light)),
                  AutoSizeText(obj["request_details"],maxLines: 3,style: TextStyle(color: text_light),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText("Created on: $date_created",maxLines: 1,style: TextStyle(color: text_light,
                          fontSize: ScreenUtil().setSp(50.0)),),
                      Visibility(
                        visible: obj["resolved"],
                        child: AutoSizeText("Resolved on: ${obj["resolved_date"]}",maxLines: 1,style: TextStyle(color: text_light,
                            fontSize: ScreenUtil().setSp(50.0)),),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: bck_Ldark,
              ),
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close',style: TextStyle(
                  fontFamily: "Nunito",
                  color: text_light,),),
              ),
            )
          ],
        ),);
  }

  getPsrn()async{
    SharedPreferences _prefs=await SharedPreferences.getInstance();
    setState(() {
      user_psrn=_prefs.getString("user_psrn")??"";
    });
  }

  String t1="General";
  String t2="Urgent";

  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    getPsrn();
    //getData();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    //print(">>>"+requestList.length.toString());
    return ScreenUtilInit(
      designSize: const Size(1080, 2160),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          backgroundColor: bck_dark,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            actionsIconTheme: IconThemeData(
              color: icon_yellow,
            ),
            leading: IconButton(
              padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(20.0)),
              splashRadius: 1.0,
              alignment: Alignment.centerLeft,
              onPressed: () {

                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: icon_yellow,
            ),
            elevation: 0.0,
            backgroundColor: bck_dark,
            //leadingWidth: ScreenUtil().setWidth(400),
          ),
          endDrawerEnableOpenDragGesture: true,
          endDrawer: Container(
            height: ScreenUtil().setHeight(2000),
            alignment: Alignment.center,
            //color: Colors.yellow[100],
            child: Container(
              width: ScreenUtil().setWidth(700),
              child: ListView(
                children: drawerCards,
              ),
            ),
          ),
          drawerScrimColor: const Color.fromRGBO(0, 0, 0, 50.0),
          body: Container(
            padding: EdgeInsets.all(ScreenUtil().setSp(40.0)),
            child: Column(
              children: [
                Expanded(flex:3,
                    child:Container(
                      width: ScreenUtil().screenWidth,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  setState(() {});
                                },
                                child: Text(
                                  "Requests",
                                  style: TextStyle(
                                      fontFamily: "Nunito",
                                      color: text_light,
                                      fontSize:ScreenUtil().setSp(100.0)),
                                ),
                              ),
                              Text(
                                "Long press the $t1 Service Request tab to switch to ${t2} Requests",
                                style: TextStyle(
                                  fontFamily: "Nunito",
                                  color: text_light,
                                  //fontSize:ScreenUtil().setSp(30.0)
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onLongPress: (){
                              setState(() {
                                if(t1=="General"){
                                  t1="Urgent";
                                  t2="General";
                                }
                                else if(t1=="Urgent"){
                                  t2="Urgent";
                                  t1="General";
                                }
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: ScreenUtil().setSp(30.0)),
                              padding: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(15.0),horizontal: ScreenUtil().setSp(30.0)),
                              decoration: BoxDecoration(
                                  color: bck_dark,
                                  boxShadow: [BoxShadow(
                                    //offset: Offset(-3,3),
                                    color: bck_Ldark,
                                    blurRadius: 15.0,
                                  )],
                                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(20.0)))
                              ),
                              child: Text(
                                "$t1 Service Requests",
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    color: text_light,
                                    fontSize:ScreenUtil().setSp(40.0)),
                              ),
                            ),
                          )

                        ],
                      ),
                    )),
                Expanded(flex:9,
                  child: Container(
                    //color: bck_Ldark,
                    child: t1=="General"?
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("requests").doc("raised").collection(user_psrn).orderBy("created_at",descending: true).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if(!snapshot.hasData) {
                          return Container(
                            height: 3.0,
                            width: ScreenUtil().screenWidth*0.1,
                            child: const Center(
                              child: LinearProgressIndicator(
                                //minHeight: 10.0,
                                backgroundColor: bck_Ldark,
                                color: text_light,
                              ),
                            ),
                          );
                        }
                        else if(snapshot.hasError){
                          return Container(
                            height: 3.0,
                            width: ScreenUtil().screenWidth*0.1,
                            child: const Center(
                              child: LinearProgressIndicator(
                                //minHeight: 10.0,
                                backgroundColor: bck_Ldark,
                                color: text_light,
                              ),
                            ),
                          );
                        }
                        else{
                          return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return reqCard_direct(snapshot.data.docs[index]);

                            },

                          );
                        }
                      },
                    ):
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("requests").doc("urgent").collection(user_psrn).orderBy("created_at",descending: true).snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                        if(!snapshot.hasData) {
                          return Container(
                            height: 3.0,
                            width: ScreenUtil().screenWidth*0.1,
                            child: const Center(
                              child: LinearProgressIndicator(
                                //minHeight: 10.0,
                                backgroundColor: bck_Ldark,
                                color: text_light,
                              ),
                            ),
                          );
                        }
                        else if(snapshot.hasError){
                          return Container(
                            height: 3.0,
                            width: ScreenUtil().screenWidth*0.1,
                            child: const Center(
                              child: LinearProgressIndicator(
                                //minHeight: 10.0,
                                backgroundColor: bck_Ldark,
                                color: text_light,
                              ),
                            ),
                          );
                        }
                        else{
                          return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              String date_created_inverted=snapshot.data.docs[index]["created_at"].split(" ")[0];
                              String date_created=date_created_inverted.split("-")[2]+"/"+date_created_inverted.split("-")[1]
                                  +"/"+date_created_inverted.split("-")[0].substring(2,4);
                              return Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                //height: ScreenUtil().screenHeight*0.2,
                                width: ScreenUtil().screenWidth*0.7,
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                decoration: BoxDecoration(
                                  color: bck_Ldark,
                                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(50.0))),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data.docs[index]["service_type"],style: TextStyle(color: text_light,
                                                  fontSize:ScreenUtil().setSp(70.0)),),
                                              Text("Created: $date_created",style: TextStyle(color: Colors.grey,
                                                  //fontSize:ScreenUtil().setSp(50.0),
                                                  fontStyle: FontStyle.italic
                                                  ,fontWeight: FontWeight.w100),)
                                            ],
                                          ),
                                          SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                                              child: Container(
                                                child: AutoSizeText(snapshot.data.docs[index]["request_details"],
                                                  style: TextStyle(color: text_light,
                                                    //fontSize:ScreenUtil().setSp(50.0),
                                                    fontStyle: FontStyle.italic
                                                    ,fontWeight: FontWeight.w100),),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: ScreenUtil().screenHeight*0.01,
                                      width: ScreenUtil().screenWidth,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.vertical(bottom:Radius.circular(ScreenUtil().setSp(50.0))),
                                      ),
                                    ),
                                  ],
                                ),
                              );//reqCard_direct(snapshot.data.docs[index]);

                            },

                          );
                        }
                      },
                    ),
                  )
            ),]
          ),
        ));
      },
    );
  }
}

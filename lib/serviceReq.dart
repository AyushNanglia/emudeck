import 'package:emudeck/urgentReq.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'res.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'requestModel.dart';

class serviceReq extends StatefulWidget {
  const serviceReq({Key? key}) : super(key: key);

  @override
  _serviceReqState createState() => _serviceReqState();
}

class _serviceReqState extends State<serviceReq> {

  Widget reqCard_direct(DocumentSnapshot obj){
    Color labelColor=obj["resolved"]==true?Colors.green:Colors.red;
    /*switch(serviceType){
      case
    }*/
    String date_created_inverted=obj["created_at"].split(" ")[0];
    String date_created=date_created_inverted.split("-")[2]+"/"+date_created_inverted.split("-")[1]
        +"/"+date_created_inverted.split("-")[0].substring(2,4);
    String status=obj["resolved"]==false?"Pending":"Resolved";
    //String assign_status=obj["assigned_to"]=="-"?"":"Assigned";
    return GestureDetector(
      onTap: () {
        //empAlertBox(context, obj["service_type"]);
        reqDetails(obj,date_created);
        },
      onLongPress: (){
        String date_resolved_inverted=DateTime.now().toString().split(" ")[0];
        String date_resolved="${date_resolved_inverted.split("-")[2]}/${date_resolved_inverted.split("-")[1]}/${date_resolved_inverted.split("-")[0].substring(2,4)}";
        FirebaseFirestore.instance.collection("requests").doc("raised")
            .collection(obj["user_psrn"]).doc(obj["request_id"]).update({
          "resolved":!obj["resolved"],
          "resolved_date":date_resolved});
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(10.0)),
        height: ScreenUtil().screenHeight*0.2,
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
                              AutoSizeText(obj["service_type"],style: TextStyle(color: text_light,
                                  fontSize:ScreenUtil().setSp(70.0),
                              ),),
                              AutoSizeText(status,style: TextStyle(color: Colors.grey,
                                  fontSize:ScreenUtil().setSp(50.0),
                                  fontStyle: FontStyle.italic
                                  ,fontWeight: FontWeight.w100),)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText(obj["service_subtype"],style: TextStyle(color: text_light),),
                              //AutoSizeText("Press & hold to change status",style: TextStyle(color: Colors.grey),)
/*
                              AutoSizeText("obj[assigned_to]",style: TextStyle(color: Colors.grey,
                                  fontSize:ScreenUtil().setSp(50.0),fontStyle: FontStyle.italic
                                  ,fontWeight: FontWeight.w100),)
*/
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText("Created: $date_created",style: TextStyle(color: text_light),),
                          Visibility(
                              visible: obj["resolved"],
                              child: AutoSizeText("Resolved: ${obj["resolved_date"]}",style: TextStyle(color: text_light),)
                          ),
                          //Text("Assigned To: ${obj["assigned_to"]}",style: TextStyle(color: text_light),)
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

  Future empAlertBox(BuildContext context, String requestType){
    print(requestType);
    return showDialog(
        context: context,
        builder: (BuildContext context)=>AlertDialog(
          backgroundColor: bck_dark,
          title: Text("Employees",style: TextStyle(color: text_light),),
          content: SingleChildScrollView(
            child: SizedBox(
              height: ScreenUtil().screenHeight*0.5,
              width: ScreenUtil().screenWidth*0.7,
              child: ListView.builder(
                itemCount: service_emp[requestType]?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Text(service_emp[requestType]![index].toString());
                },
              ),

            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    color: icon_yellow,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  child: TextButton(
                    /*style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith((states) => Colors.red),
                  ),*/
                    onPressed: () {

                      Navigator.pop(context);
                    },
                    child: const Text('Assign',style: TextStyle(
                      fontFamily: "Nunito",
                      color: bck_dark,),),
                  ),
                ),
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
            )
          ],
        )
    );
  }

  Future reqDetails(DocumentSnapshot obj,String date_created){
    //String date_resolved=obj["resolved"]==false?"-":obj["resolved_date"];
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
                  //fontSize: ScreenUtil().setSp(70.0),
              ),),
              AutoSizeText(obj['service_subtype'],maxLines: 1,style: TextStyle(color: text_light,
                  //fontSize: ScreenUtil().setSp(50.0),
              ),)
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: SizedBox(
            height: ScreenUtil().screenHeight*0.5,
            width: ScreenUtil().screenWidth*0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    weekdayCard(obj["service_day"]),
/*                    AutoSizeText("Preferred Day: ${obj["service_day"].toUpperCase()}",maxLines: 1,style: TextStyle(color: text_light,
                        fontSize: ScreenUtil().setSp(50.0)),),*/
                    timeCard(obj["service_time_start"], obj["service_time_end"]),
                    Container(
                      width: ScreenUtil().screenWidth*1.0,
                      padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                      decoration: BoxDecoration(
                      color:bck_Ldark,
                      borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(20.0)))
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(obj["user_name"],maxLines:1,style: TextStyle(color: text_light),),
                          AutoSizeText(obj["user_address"],maxLines: 2,style: TextStyle(color: text_light),)
                        ],
                      ),
                    ),

                  ],
                ),
                SingleChildScrollView(
                    child: AutoSizeText(obj["request_details"],maxLines: 4,style: TextStyle(color: text_light,
                    fontSize: ScreenUtil().setSp(50.0)),)
                ),
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
                    AutoSizeText("Assigned to: -",maxLines: 1,style: TextStyle(color: text_light,
                        fontSize: ScreenUtil().setSp(50.0)),),
                  ],
                )
              ],
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: icon_yellow,
                ),
                padding: EdgeInsets.symmetric(vertical: 0.0),
                child: TextButton(
                  /*style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith((states) => Colors.red),
                  ),*/
                  onPressed: () {
                    Navigator.pop(context);
                    empAlertBox(this.context,obj["service_type"]);
                    //Navigator.pop(context);
                  },
                  child: const Text('Assign',style: TextStyle(
                    fontFamily: "Nunito",
                    color: bck_dark,),),
                ),
              ),
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
          )
        ],
      ),);
  }

  Future<List<String>> getGeneralReq() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('requests')
        .doc("admin").collection("raised").get();

    List<String> requestIdList=[];
    //List<requestModel> requestList=[];
    await FirebaseFirestore.instance
        .collection("requests").doc("admin").collection("raised")
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        String obj=result["request_id"]+"-"+result["user_psrn"];
        print(result["user_psrn"]);
        requestIdList.add(obj);
        // Do something with the result
      }
    });
    return requestIdList;
  }

  Future<List<String>> getUrgentReq() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('requests')
        .doc("admin").collection("urgent").get();

    List<String> requestIdList=[];
    //List<requestModel> requestList=[];
    await FirebaseFirestore.instance
        .collection("requests").doc("admin").collection("urgent")
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        String obj=result["request_id"]+"-"+result["user_psrn"];
        print(result["user_psrn"]);
        requestIdList.add(obj);
        // Do something with the result
      }
    });
    return requestIdList;
  }

  late Map<String,List> service_emp;
  late List<String> category_list;

  populateList()async{

    for(int i=0; i<category_list.length; i++) {
      FirebaseFirestore.instance
          .collection("categories")
          .doc(category_list.elementAt(i))
          .get()
          .then((value) {
        //print(List.from(value["service_emp"]));
        setState(() {
          service_emp[category_list.elementAt(i)] = List.from(value["service_emp"]);
          print(service_emp);
          //service_emp["Blacksmith"]?.addAll(List.from(value[category_list[i]]));
          //service_emp.addEntries(List.from(value[category_list[i]]));
          //print("----- Added ${category_list[i]} with service_emp length: ${service_emp.length}");
        });
      });
    }
  }

  urgentReqCard(DocumentSnapshot obj){
    String date_created_inverted=obj["created_at"].split(" ")[0];
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
                    AutoSizeText(obj["service_type"],style: TextStyle(color: text_light,
                        fontSize:ScreenUtil().setSp(55.0),
                    ),),
                    Text("Created: $date_created",style: const TextStyle(color: Colors.grey,
                        //fontSize:ScreenUtil().setSp(50.0),
                        fontStyle: FontStyle.italic
                        ,fontWeight: FontWeight.w100),)
                  ],
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      child: AutoSizeText(obj["request_details"],
                        style: const TextStyle(color: text_light,
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
    );
  }

  String t1="General";
  String t2="Urgent";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    service_emp={};
    category_list=["Blacksmith","Carpenter","Electrician","Gardener","Mason","Misc","Painter","Plumber","Sweeper",];
    populateList();
    getGeneralReq();
    getUrgentReq();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2160),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
            backgroundColor: bck_dark,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text("Admin View".toUpperCase(),style: TextStyle(color: bck_Ldark),),
              centerTitle: true,
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
                                      "Requests received",
                                      style: TextStyle(
                                          fontFamily: "Nunito",
                                          color: text_light,
                                          fontSize:ScreenUtil().setSp(100.0)),
                                    ),
                                  ),
                                  Text(
                                    "Long press the $t1 Request tab to switch to ${t2} Requests",
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
                                    "$t1 service requests",
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
                          child: t1=="General"?
                          FutureBuilder(
                            future: getGeneralReq(),
                            builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                              if(!snapshot.hasData || snapshot.hasError){
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
                              else {
                                return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  String request_id=snapshot.data!.elementAt(index).split("-")[0];
                                  String user_psrn=snapshot.data!.elementAt(index).split("-")[1];
                                  if(snapshot.hasError || !snapshot.hasData){
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
                                  else {
                                    return StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection("requests").doc("raised")
                                        .collection(user_psrn).where("request_id",isEqualTo: request_id).snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
                                      if(snapshot.hasError || !snapshot.hasData){
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
                                      else {
                                        return reqCard_direct(snap.data.docs[0]);
                                      }
                                    },
                                  );

                                  }
                                },

                              );
                              }
                            },

                          )
                              :
                          FutureBuilder(
                            future: getUrgentReq(),
                            builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                              if(!snapshot.hasData || snapshot.hasError){
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
                              else {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    String request_id=snapshot.data!.elementAt(index).split("-")[0];
                                    String user_psrn=snapshot.data!.elementAt(index).split("-")[1];
                                    if(snapshot.hasError || !snapshot.hasData){
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

                                      return StreamBuilder(
                                        stream: FirebaseFirestore.instance.collection("requests").doc("urgent")
                                            .collection(user_psrn).where("request_id",isEqualTo: request_id).snapshots(),
                                        builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
                                          if(snap.hasError || !snap.hasData){
                                            return Container(
                                              height: 3.0,
                                              width: ScreenUtil().screenWidth*0.2,
                                              child: const Center(
                                                child: LinearProgressIndicator(
                                                  //minHeight: 10.0,
                                                  backgroundColor: bck_Ldark,
                                                  color: text_light,
                                                ),
                                              ),
                                            );
                                          }
                                          else {
                                            return urgentReqCard(snap.data.docs[0]);
                                          }
                                        },
                                      );


                                  },

                                );
                              }
                            },

                          ),
                        )
                    ),]
              ),
            )
        );
      }
    );
  }
}

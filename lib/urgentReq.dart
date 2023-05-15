import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'res.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'createReq.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'searchEmp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class urgentReq extends StatefulWidget {
  bool isAdmin;
  urgentReq({Key? key,required this.isAdmin}) : super(key: key);

  @override
  _urgentReqState createState() => _urgentReqState();
}

class _urgentReqState extends State<urgentReq> {

  String reqFor="Select Service";
  List<String> reqForList=["Select Service","Medical Assistance","Security","Fire Depot","Plumber","Electrician","Gardener",
                              "Sweeper","Lady Sweeper","Blacksmith","Mason","Painter"];
  TextEditingController contactController=TextEditingController();
  TextEditingController reqController=TextEditingController();

  String user_name="";
  String user_address="";
  String user_psrn="";
  String user_phone="";
  bool hasName=true;
  bool hasAdd=true;
  bool hasPhone=true;

  getPsrn()async{
    SharedPreferences _prefs=await SharedPreferences.getInstance();
    setState(() {
      user_psrn=_prefs.getString("user_psrn")??"";
    });
  }

  Future getUser()async{
    SharedPreferences _pref=await SharedPreferences.getInstance();
    String name=_pref.getString("user_name")??"Field not setup";
    String address=_pref.getString("user_address")??"Field not setup";
    String phone=_pref.getString("user_phone")??"empty";
    setState(() {
      if(name.trim().isEmpty) {
        hasName=false;
        user_name="Name not setup";
      }
      else {
        hasName=true;
        user_name=name;
      }
      if(address.trim().isEmpty) {
        hasAdd=false;
        user_address="Address not setup";
      }
      else {
        hasAdd=true;
        user_address=address;
      }
      if(phone.trim().isEmpty) {
        hasPhone=false;
        user_phone="empty";
      }
      else {
        hasPhone=true;
        user_phone=phone;
      }

      contactController.text=user_phone;
    });
  }

  toggleText(String text, bool flag){
    if(flag==true) {
      return AutoSizeText(text.toUpperCase(),style: const TextStyle(
          color: text_light,
          fontWeight:FontWeight.w900),
        maxLines: 1,);
    }
    if(flag==false) {
      return AutoSizeText(text,style: const TextStyle(
          color: Colors.redAccent,
          fontWeight:FontWeight.w900,
          fontStyle: FontStyle.italic),
        maxLines: 1,);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    contactController=TextEditingController();
    reqController=TextEditingController();
    getUser();
    getPsrn();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2160),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          appBar:AppBar(
            actionsIconTheme: const IconThemeData(
              color: text_light,
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
              color: text_light,
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
            color: bck_dark,
            child: Container(
              height: ScreenUtil().screenHeight, //.screenHeight*1.1,
              width: ScreenUtil().screenWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex:3,
                    child: Container(
                      width: ScreenUtil().screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Urgent Request",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                color: text_light,
                                fontSize:ScreenUtil().setSp(100.0)),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: TextButton(
                                onPressed: null,
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ScreenUtil().setSp(20.0),
                                      vertical: ScreenUtil().setSp(20.0),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(ScreenUtil().setSp(20.0)),
                                      color:Colors.red,
                                    ),
                                    child: Text("Emergency Contacts".toUpperCase(),
                                      style: TextStyle(color: text_light
                                    ),)
                                )
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(flex:9,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: ScreenUtil().setHeight(900),
                              decoration: BoxDecoration(
                                  color: bck_Ldark,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          ScreenUtil().setSp(100.0)))),
                              padding:
                              EdgeInsets.all(ScreenUtil().setSp(50.0)),
                              width: ScreenUtil().screenWidth,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: text_light),
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setSp(100.0))),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          ScreenUtil().setSp(20.0)),
                                      child: DropdownButton(
                                        //elevation: 0,
                                        underline: const Text(""),
                                        iconDisabledColor: Colors.red,
                                        iconEnabledColor: bck_Ldark,
                                        style: const TextStyle(
                                            fontFamily: "Nunito",
                                            color: text_light),
                                        value: reqFor,
                                        dropdownColor: bck_Ldark,
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setSp(100.0)),
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),

                                        // Array list of items
                                        items: reqForList.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: AutoSizeText(
                                              items,
                                              style: TextStyle(
                                                  fontFamily: "Nunito",
                                                  color: text_light,
                                                  fontSize: ScreenUtil()
                                                      .setSp(50.0)),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            reqFor = newValue!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: text_light),
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setSp(100.0))),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          ScreenUtil().setSp(10.0)),
                                      child: TextFormField(
                                        controller: contactController,
                                        keyboardType: TextInputType.number,
                                        minLines: 1,
                                        //maxLines: 5,
                                        style: TextStyle(
                                            fontFamily: "Nunito",
                                            color: text_light,
                                            fontSize:
                                            ScreenUtil().setSp(50.0)),
                                        decoration: InputDecoration(
                                          //border: UnderlineInputBorder(),
                                            hintText: 'Contact Number',
                                            contentPadding: EdgeInsets.all(
                                                ScreenUtil().setSp(30.0)),
                                            //hintText: ,
                                            focusedBorder: InputBorder.none,
                                            hintStyle: TextStyle(
                                                fontFamily: "Nunito",
                                                color: text_light,
                                                fontSize: ScreenUtil()
                                                    .setSp(50.0))),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: text_light),
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setSp(100.0))),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                          ScreenUtil().setSp(10.0)),
                                      child: TextFormField(
                                        controller: reqController,
                                        keyboardType: TextInputType.multiline,
                                        minLines: 1,
                                        maxLines: 5,
                                        style: TextStyle(
                                            fontFamily: "Nunito",
                                            color: text_light,
                                            fontSize:
                                            ScreenUtil().setSp(50.0)),
                                        decoration: InputDecoration(
                                          //border: UnderlineInputBorder(),
                                            hintText: 'Request Description',
                                            contentPadding: EdgeInsets.all(
                                                ScreenUtil().setSp(30.0)),
                                            //hintText: ,
                                            focusedBorder: InputBorder.none,
                                            hintStyle: TextStyle(
                                                fontFamily: "Nunito",
                                                color: text_light,
                                                fontSize: ScreenUtil()
                                                    .setSp(50.0))),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: ScreenUtil().setHeight(500),
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setSp(20.0),
                                  right: ScreenUtil().setSp(20.0),
                                  top: ScreenUtil().setSp(50.0)),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              width: ScreenUtil().screenWidth,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  AutoSizeText(
                                                    "Requestor's Name",
                                                    style: TextStyle(
                                                        fontFamily: "Nunito",
                                                        color: text_light,
                                                        fontWeight:
                                                        FontWeight.w100),
                                                  ),
                                                  toggleText(user_name,hasName),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              width: ScreenUtil().screenWidth,
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  AutoSizeText(
                                                    "Requestor's Residence Address",
                                                    style: TextStyle(
                                                        fontFamily: "Nunito",
                                                        color: text_light,
                                                        fontWeight:
                                                        FontWeight.w100),
                                                  ),
                                                  toggleText(user_address, hasAdd),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                            visible: widget.isAdmin,
                            child: Expanded(flex:1,
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>searchEmp()));
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(ScreenUtil()
                                            .setSp(30.0))),
                                    color: icon_yellow,
                                  ),
                                  //color: icon_yellow,
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                      ScreenUtil().setSp(10),
                                      horizontal:
                                      ScreenUtil().setSp(10)),
                                  child: Text(
                                    "Request Block".toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: "Nunito",),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(flex:1,
                            child: GestureDetector(
                              onTap: ()async{
                                SharedPreferences _prefs=await SharedPreferences.getInstance();
                                String psrn=_prefs.getString("user_psrn")??"";
                                String request_id=DateTime.now().hashCode.toString();
                                String timeCreated=DateTime.now().toString();
                                FirebaseFirestore.instance
                                    .collection("requests")
                                    .doc("urgent")
                                    .collection(psrn)
                                    .doc(request_id)
                                    .set({
                                  "request_id":request_id,
                                  "user_name": user_name,
                                  "user_address": user_address,
                                  "user_psrn": psrn,
                                  "service_type": reqFor,
                                  "request_details":reqController.text,
                                  "created_at":timeCreated,
                                  "user_phone":contactController.text,
                                });
                                showSnack("Request Created", context);
                                setState(() {
                                  reqFor="Select Service";
                                  reqController.clear();
                                });
                                FirebaseFirestore.instance.collection("requests").doc("admin")
                                    .collection("urgent").doc(request_id+psrn).set({
                                  "request_id":request_id,
                                  "user_psrn":psrn,
                                  "created_at":timeCreated,
                                });

                                FirebaseDatabase.instance.refFromURL("https://emudeck-a21c6-default-rtdb.firebaseio.com/").child("users").child(psrn)
                                    .update({
                                  "block":"false",
                                  "block_note":"-",
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(ScreenUtil()
                                          .setSp(30.0))),
                                  color: icon_yellow,
                                ),
                                //color: icon_yellow,
                                padding: EdgeInsets.symmetric(
                                    vertical:
                                    ScreenUtil().setSp(10),
                                    horizontal:
                                    ScreenUtil().setSp(10)),
                                child: Text(
                                  "Submit".toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: "Nunito",),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

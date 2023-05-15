import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'res.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class createReq extends StatefulWidget {
  String serviceType;
  Color theme;
  bool isAdmin;

  createReq({Key? key, required this.serviceType, required this.theme, required this.isAdmin})
      : super(key: key);

  @override
  _createReqState createState() => _createReqState();
}

class _createReqState extends State<createReq> {
  String subtype_dropdownvalue = "Request Subtype";
  String time_dropdownvalue = "Anytime";
  String day_dropdownvalue = "Any day";
  TextEditingController detailsController=TextEditingController();
  List<String> items = ["Request Subtype", "B", "C","Requaest Subtype", "D", "E","Requhest Subtype", "F", "G"];
  var time_items = ["Anytime", "Specific Time"];
  bool selTime = false;
  DateTime date=DateTime.now();
  bool addSubtype=false;
  TextEditingController _addSubtypeController=TextEditingController();
  Map<int,String> weekDays={};
  Map<String,bool> selectedDays={};
  String selDaysField="Any Day";
  bool _isChecked=false;

  late TimeOfDay _iniTime;
  late TimeOfDay _finTime;

  String user_name="";
  String user_address="";
  String user_psrn="";
  late bool hasName;
  late bool hasAdd;

  late List<String> subtypes;

  getPsrn()async{
    SharedPreferences _prefs=await SharedPreferences.getInstance();
    setState(() {
      user_psrn=_prefs.getString("user_psrn")??"";
    });
    print(">>>>>psrn retrieved: $user_psrn");
  }

  Future getUser()async{
    SharedPreferences _pref=await SharedPreferences.getInstance();
    String name=_pref.getString("user_name")??"";
    String address=_pref.getString("user_address")??"";
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

  void _startTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _iniTime,
    );
    if (newTime != null) {
      setState(() {
        _iniTime = newTime;
      });
    }
  }

  void _endTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _finTime,
    );
    if (newTime != null) {
      setState(() {
        _finTime = newTime;
      });
    }
  }

  Widget drawerCard(String title, String path, Color theme) {
    return GestureDetector(
      onTap: () {
        Navigator.popAndPushNamed(context, path);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30.0)),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenUtil().setSp(50.0))),
          color: theme,
        ),
        height: ScreenUtil().setHeight(200),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
              fontFamily: "Nunito",
              color: text_light,
              fontSize: ScreenUtil().setSp(50.0)),
        ),
      ),
    );
  }
  
  Widget subtypeCard(String Title, int index, void Function(void Function()) state){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(20.0)),
      child: ListTile(
        title: AutoSizeText(Title,maxLines: 1,style: TextStyle(color: text_light)),
        trailing: IconButton(
            onPressed: () {
              state((){
                items.removeAt(index);
                subtypes.removeAt(index);
              });
              this.setState(() {});
              FirebaseFirestore.instance.collection("categories").doc(widget.serviceType).update({
                "service_subtype":subtypes
              });
            },
            icon: Icon(Icons.delete,color: Colors.redAccent,)),
        tileColor: bck_Ldark,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(30.0)))
        ),
      ),
    );
  }

  Future manageSubtype(){
    return showDialog(
      context: context,
      builder: (BuildContext context)=>StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(30.0)))
            ),
            //actions: [Text("Bruh")],
            title: addSubtype==false?
            GestureDetector(
              onTap: (){
                setState(() {
                  addSubtype=!addSubtype;
                });
              },
              child: Container(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenWidth*0.15,
                decoration: BoxDecoration(
                  color: widget.theme,
                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(30.0))),
                ),
                child: Icon(Icons.add,color: bck_dark,),
              ),
            )
                :
            GestureDetector(
              onTap: (){
                setState(() {
                  addSubtype=!addSubtype;
                });
                print(items.length);
              },
              child: Container(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenWidth*0.15,
                decoration: BoxDecoration(
                  color: bck_Ldark,
                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(30.0))),
                ),
                child: ListTile(
                  title: TextFormField(
                    cursorColor: widget.theme,
                    controller: _addSubtypeController,
                    style: TextStyle(color: text_light),
                    decoration: InputDecoration(
                      focusColor: widget.theme,
                      border: InputBorder.none,
                      hintText: "Sub-Catergory title",
                      hintStyle: TextStyle(fontStyle: FontStyle.italic,color: text_light),
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: (){
                      setState(() {
                        addSubtype=!addSubtype;
                      });
                      //subtypes.add("Request Subtype");
                      this.setState(() {
                        if(_addSubtypeController.text.trim().isNotEmpty) {
                          subtypes.add(_addSubtypeController.text);
                        }
                      });
                      FirebaseFirestore.instance.collection("categories").doc(widget.serviceType).update({
                        "service_subtype":subtypes
                      });
                      _addSubtypeController.clear();
                    },
                    icon: Icon(Icons.check,color: widget.theme,),
                  ),
                ),
              ),
            ),
            backgroundColor: bck_dark,
            content: SingleChildScrollView(
              child: Container(
                height: ScreenUtil().screenHeight*0.5,
                width: ScreenUtil().screenWidth*0.7,
                child: ListView.builder(
                  itemCount: subtypes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return subtypeCard(subtypes.elementAt(index),index,setState);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  countTrue(Map<String,bool> map){
    int count=0;
    map.forEach((key, value) {
      if(value==true) {
        count++;
      }
    });
    return count;
  }

  Widget selectDayCard(String weekday, int index,void Function(void Function()) setRefresh){
    Color checkColor=selectedDays[weekday]==true?widget.theme:bck_dark;
    return ListTile(
      onTap: (){
        bool val=selectedDays[weekday]??false;
        setRefresh(() {
          selectedDays[weekday]=!val;
        });
      },
      title: Text(weekday,style: TextStyle(color: text_light),),
      trailing: Icon(Icons.check,color: checkColor,),
    );
  }

  Future selectDays(){
    return showDialog(
      context: context,
      builder: (BuildContext context)=>StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    ScreenUtil().setSp(100.0))
            ),
            backgroundColor: bck_dark,
            //title: Text("Text"),
            content: Container(
              alignment: Alignment.center,
              height: ScreenUtil().screenHeight*0.5,
              width: ScreenUtil().screenWidth*0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 8,
                    child: ListView.builder(
                      itemCount: weekDays.length,
                      itemBuilder: (BuildContext context, int index) {
                        return selectDayCard(weekDays[index].toString(), index, setState);
                      },
                    ),
                  ),
                  Expanded(flex: 1,
                    child: GestureDetector(
                      onTap: (){
                        String val="";
                        selectedDays.forEach((key, value) {
                          if(value==true) {
                            val+="${key.substring(0,3)} ";
                          }
                        });
                        if(val.isEmpty) {
                          val="Any day";
                        }
                          this.setState(() {
                            selDaysField = val.trimRight();
                          });
                        Navigator.pop(context);
                      },
                      child: Container(
                        //alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(100.0),vertical: ScreenUtil().setSp(30.0)),
                        //height: ScreenUtil().screenWidth*0.15,
                        //width: ScreenUtil().screenWidth,
                        decoration: BoxDecoration(
                          color: widget.theme,
                          borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(30.0))),
                        ),
                        child: Text("Set".toString()),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    hasAdd=true;
    hasName=true;
    getUser();
    getPsrn();
    subtypes=[];
    date=DateTime.now();
    detailsController=TextEditingController();
    weekDays.addAll({0:"Monday",1:"Tuesday",2:"Wednesday",3:"Thursday",
                          4:"Friday",5:"Saturday"});
    selectedDays.addAll({"Monday":false,"Tuesday":false,"Wednesday":false,"Thursday":false,
                          "Friday":false,"Saturday":false});
    _iniTime=TimeOfDay(hour: DateTime.now().hour-1,minute: DateTime.now().minute);
    _finTime=TimeOfDay(hour: DateTime.now().hour,minute: DateTime.now().minute);
    FirebaseFirestore.instance.collection("categories").doc(widget.serviceType).get().then((value){
      subtypes=List.from(value["service_subtype"]);
      print(subtypes);
    });
    //print(weekDays[]);
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return ScreenUtilInit(
        designSize: const Size(1080, 2160),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: bck_dark,
            appBar: AppBar(
              actionsIconTheme: IconThemeData(
                color: widget.theme,
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
                color: widget.theme,
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
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              child: Container(
                height: ScreenUtil().screenHeight, //.screenHeight*1.1,
                width: ScreenUtil().screenWidth,
                child: Column(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Container(
                          width: ScreenUtil().screenWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.serviceType,
                                    style: TextStyle(
                                        fontFamily: "Nunito",
                                        color: text_light,
                                        fontSize:ScreenUtil().setSp(100.0)),
                                  ),
                                  Visibility(
                                    visible: widget.isAdmin,
                                    child: TextButton(
                                        onPressed: ()=>manageSubtype(),
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.resolveWith((states) => widget.theme)
                                        ),
                                        child: Text("Manage subtypes",style:TextStyle(color: Colors.black,))
                                    ),
                                  )

                                ],
                              ),
                              Text(
                                formatDate(date),
                                style: TextStyle(
                                    fontFamily: "Nunito",
                                    color: text_light,
                                    fontSize:ScreenUtil().setSp(50.0)),
                              ),
                            ],
                          ),
                        )),
                    Expanded(
                        flex: 9,
                        child: SingleChildScrollView(
                          child: Column(

                            children: [
                              Container(
                                height: ScreenUtil().setHeight(1100),
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
                                          value: subtype_dropdownvalue,
                                          dropdownColor: bck_Ldark,
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil().setSp(100.0)),
                                          // Down Arrow Icon
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),

                                          // Array list of items
                                          items: subtypes.map((String items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: AutoSizeText(
                                                items,
                                                style: TextStyle(
                                                    fontFamily: "Nunito",
                                                    color: text_light,
                                                    fontSize: ScreenUtil()
                                                        .setSp(50.0),
                                                overflow: TextOverflow.fade),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              subtype_dropdownvalue = newValue!;
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
                                            ScreenUtil().setSp(20.0)),
                                        child: DropdownButton(
                                          //elevation: 0,
                                          iconDisabledColor: Colors.red,
                                          underline: const Text(""),
                                          iconEnabledColor: bck_Ldark,
                                          style: const TextStyle(
                                              fontFamily: "Nunito",
                                              color: text_light),
                                          value: time_dropdownvalue,
                                          dropdownColor: bck_Ldark,
                                          borderRadius: BorderRadius.circular(
                                              ScreenUtil().setSp(100.0)),
                                          // Down Arrow Icon
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),

                                          // Array list of items
                                          items: time_items.map((String items) {
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
                                              time_dropdownvalue = newValue!;
                                            });
                                            if (time_dropdownvalue ==
                                                "Specific Time") {
                                              selTime = true;
                                            } else {
                                              selTime = false;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: selTime,
                                      child: GestureDetector(
                                        onTap: ()=>selectDays(),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(color: text_light),
                                              borderRadius: BorderRadius.circular(
                                                  ScreenUtil().setSp(100.0))),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    ScreenUtil().setSp(20.0),vertical: ScreenUtil().setSp(35.0)),
                                            child: Text(selDaysField,style: TextStyle(
                                                color: text_light,
                                                fontSize: ScreenUtil().setSp(50.0),
                                            ),)
                                          ),
                                        ),
                                      ),
                                    ),

                                    Visibility(
                                      visible: selTime,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                ScreenUtil().setSp(20.0)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                _startTime();
                                                print(_iniTime.toString().substring(10,15));
                                                print("format(context): "+_iniTime.format(context).split(" ")[0]);
                                                print("period: "+_iniTime.period.toString());
                                                print(DateTime.now().toString().split(" ")[1].substring(0,5));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil()
                                                        .setSp(20.0),
                                                    vertical: ScreenUtil()
                                                        .setSp(30.0)),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: text_light),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            ScreenUtil()
                                                                .setSp(100.0))),
                                                child: Text(
                                                  "${_iniTime.format(context).split(" ")[0]} ${_iniTime.period.toString().split(".")[1].toUpperCase()}",
                                                  style: TextStyle(
                                                      fontFamily: "Nunito",
                                                      color: text_light,
                                                      fontSize: ScreenUtil()
                                                          .setSp(50.0)),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "TO",
                                              style: TextStyle(
                                                  fontFamily: "Nunito",
                                                  color: text_light,
                                                  fontSize: ScreenUtil()
                                                      .setSp(50.0)),
                                            ),
                                            GestureDetector(
                                              onTap: ()=>_endTime(),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: ScreenUtil()
                                                        .setSp(20.0),
                                                    vertical: ScreenUtil()
                                                        .setSp(20.0)),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: text_light),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            ScreenUtil().setSp(100.0))),
                                                child: Text(
                                                  "${_finTime.format(context).split(" ")[0]} ${_finTime.period.toString().split(".")[1].toUpperCase()}",
                                                  style: TextStyle(
                                                      fontFamily: "Nunito",
                                                      color: text_light,
                                                      fontSize: ScreenUtil().setSp(50.0)),
                                                ),
                                              ),
                                            ),
                                          ],
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
                                                ScreenUtil().setSp(20.0)),
                                        child: TextFormField(
                                          controller: detailsController,
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
                                              hintText: 'Request Details',
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
                                                          color: widget.theme,
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
                                                          color: widget.theme,
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
                        )),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: ()async{
                          SharedPreferences _prefs=await SharedPreferences.getInstance();
                          String psrn=_prefs.getString("user_psrn")??"";
                          String request_id=DateTime.now().hashCode.toString();
                          String timeCreated=DateTime.now().toString();

                          if(hasName==false || hasAdd==false) {
                            errorDialog(context,
                                "Please complete your profile before posting any request");
                          }
                          else if(hasName==true && hasAdd==true) {
                            if (time_dropdownvalue == "Anytime") {
                              FirebaseFirestore.instance
                                  .collection("requests")
                                  .doc("raised")
                                  .collection(psrn)
                                  .doc(request_id)
                                  .set({
                                "request_id": request_id,
                                "user_name": user_name,
                                "user_address": user_address,
                                "user_psrn": psrn,
                                "service_type": widget.serviceType,
                                "service_subtype": subtype_dropdownvalue,
                                "service_schedule": time_dropdownvalue,
                                "request_details": detailsController.text,
                                "created_at": timeCreated,
                                "resolved": false,
                                "resolved_date": "-",
                                "service_day": "",
                                "service_time_start": "",
                                "service_time_end": "",
                                "assigned_to": "-",
                              });
                            } else if (time_dropdownvalue == "Specific Time") {
                              FirebaseFirestore.instance
                                  .collection("requests")
                                  .doc("raised")
                                  .collection(psrn)
                                  .doc(request_id)
                                  .set({
                                "request_id": request_id,
                                "user_name": user_name,
                                "user_address": user_address,
                                "user_psrn": psrn,
                                "service_type": widget.serviceType,
                                "service_subtype": subtype_dropdownvalue,
                                "service_schedule": time_dropdownvalue,
                                "request_details": detailsController.text,
                                "created_at": timeCreated,
                                "resolved": false,
                                "resolved_date": "-",
                                "service_day": selDaysField,
                                "service_time_start": _iniTime.toString().substring(10,15),
                                "service_time_end": _finTime.toString().substring(10,15),
                                "assigned_to": "-",
                              });
                              FirebaseFirestore.instance
                                  .collection("requests")
                                  .doc("raised")
                                  .collection(psrn)
                                  .doc(request_id)
                                  .set({
                                "request_id": request_id,
                                "user_name": user_name,
                                "user_address": user_address,
                                "user_psrn": psrn,
                                "service_type": widget.serviceType,
                                "service_subtype": subtype_dropdownvalue,
                                "service_schedule": time_dropdownvalue,
                                "service_day": selDaysField,
                                "service_time_start":
                                    "${_iniTime.format(context).split(" ")[0]} ${_iniTime.period.toString().split(".")[1].toUpperCase()}",
                                "service_time_end":
                                    "${_finTime.format(context).split(" ")[0]} ${_finTime.period.toString().split(".")[1].toUpperCase()}",
                                "request_details": detailsController.text,
                                "created_at": timeCreated,
                                "resolved": false,
                                "resolved_date": "-",
                                "assigned_to": "-",
                              });
                            }
                            showSnack("Request Created", context);
                            setState(() {
                              subtype_dropdownvalue = "Request Subtype";
                              selDaysField = "Any Day";
                              detailsController.clear();
                            });
                            FirebaseFirestore.instance
                                .collection("requests")
                                .doc("admin")
                                .collection("raised")
                                .doc(request_id + psrn)
                                .set({
                              "request_id": request_id,
                              "user_psrn": psrn,
                              "created_at": timeCreated,
                            });
                            }

                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil()
                                    .setSp(30.0))),
                            color: widget.theme,
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
                                fontFamily: "Nunito"),
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          );
        });
  }
}

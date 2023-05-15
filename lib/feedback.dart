import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'res.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'createReq.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'viewFeedbacks.dart';

class submitFeedback extends StatefulWidget {
  const submitFeedback({Key? key}) : super(key: key);

  @override
  _submitFeedbackState createState() => _submitFeedbackState();
}

class _submitFeedbackState extends State<submitFeedback> {

  String feedbackTo="EMU";
  List<String> feedbackRecep=["EMU","Mobile App","Other"];
  TextEditingController feedbackController=TextEditingController();

  String user_name="";
  String user_address="";
  String user_psrn="";
  late bool hasName;
  late bool hasAdd;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    feedbackController=TextEditingController();
    getUser();
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
            height: ScreenUtil().screenHeight,
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
            child: SizedBox(
              height: ScreenUtil().setHeight(2000.0), //.screenHeight*1.1,
              width: ScreenUtil().screenWidth,
              child: Column(
                children: [
                  Expanded(flex:2,
                      child: Container(
                        width: ScreenUtil().screenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Feedback",
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  color: text_light,
                                  fontSize:ScreenUtil().setSp(100.0)),
                            ),
                            /*Text(
                              "Share your valuable feedback regarding EMU services/platform/any other, here",
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  color: text_light,
                                  fontSize:ScreenUtil().setSp(50.0)),
                            ),*/
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
                                        value: feedbackTo,
                                        dropdownColor: bck_Ldark,
                                        borderRadius: BorderRadius.circular(
                                            ScreenUtil().setSp(100.0)),
                                        // Down Arrow Icon
                                        icon: const Icon(
                                            Icons.keyboard_arrow_down),

                                        // Array list of items
                                        items: feedbackRecep.map((String items) {
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
                                            feedbackTo = newValue!;
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
                                      child: TextFormField(
                                        controller: feedbackController,
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
                                            hintText: 'Feedback',
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
                              padding: EdgeInsets.only(
                                  left: ScreenUtil().setSp(20.0),
                                  right: ScreenUtil().setSp(20.0),
                                  top: ScreenUtil().setSp(50.0)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                                  const AutoSizeText(
                                                    "Feedback by",
                                                    style: const TextStyle(
                                                        fontFamily: "Nunito",
                                                        color: text_light,
                                                        fontWeight:
                                                        FontWeight.w100),
                                                  ),
                                                  AutoSizeText(
                                                    user_name.toUpperCase(),
                                                    style: const TextStyle(
                                                        fontFamily: "Nunito",
                                                        color: text_light,
                                                        fontWeight:
                                                        FontWeight.w900),
                                                  ),
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
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>viewFeedbacks()));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(ScreenUtil()
                                    .setSp(30.0))),
                            color: bck_Ldark,
                          ),
                          //color: icon_yellow,
                          padding: EdgeInsets.symmetric(
                              vertical:
                              ScreenUtil().setSp(10),
                              horizontal:
                              ScreenUtil().setSp(10)),
                          child: Text(
                            "View Feedbacks".toUpperCase(),
                            style: const TextStyle(
                              fontFamily: "Nunito",
                            color: text_light),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: GestureDetector(
                        onTap: ()async{
                          SharedPreferences _prefs=await SharedPreferences.getInstance();
                          String psrn=_prefs.getString("user_psrn")??"";
                          String feedback_id=DateTime.now().hashCode.toString();
                          String timeCreated=DateTime.now().toString();

                          FirebaseFirestore.instance.collection("feedbacks").doc("raised")
                          .collection(psrn).doc(feedback_id)
                          .set({
                            "request_id": feedback_id,
                            "user_name": user_name,
                            "user_psrn": psrn,
                            "created_at": timeCreated,
                            "feedback_for":feedbackTo,
                            "feedback":feedbackController.text
                          });

                          showSnack("Feedback Sent", context);

                          setState(() {
                            feedbackTo='EMU';
                            feedbackController.clear();
                          });
                        },
                        child: Container(
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

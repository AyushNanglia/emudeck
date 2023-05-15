import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'res.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'createReq.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class viewFeedbacks extends StatefulWidget {
  const viewFeedbacks({Key? key}) : super(key: key);

  @override
  _viewFeedbacksState createState() => _viewFeedbacksState();
}

class _viewFeedbacksState extends State<viewFeedbacks> {

  String user_psrn="";

  getPsrn()async{
    SharedPreferences _prefs=await SharedPreferences.getInstance();
    setState(() {
      user_psrn=_prefs.getString("user_psrn")??"";
    });
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                      child: Container(
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("feedbacks").doc("raised").collection(user_psrn).where("user_psrn",isEqualTo: user_psrn).snapshots(),
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
                                                  Text(snapshot.data.docs[index]["feedback_for"],style: TextStyle(color: text_light,
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
                                                    child: AutoSizeText(snapshot.data.docs[index]["feedback"],
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
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

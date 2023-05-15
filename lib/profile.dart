import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'res.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'createReq.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';

class profile extends StatefulWidget {
  const profile({Key? key}) : super(key: key);

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<profile> {

  //final SharedPreferences pref=await SharedPreferences.getInstance();

  TextEditingController psrnController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  late String user_name;
  late String user_email;
  late String user_address;
  late String user_phone;
  late String user_psrn;
  Map<String,String> dataFromDevice={};



  saveToDevice(String key,String field)async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    pref.setString(key, field);
  }

  retrieveFromDevice()async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    setState(() {
      dataFromDevice.addAll({"user_name":pref.getString("user_name")??""});
      dataFromDevice.addAll({"user_email":pref.getString("user_email")??""});
      dataFromDevice.addAll({"user_address":pref.getString("user_address")??""});
      dataFromDevice.addAll({"user_phone":pref.getString("user_phone")??""});
      dataFromDevice.addAll({"user_psrn":pref.getString("user_psrn")??""});
    });
  }

  Future editProfile(){
    //retrieveFromDevice();
    setState(() {
      retrieveFromDevice();
    });
    nameController.text=dataFromDevice["user_name"]??"";
    emailController.text=dataFromDevice["user_email"]??"";
    addressController.text=dataFromDevice["user_address"]??"";
    phoneController.text=dataFromDevice["user_phone"]??"";
    psrnController.text=dataFromDevice["user_psrn"]??"";
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext c, void Function(void Function()) setState) {
          return AlertDialog(
            backgroundColor: bck_dark,
            elevation: 10.0,
            title: const Text('Edit User Profile',style: TextStyle(fontFamily: "Nunito",color: text_light),),
            content: Container(
              height: ScreenUtil().screenHeight*0.3,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: psrnController,
                      keyboardType: TextInputType.phone,
                      minLines: 1,
                      validator: (String? s){

                      },
                      //maxLines: 5,
                      style: TextStyle(
                          fontFamily: "Nunito",
                          color: text_light,
                          fontSize:
                          ScreenUtil().setSp(50.0)),
                      decoration: InputDecoration(
                        //border: UnderlineInputBorder(),
                          hintText: 'PSRN',
                          errorText: "PSRN is mandatory",
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
                    TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      minLines: 1,
                      //maxLines: 5,
                      style: TextStyle(
                          fontFamily: "Nunito",
                          color: text_light,
                          fontSize:
                          ScreenUtil().setSp(50.0)),
                      decoration: InputDecoration(
                        //border: UnderlineInputBorder(),
                          hintText: 'Name',
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
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      minLines: 1,
                      //maxLines: 5,
                      style: TextStyle(
                          fontFamily: "Nunito",
                          color: text_light,
                          fontSize:
                          ScreenUtil().setSp(50.0)),
                      decoration: InputDecoration(
                        //border: UnderlineInputBorder(),
                          hintText: 'Email',
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
                    TextFormField(
                      controller: addressController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      //maxLines: 5,
                      style: TextStyle(
                          fontFamily: "Nunito",
                          color: text_light,
                          fontSize:
                          ScreenUtil().setSp(50.0)),
                      decoration: InputDecoration(
                        //border: UnderlineInputBorder(),
                          hintText: 'Residence Address',
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
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      minLines: 1,
                      //maxLines: 5,
                      style: TextStyle(
                          fontFamily: "Nunito",
                          color: text_light,
                          fontSize:
                          ScreenUtil().setSp(50.0)),
                      decoration: InputDecoration(
                        //border: UnderlineInputBorder(),
                          hintText: 'Phone Number',
                          contentPadding: EdgeInsets.all(
                              ScreenUtil().setSp(30.0)),
                          //hintText: ,
                          focusedBorder: InputBorder.none,
                          hintStyle: TextStyle(
                              fontFamily: "Nunito",
                              color: text_light,
                              fontSize: ScreenUtil()
                                  .setSp(50.0))),
                    )


                  ],
                ),
              ),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                        //this.setState(() {});
                        Navigator.pop(context);
                        /*nameController.clear();
                      emailController.clear();
                      addressController.clear();
                      phoneController.clear();*/
                      },
                      child: const Text('Cancel',style: TextStyle(
                        fontFamily: "Nunito",
                        color: text_light,),),
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
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.green),
                      ),
                      onPressed: (){
                        if(psrnController.text.trim().isNotEmpty) {
                          //Navigator.pop(context);
                          saveToDevice("user_psrn", psrnController.text.trim());
                          saveToDevice("user_name", nameController.text.trim());
                          saveToDevice("user_address", addressController.text.trim());
                          saveToDevice("user_email", emailController.text.trim());
                          saveToDevice("user_phone", phoneController.text.trim());

                          FirebaseDatabase.instance.refFromURL("https://emudeck-a21c6-default-rtdb.firebaseio.com/").child("users").child(psrnController.text.trim())
                          .set({
                            "psrn":psrnController.text.trim(),
                            "name":nameController.text.trim(),
                            "address":addressController.text.trim(),
                            "email":emailController.text.trim(),
                            "phone":phoneController.text.trim(),
                            "block":"false",
                            "block_note":"-",
                          });

                          Navigator.pop(context);

                          /*print(FirebaseDatabase.instance.refFromURL("https://emudeck-a354d-default-rtdb.asia-southeast1.firebasedatabase.app")
                              .child(psrnController.text.trim()).path);*/

                          retrieveFromDevice();
                          nameController.clear();
                          emailController.clear();
                          addressController.clear();
                          phoneController.clear();
                          psrnController.clear();
                        }
                        else if(psrnController.text.trim().isEmpty) {
                          //print(psrnController.value.hashCode);
                          showSnack("PSRN cannot be empty", c);
                        }
                        /*if(psrnController.text.trim().isEmpty)
                        showPsrnError=false;
                      else showPsrnError=true;*/
                      },
                      child: const Text('Update',style: TextStyle(
                        fontFamily: "Nunito",
                        color: text_light,),
                      ),
                    ),
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    setState(() {
      retrieveFromDevice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2160),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: bck_dark,
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
                Expanded(flex:2,
                    child:Container(
                      width: ScreenUtil().screenWidth,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Profile",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                color: text_light,
                                fontSize:ScreenUtil().setSp(100.0)),
                          ),
                        ],
                      ),
                    )),
                Expanded(flex:9,
                    child: SingleChildScrollView(
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              //height: ScreenUtil().setHeight(500),
                              margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(100)),
                              width: ScreenUtil().screenWidth,
                              padding: EdgeInsets.all(ScreenUtil().setSp(40.0)),
                              decoration: BoxDecoration(
                                  color: bck_dark,
                                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(50.0))),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(ScreenUtil().setSp(0.0),ScreenUtil().setSp(10.0)),
                                        blurRadius: ScreenUtil().setSp(20.0),
                                        color: Colors.black38
                                    )
                                  ]
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(ScreenUtil().setSp(10.0)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children:  [
                                            Text("Name",style: TextStyle(fontFamily: "Nunito",color: text_light,fontWeight: FontWeight.w900),),
                                            AutoSizeText(dataFromDevice["user_name"]??"-",style: TextStyle(fontFamily: "Nunito",color: text_light,),maxLines: 1,)
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children:  [
                                            Text("PSRN",style: TextStyle(fontFamily: "Nunito",color: text_light,fontWeight: FontWeight.w900),),
                                            AutoSizeText(dataFromDevice["user_psrn"]??"-",style: TextStyle(fontFamily: "Nunito",color: text_light,),maxLines: 1,)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(ScreenUtil().setSp(10.0)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:  [
                                        Text("Email",style: TextStyle(fontFamily: "Nunito",color: text_light,fontWeight: FontWeight.w900),),
                                        AutoSizeText(dataFromDevice["user_email"]??"-",style: TextStyle(fontFamily: "Nunito",color: text_light,),maxLines: 1,)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(ScreenUtil().setSp(10.0)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:  [
                                        AutoSizeText("Address",style: TextStyle(fontFamily: "Nunito",color: text_light,fontWeight: FontWeight.w900),),
                                        AutoSizeText(dataFromDevice["user_address"]??"-",style: TextStyle(fontFamily: "Nunito",color: text_light,),maxLines: 1,)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(ScreenUtil().setSp(10.0)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:  [
                                        AutoSizeText("Contact",style: TextStyle(fontFamily: "Nunito",color: text_light,fontWeight: FontWeight.w900),),
                                        AutoSizeText(dataFromDevice["user_phone"]??"-",style: TextStyle(fontFamily: "Nunito",color: text_light,),maxLines: 1,)
                                      ],
                                    ),
                                  )

                                ],
                              ),
                            ),
/*                            Container(
                              //color: Colors.white,
                              //height: 200,
                              width: ScreenUtil().screenWidth*1.0,
                              alignment: Alignment.bottomCenter,
                              child: CircularPercentIndicator(
                                progressColor: icon_yellow,
                                backgroundColor: bck_Ldark,
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
                                radius: ScreenUtil().screenWidth*0.25,
                              ),
                            )*/
                          ],
                        )
                    )
                ),
                Expanded(flex:1,
                    child: Container(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            retrieveFromDevice();
                          });
                          editProfile();
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
                            "Edit".toUpperCase(),
                            style: const TextStyle(
                              fontFamily: "Nunito",),
                          ),
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

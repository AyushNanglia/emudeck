import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'res.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'createReq.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:page_transition/page_transition.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class services extends StatefulWidget {
  bool isAdmin;
  services({Key? key, required this.isAdmin}) : super(key: key);

  @override
  _servicesState createState() => _servicesState();
}

class _servicesState extends State<services> {
  String user="Ayush";
  DateTime date=DateTime.now();
  //CollectionReference users = FirebaseFirestore.instance.collection('services');
  String user_name="there";
  String user_psrn="";
  late String isBlocked;
  late String blockDesc;

  getPsrn()async{
    SharedPreferences _prefs=await SharedPreferences.getInstance();
    setState(() {
      user_psrn=_prefs.getString("user_psrn")??"";
    });

    DatabaseReference ref=FirebaseDatabase.instance.ref("users/$user_psrn");
    DatabaseEvent event=await ref.once();
    setState(() {
      isBlocked=event.snapshot.children.elementAt(1).value.toString();
      blockDesc=event.snapshot.children.elementAt(2).value.toString();
    });
  }

  Future getUser()async{
    SharedPreferences _pref=await SharedPreferences.getInstance();
    String val=_pref.getString("user_name")??"there";
    setState(() {
      if(val.trim().isEmpty)
      user_name="there";
      else user_name=val;
      //user_address=_pref.getString("user_address")??"";
    });
  }

  Widget serviceCard(String e_title, Color theme){//, Color grad){
    //if(e_title.isEmpty) e_title="";
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>createReq(serviceType: e_title,theme: theme,isAdmin: widget.isAdmin,)));
      },
      child: Container(

        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: theme,
            /*gradient: LinearGradient(
              colors: [
                  theme,
                  //grad
              ]
            ),*/
            //shape: BoxShape.circle
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Icon(Icons.settings,color: Colors.black,),
            AutoSizeText(e_title.toUpperCase(),style: TextStyle(fontFamily:"Nunito",color: Colors.black),
            maxLines: 1,)
          ],
        ),
      ),
    );
  }

  Widget drawerCard(String e_title,String path,Color theme){
    return GestureDetector(
      onTap: (){
        Navigator.popAndPushNamed(context, path);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30.0)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(50.0))),
          color: theme,
        ),
        height: ScreenUtil().setHeight(200),
        alignment: Alignment.center,
        child: Text(e_title,style: TextStyle(fontFamily:"Nunito",color: text_light,
            fontSize:ScreenUtil().setSp(50.0) ),),
      ),
    );
  }

  Future showFac(Map<String,String> obj){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)=>StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(30.0)))
            ),
            //actions: [Text("Bruh")],
            title:Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(obj["name"].toString(),style: TextStyle(color: text_light),maxLines: 1,overflow: TextOverflow.fade,),
                Text(obj["psrn"].toString(),style: TextStyle(color: text_light),)
              ],
            ),
            backgroundColor: bck_Ldark,
            content: SingleChildScrollView(
              child: Container(
                //height: ScreenUtil().screenHeight*0.3,
                width: ScreenUtil().screenWidth*0.3,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("""
                          You are yet to file a request for the Urgent Request Services,
                          head over to the section to complete the same. """,
                    style: TextStyle(color: text_light),),
                    Column(
                      children: [
                        const Text("""
                              Note from Admin:""",
                          style: TextStyle(color: text_light),),
                        Text(blockDesc,
                          style: const TextStyle(color: text_light),),
                      ],
                    )
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 1,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.popAndPushNamed(context, '/urgentReq');
                      },
                      child: Container(
                        //margin: EdgeInsets.symmetric(horizontal: 10.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(left:
                          Radius.circular(ScreenUtil()
                              .setSp(30.0))),
                          color: bck_dark,
                        ),
                        //color: icon_yellow,
                        padding: EdgeInsets.symmetric(
                            vertical:
                            ScreenUtil().setSp(15),
                            horizontal:
                            ScreenUtil().setSp(15)),
                        child: Text(
                          "File request".toUpperCase(),
                          style: const TextStyle(
                              fontFamily: "Nunito",
                              color: text_light),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    date=DateTime.now();
    getPsrn();
    getUser();
    //isBlocked;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bck_dark,
      //extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: bck_dark,
        actionsIconTheme: IconThemeData(
          color: icon_yellow,
        ),
        //leadingWidth: ScreenUtil().setWidth(400),
        leading: IconButton(
          onPressed: (){
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          },
          icon: Icon(Icons.logout,color: text_light,),
        ),
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
      drawerScrimColor: Color.fromRGBO(0, 0, 0, 50.0),

      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex:2, child: Container(
              //color: bck_Ldark,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                            "Hello ${user_name.split(" ")[0]}",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                color: text_light,
                                fontSize: ScreenUtil().setSp(100.0)),
                          )
                        ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                      child: Text(
                        formatDate(date),
                        style: TextStyle(
                            fontFamily: "Nunito",
                            color: text_light,
                            fontSize:ScreenUtil().setSp(50.0)),
                      ),)
                ],
              ),
            )),
            Expanded(flex:10,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                  width: MediaQuery.of(context).size.width*1.0,
                  //color: Colors.yellow[100],
                  child: GridView.count(crossAxisCount: 2,
                    crossAxisSpacing: MediaQuery.of(context).size.width*0.05,
                    mainAxisSpacing: MediaQuery.of(context).size.width*0.05,
                  children:[
                    serviceCard("Plumber", icon_green),//,icon_darkGreen),
                    serviceCard("Electrician", icon_purple),//,icon_darkPurple),
                    serviceCard("Gardener", icon_brown),//,icon_darkBrown),
                    serviceCard("Sweeper", icon_yellow),//, icon_darkYellow),
                    serviceCard("Blacksmith", icon_green),//,icon_darkGreen),
                    serviceCard("Mason", icon_brown),//,icon_darkBrown),
                    serviceCard("Carpenter", icon_purple),
                    serviceCard("Painter", icon_yellow),//,icon_darkPurple),
                    serviceCard("Misc", icon_green),//,icon_darkYellow)
                  ]
                  )
                  /*ListView.builder(
                      itemCount: 7,
                      itemBuilder:(context, int index){
                        return Container(
                          decoration: const BoxDecoration(
                              color: icon_purple,
                              shape: BoxShape.circle
                          ),
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children:const[
                              Icon(Icons.settings,color: Colors.black,),
                              Text("Plumber",style: TextStyle(fontFamily:"Nunito",color: Colors.black),)
                            ],
                          ),
                        );
                      })*/
                )
            ),
          ],
        ),

      ),
    );
  }
}

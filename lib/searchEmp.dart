import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'res.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'createReq.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'misc/search.dart';
import 'models/facultyModel.dart';

class searchEmp extends StatefulWidget {
  const searchEmp({Key? key}) : super(key: key);

  @override
  _searchEmpState createState() => _searchEmpState();
}

class _searchEmpState extends State<searchEmp> {

  late TextEditingController nameController;//=TextEditingController();
  List<String> result=[];
  Map<String,dynamic> facMap={};
  bool createReq=false;
  late  TextEditingController _detailsControl;
  late String createBlockText;

  getFacs()async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    DatabaseEvent event = await ref.once();
    for(int i=0; i<event.snapshot.children.length; i++) {
      facultyModel model = facultyModel.fromDB(event.snapshot.children
          .elementAt(i)
          .value);

      facMap["${model.fac_psrn}#${model.fac_name}"]={
        "name":model.fac_name,
        "phone":model.fac_phone,
        "email":model.fac_email,
        "address":model.fac_address,
        "psrn":model.fac_psrn,
        "block":model.fac_block,
        "block_note":model.fac_block_note
      };

      print(facMap[model.fac_psrn]);

    }
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //createReq==false?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: null, icon: Icon(Icons.mail_outline_rounded,color: icon_yellow,)),
                        IconButton(onPressed: null, icon: Icon(Icons.phone_outlined,color: icon_green,)),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              ScreenUtil().setSp(30.0)),
                          color: bck_dark),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                            ScreenUtil().setSp(20.0)),
                        child: TextFormField(
                          controller: _detailsControl,
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
                              hintText: 'Description',
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
                    )],
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
                        Navigator.pop(context);
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
                          "Close".toUpperCase(),
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            color: text_light),
                        ),
                      ),
                    ),
                  ),
                  Expanded(flex: 1,
                    child: GestureDetector(
                      onTap: (){
                        obj["block"] = "true";
                        obj["block_note"] = _detailsControl.text;
                        FirebaseDatabase.instance
                            .ref("users")
                            .child(obj["psrn"].toString())
                            .update({
                          "block": obj["block"],
                          "block_note": obj["block_note"]
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        //margin: EdgeInsets.symmetric(horizontal: 10.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(right:
                              Radius.circular(ScreenUtil()
                                  .setSp(30.0))),
                          color: icon_yellow,
                        ),
                        //color: icon_yellow,
                        padding: EdgeInsets.symmetric(
                            vertical:ScreenUtil().setSp(15),
                            horizontal:ScreenUtil().setSp(15)),
                        child: Text(
                          "Create Block".toUpperCase(),
                          style: const TextStyle(
                            fontFamily: "Nunito",),
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
    nameController=TextEditingController();
    _detailsControl=TextEditingController();
    createBlockText="Create Block";
    getFacs();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1080, 2160),
        minTextAdapt: true,
        splitScreenMode: true,
        builder:(BuildContext context, Widget? child){
          return Scaffold(
            backgroundColor: bck_dark,
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
            body: Padding(
              padding: EdgeInsets.all(ScreenUtil().setSp(40.0)),
              child: Container(
                height: ScreenUtil().screenHeight, //.screenHeight*1.1,
                width: ScreenUtil().screenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex:2,
                      child: Container(
                        width: ScreenUtil().screenWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Search Faculty",
                              style: TextStyle(
                                  fontFamily: "Nunito",
                                  color: text_light,
                                  fontSize:ScreenUtil().setSp(100.0)),
                            ),
                            Container(
                              width: ScreenUtil().screenWidth,
                              alignment: Alignment.center,
                              child: Container(
                                width: ScreenUtil().screenWidth*0.9,
                                height: ScreenUtil().screenHeight*0.07,
                                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20.0)),
                                decoration: BoxDecoration(
                                  color: bck_Ldark,
                                  borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(30.0)))
                                ),
                                alignment: Alignment.centerLeft,
                                child: TextFormField(
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
                                      hintText: 'Search by Name or PSRN',
                                      contentPadding: EdgeInsets.all(
                                          ScreenUtil().setSp(30.0)),
                                      //hintText: ,
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          fontFamily: "Nunito",
                                          color: text_light,
                                          fontStyle: FontStyle.italic,
                                          fontSize: ScreenUtil()
                                              .setSp(50.0))),
                                  onChanged:(query){
                                    result=StringSearch(facMap.keys.toList(), query).relevantResults();
                                    print(result);
                                    setState(() {

                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(flex:9,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(30.0)),
                            height: ScreenUtil().screenHeight*0.9,
                            width: ScreenUtil().screenWidth,
                            alignment: Alignment.centerLeft,
                            child: ListView.builder(
                              itemCount: result.length,
                              itemBuilder: (BuildContext context, int index) {
                                Color block_color=bck_Ldark;
                                if(facMap[result[index]]["block"]=="false"){
                                  block_color=bck_Ldark;
                                }
                                else {
                                  block_color=Colors.red;
                                }
                                return GestureDetector(
                                  onTap: (){
                                    /*setState(() {
                                      createReq=!createReq;
                                    });*/
                                    showFac(facMap[result[index]]);
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.symmetric(vertical: ScreenUtil().setSp(20.0),horizontal: ScreenUtil().setSp(20.0)),
                                    //padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20.0)),
                                    height: ScreenUtil().screenHeight*0.1,
                                    width: ScreenUtil().screenWidth*0.9,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(30.0))),
                                      color: bck_Ldark,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(flex:7,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setSp(20.0)),
                                              child: Text(result[index].split("#")[1],style: TextStyle(color: text_light)),
                                            )
                                        ),
                                        Expanded(flex:1,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: ScreenUtil().screenHeight*0.1,
                                            decoration: BoxDecoration(
                                              //borderRadius: BorderRadius.horizontal(right:Radius.circular(ScreenUtil().setSp(30.0))),
                                              color: bck_Ldark,
                                            ),
                                            child: Icon(Icons.block_outlined,color: block_color,),
                                          ),
                                        ),
                                        Expanded(flex:2,
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: ScreenUtil().screenHeight*0.1,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.horizontal(right:Radius.circular(ScreenUtil().setSp(30.0))),
                                              color: text_light,
                                            ),
                                            child: Text(result[index].split("#")[0],style: TextStyle(color: bck_dark),),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },),
                          ),
                        )
                    ),
/*
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(flex:1,
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
                            Expanded(flex:1,
                              child: GestureDetector(
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
*/
                  ],
                ),
              ),
            ),
          );
        });
  }
}

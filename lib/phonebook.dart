import 'package:flutter/material.dart';
import 'res.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class phonebook extends StatefulWidget {
  bool isAdmin;
  phonebook({Key? key,required this.isAdmin}) : super(key: key);

  @override
  _phonebookState createState() => _phonebookState();
}

class _phonebookState extends State<phonebook> {

  //DatabaseReference _dbRef=FirebaseDatabase.instance.ref("contacts");

  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController desigController=TextEditingController();

  call(String phoneNumber) async {
    /*final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );*/
    //await launch(phoneNumber);
    await launchUrl(Uri.parse("tel:$phoneNumber"));
  }

  email(String emailAdd)async{
    await launchUrl(Uri.parse("mailto:$emailAdd"));
  }

  Future addCont(){
    //retrieveFromDevice();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: bck_dark,
        elevation: 10.0,
        title: const Text('Add Contact',style: TextStyle(fontFamily: "Nunito",color: text_light),),
        content: Container(
          height: ScreenUtil().screenHeight*0.3,
          child: Column(
            children: [
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
                    ScreenUtil().setSp(50.0),overflow: TextOverflow.fade),
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
                controller: desigController,
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
                    hintText: 'Designation',
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
                    Navigator.pop(context);
                    nameController.clear();
                    emailController.clear();
                    desigController.clear();
                    phoneController.clear();
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
                    Navigator.pop(context);

                    FirebaseFirestore.instance.collection("phonebook").doc(nameController.text)
                    .set({"name":nameController.text,"email":"${emailController.text}@pilani.bits-pilani.ac.in",
                          "phone": "01596${phoneController.text}","desig":desigController.text,
                          "timestampAdded":DateTime.now()});
                    nameController.clear();
                    emailController.clear();
                    desigController.clear();
                    phoneController.clear();
                  },
                  child: const Text('Add',style: TextStyle(
                    fontFamily: "Nunito",
                    color: text_light,),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future delCont(var obj){
    //retrieveFromDevice();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: bck_dark,
        elevation: 10.0,
        //title: const Text('Edit User Profile',style: TextStyle(fontFamily: "Nunito",color: text_light),),
        content: Text("Delete Contact?",style: TextStyle(
          fontFamily: "Nunito",
          color: text_light,)),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: bck_Ldark,
                ),
                padding: EdgeInsets.symmetric(vertical: 0.0),
                child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateColor.resolveWith((states) => text_light),
                  ),
                  onPressed: () {
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
                    FirebaseFirestore.instance.collection("phonebook").doc(obj["name"]).delete();
                    Navigator.pop(context);
                  },
                  child: const Text('Delete',style: TextStyle(
                    fontFamily: "Nunito",
                    color: text_light,),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }



  /*Widget drawerCard(String title,String path,Color theme){
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
        child: Text(title,style: TextStyle(fontFamily:"Nunito",color: text_light,
            fontSize:ScreenUtil().setSp(50.0) ),),
      ),
    );
  }
*/
  Widget phoneCard(var obj){
    return GestureDetector(
      onLongPress:()=>delCont(obj),
      child: Container(
        margin: EdgeInsets.only(bottom: ScreenUtil().setSp(30.0)),
        padding: EdgeInsets.all(ScreenUtil().setSp(20.0)),
        height: ScreenUtil().setHeight(250),
        width: ScreenUtil().setWidth(700),
        decoration: BoxDecoration(
            color: bck_Ldark,
            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(50.0))),
        ),
        child: Row(
          children: [
            Expanded(flex:5,
                child: Container(
                  padding: EdgeInsets.all(ScreenUtil().setSp(10.0)),
                  decoration: BoxDecoration(
                      color: bck_Ldark,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(ScreenUtil().setSp(50.0)),
                          topLeft: Radius.circular(ScreenUtil().setSp(50.0)))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: AutoSizeText(obj["name"],maxLines: 1,
                          style: TextStyle(fontFamily: "Nunito",color: text_light,fontSize: ScreenUtil().setSp(55.0)),),
                      ),
                      Container(
                        child: AutoSizeText(obj["desig"],maxLines: 2,
                          style: TextStyle(fontFamily: "Nunito",color: text_light,fontSize:ScreenUtil().setSp(45.0),
                              fontStyle: FontStyle.italic),),
                      )
                    ],
                  ),
                  //color: Colors.grey,
                )),
            Expanded(flex:2,
                child: Container(
                  decoration: BoxDecoration(
                      color: bck_Ldark,
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(ScreenUtil().setSp(50.0)),
                          topRight  : Radius.circular(ScreenUtil().setSp(50.0)))
                  ),
                  child: Row(
                    children: [
                      IconButton(onPressed:()=>email(obj["email"]), icon: Icon(Icons.mail_outline_rounded,color: icon_yellow,)),
                      IconButton(onPressed:()=>call(obj["phone"]), icon: Icon(Icons.phone_outlined,color: icon_green,)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bck_dark,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: bck_dark,
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
          icon: Icon(Icons.arrow_back_ios_rounded),
          color: text_light,
        ),
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
            children: drawerCards
            ,
          ),
        ),
      ),
      drawerScrimColor: Color.fromRGBO(0, 0, 0, 50.0),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setSp(40.0)),
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        child: Container(
          height: ScreenUtil().setHeight(2000.0), //.screenHeight*1.1,
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
                        GestureDetector(
                          onTap: () {
                            if(widget.isAdmin==true) {
                              addCont();
                            }
                          },
                          child: Text(
                            "Phonebook",
                            style: TextStyle(
                                fontFamily: "Nunito",
                                color: text_light,
                                fontSize:ScreenUtil().setSp(100.0)),
                          ),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 9,
                  child: Container(
                    alignment: Alignment.center,
                    width: ScreenUtil().screenWidth,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("phonebook").orderBy("timestampAdded").snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                        if(snapshot.hasError) {
                          return Container(
                            height: 3.0,
                            width: ScreenUtil().screenWidth*0.1,
                            child: Center(
                              child: const LinearProgressIndicator(
                                //minHeight: 10.0,
                                backgroundColor: bck_Ldark,
                                color: text_light,
                              ),
                            ),
                          );
                        }
                        if(!snapshot.hasData) {
                          return Container(
                            height: 3.0,
                            width: ScreenUtil().screenWidth*0.1,
                            child: Center(
                              child: const LinearProgressIndicator(
                                //minHeight: 10.0,
                                backgroundColor: bck_Ldark,
                                color: text_light,
                              ),
                            ),
                          );
                        }
                        else {
                          return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (BuildContext context, int index) {

                                return phoneCard(snapshot.data?.docs.elementAt(index));

                            },

                          );
                        }
                      },
                    ),
                   )),
            ],
          ),
        ),
      ),
    );
  }
}

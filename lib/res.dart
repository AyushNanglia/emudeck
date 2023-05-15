import 'dart:collection';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

const bck_dark=Color.fromRGBO(42, 42, 42, 1.0);
const bck_Ldark=Color.fromRGBO(59, 59, 59, 1.0);
const icon_green=Color.fromRGBO(192, 222, 221, 1.0);
const icon_darkGreen=Color.fromRGBO(139, 186, 185, 1.0);
const icon_purple=Color.fromRGBO(230, 223, 241, 1.0);
const icon_darkPurple=Color.fromRGBO(174, 148, 214, 1.0);
const icon_brown=Color.fromRGBO(242, 223, 222, 1.0);
const icon_darkBrown=Color.fromRGBO(246, 181, 178,1.0);
const icon_yellow=Color.fromRGBO(242, 238, 233, 1.0);
const icon_darkYellow=Color.fromRGBO(241, 215, 183,1.0);
const text_light=Colors.white;
List<Widget> drawerCards=[
  drawerCard(title:"Service Requests", theme: Colors.grey, path: "/serviceReq"),
  drawerCard(title:"Service Employees", theme: Colors.grey, path: "/serviceEmp"),
  drawerCard(title:"Home", path:'/services', theme:bck_Ldark,),
  drawerCard(title:"Phonebook", path:'/phonebook', theme:bck_Ldark,),
  drawerCard(title:"My Profile", path:'/profile', theme:bck_Ldark),
  drawerCard(title:"My Requests", path:'/myRequests', theme:bck_Ldark),
  drawerCard(title:"Download Forms", path:'/services', theme:bck_Ldark),
  drawerCard(title:"Submit Feedback", path:'/feedback', theme:bck_Ldark),
  drawerCard(title:"Urgent Request", path:'/urgentReq', theme:Colors.red),
];

String formatDate(DateTime curr){
  Map<int,String> months=HashMap();
  months={1:'January',2:'February',3:'March',4:'April',5:'May',6:'June',
          7:'July',8:'August',9:'September',10:'October',11:'November',12:'December'};
  String date="";
  date="${months[curr.month]} ${curr.day}, ${curr.year}";
  return date;
}

class drawerCard extends StatelessWidget {
  String title;
  Color theme;
  String path;
  drawerCard({Key? key,required this.title,required this.theme,required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

showSnack(String err,BuildContext c){
  SnackBar error=SnackBar(
    content: Text(err,style: TextStyle(fontStyle: FontStyle.italic),),
    duration: Duration(seconds: 2),
    //animation: 5.0,
  );

  return ScaffoldMessenger.of(c).showSnackBar(error);
}

Future errorDialog(BuildContext context,String title_text){
  return showDialog(
    context: context,
    builder: (BuildContext context)=>StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(ScreenUtil().setSp(30.0)))
          ),
          //actions: [Text("Bruh")],
          //title: Text(title_text,style: TextStyle(color: text_light),),
          backgroundColor: bck_dark,
          content: Text(title_text,style: TextStyle(color: text_light),),
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
                  Navigator.popAndPushNamed(context, '/profile');
                  /*nameController.clear();
                    emailController.clear();
                    addressController.clear();
                    phoneController.clear();*/
                },
                child: const Text('Go to Profile',style: TextStyle(
                  fontFamily: "Nunito",
                  color: text_light,),),
              ),
            )
          ],
        );
      },
    ),
  );
}


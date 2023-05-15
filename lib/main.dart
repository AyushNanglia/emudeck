import 'package:flutter/material.dart';
import 'res.dart';
import 'services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:emudeck/phonebook.dart';
import 'feedback.dart';
import 'urgentReq.dart';
import 'profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:emudeck/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emudeck/myRequests.dart';
import 'serviceReq.dart';
import 'adminDash.dart';
import 'serviceEmp.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async{
    const bool isAdmin=false;
    runApp(MaterialApp(
      initialRoute: '/main',
      routes: {
        '/main':(context)=>login(),
        '/services':(context)=>services(isAdmin: isAdmin),
        '/phonebook':(context)=>phonebook(isAdmin: isAdmin,),
        '/feedback':(context)=>submitFeedback(),
        '/urgentReq':(context)=>urgentReq(isAdmin: isAdmin,),
        '/profile':(context)=>profile(),
        '/myRequests':(context)=>myRequests(),
        '/serviceReq' :(context)=>serviceReq(),
        '/serviceEmp' :(context)=>serviceEmp()
      },
      theme: ThemeData(
        fontFamily: "Nunito",
      ),
      home: login(),
    ),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

}

class login extends StatefulWidget {

  login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  bool isAdmin=false;
  final GoogleSignIn _gsignIn=GoogleSignIn();

  googleSignIn()async{
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email'],
      /*signInOption: [
        GoogleSignInOption.prompt,
      ],*/
    );
    GoogleSignInAccount? gUser=await googleSignIn.signIn();
    GoogleSignInAuthentication? googleAuth=await gUser?.authentication;
    AuthCredential credential=GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken:googleAuth?.idToken
    );

    UserCredential _user=await FirebaseAuth.instance.signInWithCredential(credential);
    String _userEmail=_user.user?.email??"";
    if(_userEmail.split("@")[1]!="pilani.bits-pilani.ac.in") {
      print("Log-in with your org email only");
      //print(_user.user?.email);
      //print(_user.user?.displayName);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>services(isAdmin: isAdmin,)));
    }
    else{
      print(_userEmail);
      print(_user.user?.displayName);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>services(isAdmin: isAdmin,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1080, 2160),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context,child){
      return Scaffold(
          body: Container(
            color: bck_dark,
            child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("emudeck".toUpperCase(),
                  style: TextStyle(fontFamily:"Nunito",color: text_light,fontSize: ScreenUtil().setHeight(110)),),
                Text("bits pilani".toUpperCase(),style: TextStyle(fontFamily:"Nunito",color: text_light,fontSize: ScreenUtil().setHeight(65),
                    letterSpacing: 5.0),),
                Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  child: TextButton(
                      onPressed: (){
                        Navigator.popAndPushNamed(context, '/services');
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>adminDash()));
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>services(isAdmin: isAdmin,)));
                        /*_gsignIn.signIn().then((value){
                          String? _userName=value!.displayName;
                          String _userEmail=value!.email;
                          print(_userEmail);
                        });*/
                        //googleSignIn();
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          color: bck_Ldark,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),

                        child: Text("Sign-In",style: TextStyle(fontFamily:"Nunito",color: text_light),),
                      )
                  ),
                )

              ],
            )),
          )
      );
    });
  }
}

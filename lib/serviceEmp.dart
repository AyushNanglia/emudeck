import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'res.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'requestModel.dart';
//import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:expandable/expandable.dart';

class serviceEmp extends StatefulWidget {
  const serviceEmp({Key? key}) : super(key: key);

  @override
  _serviceEmpState createState() => _serviceEmpState();
}

class _serviceEmpState extends State<serviceEmp> {

  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController addressController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  String team_dropdownvalue="Select Domain";
  //=[];

  Future addEmp(){
    //retrieveFromDevice();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext c, void Function(void Function()) setState) {
          return AlertDialog(
            backgroundColor: bck_dark,
            elevation: 10.0,
            title: const Text('Add an Employee',style: TextStyle(fontFamily: "Nunito",color: text_light),),
            content: Container(
              height: ScreenUtil().screenHeight*0.3,
              width: ScreenUtil().screenWidth*0.7,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: ScreenUtil().screenWidth*0.7,
                        decoration: BoxDecoration(
                            border: Border.all(color: text_light),
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setSp(100.0))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              ScreenUtil().setSp(20.0)),
                          child: DropdownButton<String>(
                            //elevation: 0,
                            underline: const Text(""),
                            iconDisabledColor: Colors.red,
                            iconEnabledColor: bck_Ldark,
                            style: const TextStyle(
                                fontFamily: "Nunito",
                                color: text_light),
                            value: team_dropdownvalue,
                            dropdownColor: bck_Ldark,
                            borderRadius: BorderRadius.circular(
                                ScreenUtil().setSp(100.0)),
                            // Down Arrow Icon
                            icon: const Icon(
                                Icons.keyboard_arrow_down),

                            // Array list of items
                            items: ["Select Domain","Blacksmith","Carpenter","Electrician",
                            "Gardner","Mason","Painter","Plumber","Sweeper"].map((String items) {
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
                                team_dropdownvalue = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
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
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
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
                      ),
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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: bck_Ldark,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: bck_Ldark,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 0.0),
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith((states) => Colors.green),
                      ),
                      onPressed: (){
                        print("I mean");
                        print("$team_dropdownvalue ${nameController.text} ${phoneController.text}");
                        //service_emp["Blacksmith"]?.add("${nameController.text}#${phoneController.text}");
                        service_emp[team_dropdownvalue]!.add("${nameController.text}#${phoneController.text}");
                        if(team_dropdownvalue!="Select Domain") {
                          FirebaseFirestore.instance
                              .collection("categories")
                              .doc(team_dropdownvalue)
                              .set({"service_emp": service_emp[team_dropdownvalue]});
                        }

                        print(service_emp);
                        Navigator.pop(context);
                        nameController.clear();
                        phoneController.clear();
                        team_dropdownvalue="Select Domain";
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
          );
        },
      ),
    );
  }


/*
  Widget phoneCard(var obj){
    return GestureDetector(
      //onLongPress:()=>delCont(obj),
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
                      IconButton(onPressed: null, icon: Icon(Icons.mail_outline_rounded,color: icon_yellow,)),
                      IconButton(onPressed: null, icon: Icon(Icons.phone_outlined,color: icon_green,)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
*/

  Widget empCard(String name){
    return Container(
      width: ScreenUtil().screenWidth*0.8,
      child: Row(
        mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: [
          Text(name,style: const TextStyle(color: text_light),),
          const IconButton(onPressed: null, icon: Icon(Icons.phone_outlined,color: icon_green,))
        ],
      ),
    );
  }

  final ExpandableController _blacksmithControl=ExpandableController();
  final ExpandableController _carpenterControl=ExpandableController();
  final ExpandableController _electricianControl=ExpandableController();
  final ExpandableController _gardenerControl=ExpandableController();
  final ExpandableController _plumberControl=ExpandableController();
  final ExpandableController _sweeperControl=ExpandableController();
  final ExpandableController _miscControl=ExpandableController();
  final ExpandableController _masonControl=ExpandableController();
  final ExpandableController _painterControl=ExpandableController();

  //final GlobalKey tileState=GlobalKey();

  Widget expCard(String title, int listLen, ExpandableController _controller){

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: ExpandablePanel(
        //controller: _controller,
        theme: const ExpandableThemeData(
          hasIcon: false,
          headerAlignment: ExpandablePanelHeaderAlignment.center,
          tapBodyToCollapse: true,
          iconColor: icon_yellow
        ),
        //key: tileState,
        header: Container(
          padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(70.0),
          horizontal: ScreenUtil().setHeight(30.0)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(ScreenUtil().setHeight(20.0))),
              color: bck_Ldark
          ),
          child: Text(
            title,
            style: TextStyle(color: icon_yellow),
          ),
        ),
        collapsed: const Text(
          "",
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        expanded: Container(
          margin: EdgeInsets.only(bottom: ScreenUtil().setSp(30.0)),
          decoration: BoxDecoration(
              color: bck_Ldark,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(ScreenUtil().setSp(20.0)),
                top:Radius.circular(ScreenUtil().setSp(0.0)))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (String obj in service_emp[title]!)
                if(obj!="")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        obj.toString().split("#")[0],
                        style: const TextStyle(color: icon_yellow),
                      ),
                      const IconButton(
                        onPressed: null,
                        icon: Icon(Icons.phone_outlined,color: icon_green,),
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

/*
  Widget categoryCard(String title, int listLen){
    */
/*FirebaseFirestore.instance.collection("categories").doc(title).get().then((value){
      setState(() {
        service_emp[title]=List.from(value[service_emp]);
      });
    });*//*

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTileCard(
          title: Text(title,style: const TextStyle(color: text_light),),
          baseColor: bck_Ldark,
          expandedColor: bck_Ldark,
          trailing: const Icon(Icons.keyboard_arrow_down,color: text_light,),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //color: bck_dark,
                height: ScreenUtil().screenHeight*0.2,
                child: ListView.builder(
                  itemCount: listLen,
                  itemBuilder: (BuildContext context,index) {
                    if(listLen==0) {
                      return const Text(
                        "Well",
                        style: TextStyle(color: icon_yellow),
                      );
                    }
                    else{
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              service_emp[title]![index].toString().split("#")[0],
                              style: const TextStyle(color: icon_yellow),
                            ),
                            const IconButton(
                                onPressed: null,
                                icon: Icon(Icons.phone_outlined,color: icon_green,),
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            )
            ]
      ),
    );
  }
*/

  late Map<String,List> service_emp;
  late List<String> category_list;

  populateList()async{

    for(int i=0; i<category_list.length; i++) {
      FirebaseFirestore.instance
          .collection("categories")
          .doc(category_list.elementAt(i))
          .get()
          .then((value) {
            //print(List.from(value["service_emp"]));
            setState(() {
              service_emp[category_list.elementAt(i)] = List.from(value["service_emp"]);
              print(service_emp);
              //service_emp["Blacksmith"]?.addAll(List.from(value[category_list[i]]));
              //service_emp.addEntries(List.from(value[category_list[i]]));
          //print("----- Added ${category_list[i]} with service_emp length: ${service_emp.length}");
        });
      });
    }
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    service_emp={};
    category_list=["Blacksmith","Carpenter","Electrician","Gardener","Mason","Misc","Painter","Plumber","Sweeper",];
    populateList();
    //print("Imported ${service_emp["Blacksmith"]} contacts.");
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1080, 2160),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
              backgroundColor: bck_dark,
              resizeToAvoidBottomInset: true,
              floatingActionButton:FloatingActionButton.extended(
                  onPressed: addEmp,
                  backgroundColor: bck_dark,
                  label: const Text("Add Employee",style: TextStyle(color: text_light),)),
              appBar: AppBar(
                title: Text("Admin View".toUpperCase(),style: const TextStyle(color: bck_Ldark),),
                centerTitle: true,
                actionsIconTheme: const IconThemeData(
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
                                GestureDetector(
                                  onTap: (){
                                    setState(() {});
                                  },
                                  child: Text(
                                    "Service employees",
                                    style: TextStyle(
                                        fontFamily: "Nunito",
                                        color: text_light,
                                        fontSize:ScreenUtil().setSp(100.0)),
                                  ),
                                ),
/*
                              const Text(
                                "Oldest to newest",
                                style: TextStyle(
                                  color: text_light,
                                  fontStyle: FontStyle.italic,),
                              )
*/
                              ],
                            ),
                          )),
                      Expanded(flex:9,
                          child: Container(
                            child: ListView(
                              children: [
                                expCard("Blacksmith",service_emp["Blacksmith"]!.length,_blacksmithControl),
                                expCard("Carpenter",service_emp["Carpenter"]!.length,_carpenterControl),
                                expCard("Electrician",service_emp["Electrician"]!.length,_electricianControl),
                                expCard("Gardener",service_emp["Gardener"]!.length,_gardenerControl),
                                expCard("Sweeper",service_emp["Sweeper"]!.length,_sweeperControl),
                                expCard("Mason",service_emp["Mason"]!.length,_masonControl),
                                expCard("Plumber",service_emp["Plumber"]!.length,_plumberControl),
                                expCard("Painter",service_emp["Painter"]!.length,_painterControl),
                                expCard("Misc",service_emp["Misc"]!.length,_miscControl),
                              ],
                            ),
                          )
                      ),]
                ),
              )
          );
        }
    );
  }
}

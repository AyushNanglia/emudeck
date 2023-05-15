
import 'dart:core';

import 'package:firebase_database/firebase_database.dart';

class contactModel{
  late String contact_name;
  late String contact_email;
  late String contact_designation;
  late String contact_phone;

  contactModel({required this.contact_name, required this.contact_email,
                required this.contact_phone, required this.contact_designation});

  factory contactModel.fromJson(Map<dynamic, dynamic> json){
    return contactModel(
      contact_name: json["name"],
      contact_designation: json["desig"],
      contact_email: json["email"],
      contact_phone: json["phone"].toString(),
    );
  }

  Map<String, dynamic> toJson()=>{
    "name" : contact_name,
    "desig": contact_designation,
    "email": contact_email,
    "phone": contact_phone
  };

  /*Future<void> getField()async{
    final dbRef = FirebaseDatabase.instance.reference().child("Deans");
    List<contact> list=new List();
    //String req_field;
    dbRef.once().then((DataSnapshot snapshot) {
      //req_field=snapshot.value[index][field];
      for(int i=0; i<snapshot.value.length; i++){
        list.add(contact.fromJson(snapshot.value[i]));
      }
    }
      //print(c_length);
    );
    return list;
  }*/

}
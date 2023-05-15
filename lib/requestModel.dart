

import 'package:flutter/material.dart';

class requestModel{
  late String created_at;
  late String request_details;
  late bool resolved;
  late String resolved_date;
  late String service_schedule;
  late String service_subtype;
  late String service_type;
  late String user_address;
  late String user_name;
  late String user_psrn;
  late String service_time_end;
  late String service_time_start;
  late String service_day;

  requestModel({required this.created_at, required this.request_details, required this.resolved,
                required this.resolved_date, required this.service_schedule, required this.service_subtype,
                required this.service_type,required this.user_address, required this.user_name,
                required this.user_psrn, required this.service_day, required this.service_time_end,
                required this.service_time_start});

  factory requestModel.fromSnapshot(Map<dynamic,dynamic> snap){
    return requestModel(
        created_at: snap["created_at"],
        request_details: snap["request_details"],
        resolved: snap["resolved"],
        resolved_date: snap["resolved_date"],
        service_schedule: snap["service_schedule"],
        service_subtype: snap["service_subtype"],
        service_type: snap["service_type"],
        user_address: snap["user_address"],
        user_name: snap["user_name"],
        user_psrn: snap["user_psrn"],
        service_time_start: snap["service_time_start"],
        service_time_end: snap["service_time_end"],
        service_day: snap["service_day"]

    );
  }
}
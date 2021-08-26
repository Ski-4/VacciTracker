import 'package:flutter/widgets.dart';

class District {
  String name = "";
  String state = "";
  int id = 0;

  District({this.name, this.id, this.state});

  factory District.fromJson(Map<String, dynamic> json, String state) {
    return District(
        name: json['district_name'], state: state, id: json['district_id']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'state': state,
    };
  }
}

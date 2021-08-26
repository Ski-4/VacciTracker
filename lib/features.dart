import 'dart:convert';
import 'dart:ui';
import 'package:cowin/district_db.dart';
import 'package:cowin/district_model.dart';
import 'package:cowin/list_vaccine.dart';
import 'package:cowin/vaccine.dart';
import 'package:http/http.dart' as http;

Color getColor(int index) {
  switch (index % 4) {
    case 0:
      return Color(0xFF6CDE9A);
    case 1:
      return Color(0xFFDEB06C);
    case 2:
      return Color(0xFFDE8E6C);
    default:
      return Color(0xFF6C9ADE);
  }
}

Future<http.Response> fetchVaccines(
    int id, int day, int month, int year) async {
  return http.get(Uri.parse(
      'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByDistrict?district_id=$id&date=$day-$month-$year'));
}

Future<void> fetchData(bool flag) async {
  vaccines = [];
  List<District> l = await getDistricts();
  for (var a in l) {
    DateTime day = DateTime.now();
    var response = await fetchVaccines(a.id, day.day, day.month, day.year);
    if (response.statusCode == 200) {
      Map body = jsonDecode(response.body);
      List available = body["sessions"];
      for (var vaccine in available) {
        if (flag == false && vaccine["min_age_limit"] == 18)
          vaccines.add(Vaccine.fromJson(vaccine));
        else if (flag == true) vaccines.add(Vaccine.fromJson(vaccine));
      }
      for (var vaccine in vaccines) {
        print(vaccine.name);
      }
    }
    day = DateTime.now().add(Duration(hours: 23));
    response = await fetchVaccines(a.id, day.day, day.month, day.year);
    if (response.statusCode == 200) {
      Map body = jsonDecode(response.body);
      List available = body["sessions"];
      for (var vaccine in available) {
        if (flag == false && vaccine["min_age_limit"] == 18)
          vaccines.add(Vaccine.fromJson(vaccine));
        else if (flag == true) vaccines.add(Vaccine.fromJson(vaccine));
      }
      for (var vaccine in vaccines) {
        print(vaccine.name);
      }
    }
  }
}

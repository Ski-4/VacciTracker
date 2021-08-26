import 'dart:convert';

import 'package:cowin/district_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddDistrictList extends StatefulWidget {
  @override
  _AddDistrictListState createState() => _AddDistrictListState();
}

class _AddDistrictListState extends State<AddDistrictList> {
  Map<String, int> stId = {};
  int _stvalue = 0;
  int _dtvalue = -1;
  List states = [];
  List districts = [];
  District dist;

  void getDistricts(int id) async {
    districts = [];
    var response = await http.get(Uri.parse(
        "https://cdn-api.co-vin.in/api/v2/admin/location/districts/${stId[states[id]]}"));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      for (var state in body["districts"])
        districts.add(District.fromJson(state, states[id]));
      _dtvalue = districts[0].id;
      dist = districts[0];
    }
    setState(() {});
  }

  void getStates() async {
    var response = await http.get(
        Uri.parse("https://cdn-api.co-vin.in/api/v2/admin/location/states"));
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      for (var state in body["states"]) {
        states.add(state["state_name"]);
        stId[state["state_name"]] = state["state_id"];
      }
      print(states);
      getDistricts(0);
    }
  }

  @override
  void initState() {
    super.initState();
    getStates();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add District"),
        backgroundColor: Color(0xFF0F0F0F),
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                District dist;
                for (var district in districts) {
                  if (district.id == _dtvalue) dist = district;
                }
                Navigator.pop(context, dist);
              })
        ],
      ),
      backgroundColor: Color(0xFF0F0F0F),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            states.length > 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter State",
                        style:
                            TextStyle(fontSize: 18, color: Color(0xFF6c6c6c)),
                      ),
                      DropdownButton(
                          style: TextStyle(color: Color(0xFF6C6C6C)),
                          value: _stvalue,
                          items: states.map((state) {
                            return DropdownMenuItem(
                              child: Text(state),
                              value: states.indexOf(state),
                            );
                          }).toList(),
                          onChanged: (value) {
                            _stvalue = value;
                            getDistricts(_stvalue);
                            setState(() {});
                          }),
                    ],
                  )
                : Text("Loading States.....",
                    style: TextStyle(fontSize: 18, color: Color(0xFF2c2c2c))),
            SizedBox(
              height: 12,
            ),
            states.length > 0
                ? districts.length > 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enter District",
                            style: TextStyle(
                                fontSize: 18, color: Color(0xFF6c6c6c)),
                          ),
                          DropdownButton(
                              style: TextStyle(color: Color(0xFF6C6C6C)),
                              value: _dtvalue,
                              items: districts.map((district) {
                                return DropdownMenuItem(
                                  child: Text(district.name),
                                  value: district.id,
                                );
                              }).toList(),
                              onChanged: (value) {
                                _dtvalue = value;
                                setState(() {});
                              }),
                        ],
                      )
                    : Text("Loading Districts.....",
                        style:
                            TextStyle(fontSize: 18, color: Color(0xFF2c2c2c)))
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

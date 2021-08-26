import 'package:cowin/add_district_list.dart';
import 'package:cowin/district_db.dart';
import 'package:cowin/district_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DistrictList extends StatefulWidget {
  @override
  _DistrictListState createState() => _DistrictListState();
}

class _DistrictListState extends State<DistrictList> {
  List districtList = [];
  void getData() async {
    districtList = await getDistricts();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VacciTracker"),
        elevation: 0,
        backgroundColor: Color(0xFF0F0F0F),
        backwardsCompatibility: false,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.grey[900]),
        brightness: Brightness.light,
        actions: [IconButton(icon: Icon(Icons.help), onPressed: () {})],
      ),
      backgroundColor: Color(0xFF0F0F0F),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8.0,
            ),
            ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                Colors.blue[900],
              )),
              onPressed: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddDistrictList(),
                        fullscreenDialog: true));
                for (var a in districtList) {
                  if (a.id == result.id) return;
                }
                insertDistricts(result);
                districtList = await getDistricts();
                setState(() {});
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text(
                "Add District",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text(
              "DISTRICTS",
              style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF6C6C6C),
                  fontWeight: FontWeight.bold),
            ),
            districtList.length > 0
                ? Expanded(
                    child: ListView.builder(
                        itemCount: districtList.length,
                        itemBuilder: (context, index) {
                          final district = districtList[index];
                          return Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blue.withOpacity(0.6),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        district.name,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                      ),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          deleteDistrict(district);
                                          districtList = await getDistricts();
                                          setState(() {});
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          size: 20.0,
                                          color: Color(0xFFFFFFFF)
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    district.state,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white.withOpacity(0.7)),
                                  ),
                                ],
                              ));
                        }))
                : Expanded(
                    child: Align(
                      child: Text(
                        "Currently, No district is added",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF2C2C2C)),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

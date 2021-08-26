import 'dart:async';
import 'package:cowin/district_db.dart';
import 'package:cowin/district_list.dart';
import 'package:cowin/features.dart';
import 'package:cowin/list_vaccine.dart';
import 'package:cowin/pin.dart';
import 'package:cowin/sad_face.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
      ),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool check = false;
  bool age = false;
  DateTime time = DateTime.now();
  final url = "https://www.cowin.gov.in/";

  void getData() async {
    await fetchData(age);
    time = DateTime.now();
    check = true;
    print(check);
    setState(() {});
  }

  String getTime(DateTime dateTime) {
    int difference = DateTime.now().difference(dateTime).inDays;
    if (difference <= 30 && difference == 1)
      return "$difference day ${DateTime.now().difference(dateTime).inHours % 24} hour";
    if (difference <= 30 && difference > 1)
      return "$difference days ${DateTime.now().difference(dateTime).inHours % 24} hour";
    if (difference == 0 &&
        DateTime.now().difference(dateTime).inHours.abs() == 1)
      return "${DateTime.now().difference(dateTime).inHours} hour ${DateTime.now().difference(dateTime).inMinutes % 60} min";
    if (difference == 0 &&
        DateTime.now().difference(dateTime).inHours.abs() > 1)
      return "${DateTime.now().difference(dateTime).inHours} hours ${DateTime.now().difference(dateTime).inMinutes % 60} min";
    if (DateTime.now().difference(dateTime).inHours == 0 &&
        DateTime.now().difference(dateTime).inMinutes.abs() != 0)
      return "${DateTime.now().difference(dateTime).inMinutes} min ${DateTime.now().difference(dateTime).inSeconds % 60} secs";
    if (DateTime.now().difference(dateTime).inHours == 0 &&
        DateTime.now().difference(dateTime).inSeconds == 1)
      return "${DateTime.now().difference(dateTime).inSeconds} sec";
    return "${DateTime.now().difference(dateTime).inSeconds} secs";
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget build(BuildContext context) {
    Timer(Duration(seconds: 1), () {
      setState(() {});
    });
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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                check = false;
                setState(() {});
                getData();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.replay,
                    color: Color(0xFF6C6C6C),
                    size: 28,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  check == true
                      ? Text(
                          "Updated ${getTime(time)} ago",
                          style: TextStyle(
                              color: Color(0xFF2C2C2C),
                              fontWeight: FontWeight.w600),
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (age == true)
                      age = false;
                    else
                      age = true;
                    check = false;
                    time = DateTime.now();
                    setState(() {});
                    await fetchData(age);
                    check = true;
                    print(age);
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF6C6C6C)),
                      borderRadius: BorderRadius.circular(10.0),
                      color: age == false ? Color(0xFF1E1E1E) : null,
                    ),
                    child: Text(
                      "Age 18-45",
                      style: TextStyle(color: Color(0xFF6C6C6C)),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () async {
                    if (age == true)
                      age = false;
                    else
                      age = true;
                    print(age);
                    check = false;
                    time = DateTime.now();
                    setState(() {});
                    await fetchData(age);
                    check = true;
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF6C6C6C)),
                      borderRadius: BorderRadius.circular(10.0),
                      color: age == true ? Color(0xFF1E1E1E) : null,
                    ),
                    child: Text(
                      "Age 45+",
                      style: TextStyle(color: Color(0xFF6C6C6C)),
                    ),
                  ),
                ),
                Spacer(),
                ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                      Colors.blue[900],
                    )),
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DistrictList(),
                              fullscreenDialog: true));
                      check = false;
                      setState(() {});
                      getData();
                    },
                    icon: Icon(Icons.add),
                    label: Text("Add District")),
              ],
            ),
            SizedBox(height: 12.0),
            check == true
                ? vaccines.length > 0
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: vaccines.length,
                          itemBuilder: (context, index) {
                            final vaccine = vaccines[index];
                            return GestureDetector(
                              onTap: () async {
                                if (await canLaunch(url)) {
                                  showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                            title: Text("${vaccine.pincode}"),
                                            content: Text(
                                                'Use this pin, to book your appointement for this center.'),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  await launch(url);
                                                },
                                                child: Text('Open Url'),
                                              ),
                                            ],
                                          ));
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.0),
                                  color: getColor(index),
                                ),
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 14.0,
                                      bottom: 14.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text("${vaccine.age}+",
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontSize: 16)),
                                          Spacer(),
                                          Text(vaccine.time,
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.3))),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text("Tap to Book",
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.3))),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(vaccine.name,
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontWeight: FontWeight.w500,
                                          )),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Text(
                                        vaccine.address,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            color:
                                                Colors.black.withOpacity(0.7)),
                                      ),
                                      SizedBox(
                                        height: 4.0,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Remaining: ",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black
                                                    .withOpacity(0.3)),
                                          ),
                                          Text("${vaccine.rem}",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black
                                                      .withOpacity(0.7))),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Vaccination Type: ",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black
                                                    .withOpacity(0.3)),
                                          ),
                                          Text(vaccine.vaccinetType,
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black
                                                      .withOpacity(0.7))),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Price: ",
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                color: Colors.black
                                                    .withOpacity(0.3)),
                                          ),
                                          Text(
                                              vaccine.price == "0"
                                                  ? "Free"
                                                  : vaccine.price,
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black
                                                      .withOpacity(0.7))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.string(
                              sad_svg,
                              color: Color(0xFF2C2C2C),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Sorry no appointements are available currently in your marked districts for this age group.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF2C2C2C)),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Add new districts to search for more wider area.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF2C2C2C)),
                            )
                          ],
                        ),
                      )
                : Text(
                    "Loading Data....",
                    style: TextStyle(fontSize: 20, color: Color(0XFF2C2C2C)),
                  ),
          ],
        ),
      ),
      backgroundColor: Color(0xFF0F0F0F),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF0F0F0F),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VacciTracker',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "Made in ❤️ with",
                        style: TextStyle(color: Colors.white.withOpacity(0.4)),
                      ),
                      Text(" 🇮🇳 India", style: TextStyle(color: Colors.white))
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 5.0),
                  Text("Search With "),
                  Icon(
                    Icons.location_city,
                  ),
                  Text("District"),
                ],
              ),
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.search),
                  SizedBox(width: 5.0),
                  Text("Search With"),
                  Icon(
                    Icons.location_pin,
                  ),
                  Text("PinCode")
                ],
              ),
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Pin()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

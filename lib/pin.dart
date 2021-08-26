import 'package:cowin/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Pin extends StatefulWidget {
  @override
  _PinState createState() => _PinState();
}

class _PinState extends State<Pin> {
  @override
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
      body: Container(
        alignment: Alignment.center,
        child: Text(
          "PinCode Feature Coming Soon",
          style: TextStyle(fontSize: 16, color: Color(0xFF2C2C2C)),
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

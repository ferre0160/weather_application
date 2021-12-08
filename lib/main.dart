// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Weather App",
      home: Home(),
    ));

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String weather_statement() {
    String desc = "";

    if (temp <= 1) {
      desc = "Vriest";
    } else if (temp > 1 && temp <= 10) {
      desc = 'Koud';
    } else if (temp > 10 && temp <= 20) {
      desc = 'Mooi';
    } else {
      desc = 'Warm';
    }
    return desc;
  }

  var temp;
  var description;
  var currently;
  var humidity;
  var windspeed;

  Future getWeather() async {
    http.Response response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=Rotselaar&units=metric&lang=nl&appid=c82feb043dc81db0a10bae349af30da1"));
    var results = jsonDecode(response.body);
    setState(() {
      // structuur zoals SQL/PHP
      // deze code is om de data uit de API results te halen
      // check de url page voor welke names en structuur
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windspeed = results['wind']['speed'];
    });
  }

  // nieuwe override function met initState:
  // initState zorgt dat deze code eerst wordt gerunt
  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 781 / 3,
            width: 450,
            color: Colors.blueAccent,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Rotselaar",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    temp != null ? temp.toString() + "\u2103" : "Loading",
                    style: TextStyle(fontSize: 15),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      weather_statement(),
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                  title: Text("Temperatuur"),
                  trailing: Text(
                      temp != null ? temp.toString() + "\u2103" : "Loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.cloud),
                  title: Text("Weer"),
                  trailing: Text(
                      description != null ? description.toString() : "Loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.sun),
                  title: Text("Luchtvochtigheid"),
                  trailing: Text(
                      humidity != null ? humidity.toString() + "%" : "Loading"),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.wind),
                  title: Text("Windsnelheid"),
                  trailing: Text(windspeed != null
                      ? windspeed.toString() + " m/s"
                      : "Loading"),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}

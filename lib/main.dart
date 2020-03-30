import 'dart:convert';

import 'package:flutter/material.dart';
import "dart:convert" as convert;
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'LoginError.dart';
import 'QuestionsWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: const Color(0xff66bb6a),
            accentColor: const Color(0xffffa726),
            textTheme: TextTheme()),
        home: Home());
  }
}

class _HomeState extends State<Home> {
  static const userTokenKey = "userId";
  String jwt;
  final storage = new FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Feedme",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder<String>(
          builder: (ctx, snapshot) {
            Widget bodyWidget;
            if (snapshot.hasData) {
              bodyWidget = QuestionsWidget(snapshot.data);
            } else if (snapshot.hasError) {
              bodyWidget = LoginError(snapshot.error);
            } else {
              bodyWidget = Text("Loading");
            }
            return Center(
              child: bodyWidget,
            );
          },
          future: login(),
        ));
  }

  Future<String> login() async {
    jwt = await storage.read(key: userTokenKey);
    if (jwt != null) return jwt;

    final response =
        await http.post('http://feedme.compute.dtu.dk/api-dev/users/');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final jwt = response.headers["x-auth-token"];
      storage.write(key: userTokenKey, value: jwt);

      return jwt;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to login user ${response.statusCode}');
    }
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class UserWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserState();
}

class _UserState extends State<UserWidget> {
  void login() {}

  @override
  Widget build(BuildContext context) {}
}

Future<Building> fetchBuildings() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Building.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<User> login() async {
  final response =
      await http.post('http://feedme.compute.dtu.dk/api-dev/users/');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return User.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album ${response.statusCode}');
  }
}

class User {
  final String id;

  User({this.id});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json["_id"]);
  }
}

class Building {
  final int userId;
  final int id;
  final String title;

  Building({this.userId, this.id, this.title});

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      userId: json["userId"],
      id: json["id"],
      title: json["title"],
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Display the fetched data
void main() {
  runApp(MyApp());
}
// Request data from internet

Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Album');
  }
}

// Create Album Obj
class Album {
  final int userId;
  final int id;
  final String title;

  Album(
      {required this.userId, required this.id, required, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(userId: json['userId'], id: json['id'], title: json['title']);
  }
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Network Data"),
        ),
        body: Center(
          child: FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

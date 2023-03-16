import 'dart:convert';

import 'package:api_project/model/album.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Album>> getdata() async {
    var url = "https://jsonplaceholder.typicode.com/albums";
    var jsondata = await http.get(Uri.parse(url));
    if (jsondata.statusCode == 200) {
      List data = jsonDecode(jsondata.body);
      List<Album> allusers = [];
      for (var u in data) {
        Album album = Album.fromJson(u);
        allusers.add(album);
      }
      return allusers;
    } else {
      throw Exception('error');
    }
  }

  late Future<List<Album>> users;

  @override
  void initState() {
    users = getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albums'),
      ),
      body: FutureBuilder<List<Album>>(
        future: users,
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return ListView.builder(
              itemCount: snapShot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    child: Text(
                        "Id : ${snapShot.data![index].id}\nTitle: ${snapShot.data![index].title}"),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

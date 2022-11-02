import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fetcher",
      home: const HomePage(),
      darkTheme: ThemeData(brightness: Brightness.dark),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        title: const Text("HTTP Fetch"),
      ),
      body: FutureBuilder(
        future: getPosts(),
        builder: (context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasError) {
            return const Text("Failed to get data");
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].title),
                  subtitle: Text(snapshot.data![index].body),
                  leading: Text((snapshot.data![index].id).toString()),
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

Future<Response> getData() async {
  Response res =
      await get(Uri.parse("https://jsonplaceholder.typicode.com/posts/"));
  if (res.statusCode == 200) {
    decode(res);
    return res;
  } else {
    return res;
  }
}

List<dynamic> decode(Response res) {
  List<dynamic> posts = jsonDecode(res.body);
  return posts;
}

class Post {
  int id;
  String title;
  String body;
  int userId;
  Post(
      {required this.id,
      required this.title,
      required this.body,
      required this.userId});
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: json['title'],
      id: json['id'],
      body: json['body'],
      userId: json['userId'],
    );
  }
}

List<Post> convertMapToObject(List<dynamic> posts) {
  List<Post> postsObj =
      posts.map((dynamic item) => Post.fromJson(item)).toList();
  return postsObj;
}

Future<List<Post>> getPosts() async {
  Response res = await getData();
  return convertMapToObject(decode(res));
}

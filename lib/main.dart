import 'dart:developer';

import 'package:built_value/json_object.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'data.dart';
import 'api_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// to set the root of app.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'API Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Flutter - Retrofit Implementation"),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {

        },
        label:Icon(Icons.cancel),
        backgroundColor: Colors.green,
      ),
    );
  }

  // build list view & manage states
  FutureBuilder<ResponseData> _buildBody(BuildContext context) {
    final client = ApiClient(Dio(BaseOptions(contentType: "application/json")));
    return FutureBuilder<ResponseData>(
      future: client.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {

          /*Map serverData = snapshot.data.toJson();
          User user = User.fromJson(serverData);
          String name = user.name;
          log("-------------- name: $name");*/

          //this gives json in the form of ResponseData object
          final ResponseData posts = snapshot.data;
          //gives code
          int code = posts.code;

          log("code code code: $code");
          List<dynamic> users = posts.data;
          int length = users.length;
          log("list length: $length");
          String name = "Namit";
          String email = "";
          User user;
          for(int i = 0; i < length; i++){
              Map userMap = users[i];
              user = User.fromJson(userMap);
              name = user.name;
              email = user.email;
              log("$name, $email");
              //log("///////////// $s\n\n\n");
              //ResponseData.fromJson()
          }
          return _buildListView(context, posts);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // build list view & its tile
  Widget _buildListView(BuildContext context, ResponseData posts) {
    return
      ListView.builder(itemBuilder: (context,index){
        return Card(
          child: ListTile(
            leading: Icon(Icons.account_box,color: Colors.green,size: 50,),

            title: Text(posts.data[index]['name'],style: TextStyle(fontSize: 20),),
            subtitle: Text(posts.data[index]['email']),
          ),
        );
      },itemCount: posts.data.length,
      );
  }

}

import 'package:example/route_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return FirstPageState();
  }

}

class FirstPageState extends State {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("first page"),
      ),
      body: Column(
        children: <Widget>[
          Text("内容内容内容"),
          FlatButton(onPressed: (){
            Navigator.pushNamed(context, RouteHelper.secondPage);
          }, child: Text("跳转")),
        ],
      ),
    );
  }

}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return SecondPageState();
  }

}

class SecondPageState extends State {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("second page"),
      ),
      body: Column(
        children: <Widget>[
          Text("第二个页面")
        ],
      ),
    );
  }

}
import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new SettingsViewState();
  }
}

class SettingsViewState extends State<SettingsView>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text("Settings", style: new TextStyle(fontFamily: 'Montserrat Bold')),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'home_body.dart';
import 'settings.dart';
import 'New_List.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Montserrat',
          primaryColor: Colors.deepPurple,
          accentColor: Colors.deepPurpleAccent,
          primaryColorDark: Colors.transparent),
      title: "Today List",
      home: new Scaffold(
        appBar: new AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset('images/logo.png'),
                new Text(
                  "Today List",
                  style: new TextStyle(fontFamily: 'Montserrat Bold'),
                ),
              ],
            )),
        floatingActionButton: new CreateListPush(),
        bottomNavigationBar: new BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 6.0,
          color: Colors.deepPurple,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SettingsPush(),
              new IconButton(
                  icon: new Icon(Icons.info_outline), onPressed: () {}),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: new BodyView(),
      ),
    );
  }
}

class SettingsPush extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: Icon(Icons.settings),
      onPressed: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => SettingsView()));
      },
    );
  }
}

class CreateListPush extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new FloatingActionButton(
      elevation: 0.0,
      backgroundColor: Colors.deepPurpleAccent,
      foregroundColor: Colors.white,
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
            context, new MaterialPageRoute(builder: (context) => CreateList()));
      },
    );
  }
}

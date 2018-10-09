import 'dart:async';

import 'package:flutter/material.dart';
import '../database/DB.dart';
import 'dart:convert';
import 'package:flutter/animation.dart';
import 'add_list.dart';

class BodyView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BodyViewState();
  }
}

class BodyViewState extends State<BodyView>
    with TickerProviderStateMixin {
  DbHelper db;
  List<Holder> temp_list;
  List<String> titles;
  List<List> data_task;
  List<List> data_sum;
  List<String> colors;
  bool _load = true;
  bool _gridview = false;
  PageController _pageControl;

  Animation _animPage;
  AnimationController _animPageControl;
  Animation _animGrid;
  AnimationController _animGridControl;

  @override
  void initState() {
    super.initState();
    initDBase();
  }

  initDBase() async {
    db = new DbHelper();
    temp_list = new List();
    temp_list = await db.getTitle();
    titles = new List();
    data_task = new List();
    data_sum = new List();
    colors = new List();
    for (int a = 0; a < temp_list.length; a++) {
      titles.add(temp_list[a].title);
      data_sum.add(json.decode(temp_list[a].summaryList));
      data_task.add(json.decode(temp_list[a].taskList));
      colors.add(temp_list[a].color);
    }
    print(titles);
    print(data_sum);
    print(data_task);
    print(colors);
    _pageControl =
        new PageController(initialPage: titles.length, keepPage: true);
    _animPageControl = new AnimationController(
        duration: new Duration(milliseconds: 1500), vsync: this);
    _animPage = new Tween(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animPageControl,
      curve: Curves.fastOutSlowIn,
    ));
    _animPageControl.forward();
    _animGridControl = new AnimationController(
      duration: new Duration(milliseconds: 1500),vsync: this);
    _animGrid = new Tween(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animGridControl,
      curve: Curves.fastOutSlowIn,
    ));
    _animGridControl.forward();
    setState(() {
      _load = false;
    });
  }

  Color colorCheck(int i) {
    if (colors[i] == 'Default')
      return null;
    else if (colors[i] == 'Red')
      return Colors.redAccent;
    else if (colors[i] == 'Brown')
      return Colors.brown;
    else if (colors[i] == 'Black')
      return Colors.black;
    else if (colors[i] == 'Purple')
      return Colors.deepPurpleAccent;
    else if (colors[i] == 'Orange')
      return Colors.deepOrangeAccent;
    else if (colors[i] == 'Pink')
      return Colors.pinkAccent;
    else if (colors[i] == 'Green') return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    if (_load)
      return new Center(child: CircularProgressIndicator());
    else {
      return titles.length == 0
          ? new CardViewEmpty()
          : _gridview
              ? fullView(height)
              : new PageView.builder(
                  controller: _pageControl,
                  itemCount: titles.length,
                  itemBuilder: (context, i) {
                    return new GestureDetector(
                        //child: CardView(i),
                        child: new AnimatedBuilder(
                          animation: _animPageControl,
                          builder: (BuildContext context, Widget child) {
                            return new Transform(
                              transform: Matrix4.translationValues(
                                  0.0, _animPage.value * height, 0.0),
                              child: CardView(i),
                            );
                          },
                        ),
                        onVerticalDragStart: (e) {
                          print("detected");
                          setState(() {
                            _animPageControl.reverse();
                            _animGridControl.forward();
                            _gridview = true;
                          });
                        });
                  },
                );
    }
  }

  Widget CardView(int i) {
    return new Card(
        color: colorCheck(i),
        elevation: 0.0,
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
        margin: new EdgeInsets.only(bottom: 50.0, left: 20.0, right: 20.0),
        child: Padding(
          padding:
              EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0, right: 5.0),
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      child: new Row(children: <Widget>[
                        new Text(titles[i],
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: 'Montserrat Bold')),
                      ]),
                    ),
                    new Container(
                      child: new Row(children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => AddList(i,titles[i])
                              )
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline),
                          onPressed: () {
                            setState(() {
                              db.deleteList(titles[i]);
                              titles.remove(titles[i]);
                              data_sum.remove(data_sum[i]);
                              data_task.remove(data_task[i]);
                              colors.remove(colors[i]);
                            });
                          },
                        ),
                      ]),
                    ),
                  ],
                ),
                new Expanded(
                  child: Lister(i),
                ),
              ]),
        ));
  }

  Widget Lister(int i) {
    return new ListView.builder(
      itemCount: data_task[i].length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            data_task[i][index],
            style: new TextStyle(fontSize: 13.0, fontFamily: 'Montserrat Bold'),
          ),
          subtitle: Text(data_sum[i][index]),
          trailing: IconButton(
            icon: Icon(Icons.check_circle),
            onPressed: () {
              setState(() {
                data_sum[i].remove(data_sum[i][index]);
                data_task[i].remove(data_task[i][index]);
                db.updateItem(
                    titles[i],json.encode(data_task[i]), json.encode(data_task[i]));
              });
            },
          ),
        );
      },
    );
  }

  Widget fullView(double height) {
    return new AnimatedBuilder(
        animation: _animGridControl,
        builder: (context, child) {
          return new Transform(
              transform:
                  Matrix4.translationValues(0.0, _animGrid.value * height, 0.0),
              child: GridView.builder(
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                padding: EdgeInsets.all(16.0),
                itemCount: titles.length,
                itemBuilder: (context, index) {
                  return new Container(
                      child: new GestureDetector(
                    child: Card(
                      color: colorCheck(index),
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: new Center(
                          child: new Text(
                        titles[index],
                        style: new TextStyle(
                            fontSize: 10.0, fontFamily: 'Montserrat Bold'),
                      )),
                    ),
                    onTap: () {
                      setState(() {
                        _gridview = false;
                        _animGridControl.reverse();
                        _pageControl = new PageController(
                            initialPage: index, keepPage: true);
                        _animPageControl.forward();
                      });
                    },
                  ));
                },
              ));
        });
  }
}

/*
class CardView extends StatefulWidget {
  int i;
  CardView(this.i);
  @override
  State<StatefulWidget> createState() {
    return CardViewState(i);
  }
}

class CardViewState extends State<CardView> {
  int i;
  CardViewState(this.i);
  @override

}
*/
class CardViewEmpty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Card(
        elevation: 0.0,
        shape: new RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
        margin: new EdgeInsets.only(bottom: 50.0, left: 20.0, right: 20.0),
        child: Padding(
          padding:
              EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0, right: 5.0),
          child: new Center(
              child: Text(
            "No Lists created :(\n\nClick + to start :)",
            style: TextStyle(
                fontSize: 18.0,
                fontFamily: "Montserrat Bold",
                color: Colors.grey),
            textAlign: TextAlign.center,
          )),
        ));
  }
}

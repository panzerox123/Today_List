import 'package:flutter/material.dart';
import '../database/DB.dart';
import 'dart:convert';
import 'home_View.dart';

class AddList extends StatefulWidget {
  int i;
  String title;
  AddList(this.i,this.title);
  @override
  State<StatefulWidget> createState() {
    return new AddListState(this.i,this.title);
  }
}

class AddListState extends State<AddList> {
  AddListState(this.index,this.title_to_add);
  int index;
  DbHelper db;
  String title_to_add;
  String curr_task;
  String curr_sum;
  List<String> task_list_add = [];
  List<String> sum_list_add = [];
  List<String> titles;
  List<String> colors;
  List<List> tasks;
  List<List> data; 
  var _color = 'Default';
  final _controller_task = new TextEditingController();
  final _controller_sum = new TextEditingController();
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    db = new DbHelper();
    List<Holder> temp_list = await db.getTitle();
    print(temp_list);
    titles = new List();
    data = new List();
    tasks = new List();
    colors = new List();
    for(int a =0; a<temp_list.length;a++){
      titles.add(temp_list[a].title);
      data.add(json.decode(temp_list[a].summaryList));
      tasks.add(json.decode(temp_list[a].taskList));
      colors.add(temp_list[a].color);
    }
    this._color = colors==null? 'Default': colors[index];
    print(titles);
    print(data);
    print(tasks);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton.extended(
        elevation: 0.0,
        icon: Icon(Icons.check_circle),
        label: new Text("Finish",
            style: new TextStyle(fontFamily: 'Montserrat Bold')),
        onPressed: () {
          for(int m = 0; m < sum_list_add.length; m++){
            data[index].add(sum_list_add[m]);
          }
          for(int k = 0; k < task_list_add.length; k++){
            tasks[index].add(task_list_add[k]);
          }
          db.updateCurrList(title_to_add, json.encode(tasks[index]),
              json.encode(data[index]), _color);
          /*Navigator.push(context, new MaterialPageRoute(
            builder: (context) => new HomePage()
          ));*/
          Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName(''));
        },
      ),
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: new Text('Edit List',
            style: new TextStyle(fontFamily: 'Montserrat Bold')),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          new IconButton(
            icon: Icon(Icons.colorize),
            onPressed: () {
              showDialog(
                context: context,
                child: AlertDialog(
                    title: new Text(
                      "Pick a colour",
                      style: new TextStyle(fontFamily: 'Montserrat Bold'),
                      textAlign: TextAlign.center,
                    ),
                    contentPadding: new EdgeInsets.all(15.0),
                    content: new Container(
                      height: 150.0,
                      child: new Column(
                        children: <Widget>[
                          Spacer(),
                          new DropdownButton<String>(
                            hint: new Text(_color),
                            items: <String>[
                              'Default',
                              'Red',
                              'Brown',
                              'Black',
                              'Purple',
                              'Orange',
                              'Pink',
                              'Green'
                            ].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _color = val;
                              });
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            },
                          ),
                          Spacer(),
                          /*RaisedButton.icon(
                            icon: Icon(Icons.check),
                            shape: StadiumBorder(),
                            color: Colors.deepPurple,
                            splashColor: Colors.deepPurpleAccent,
                            label: new Text(
                              "Select Color",
                              style: TextStyle(fontFamily: 'Montserrat Bold'),
                            ),
                            onPressed: () {},
                          )*/
                        ],
                      ),
                    )),
              );
            },
          ),
          /*new IconButton(
            icon: new Icon(Icons.add),
            onPressed: () {
              _data.saveTitle(Holder(title_to_add, json.encode(task_list_add),
                  json.encode(sum_list_add),_color));
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),*/
        ],
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /*new TextField(
            textAlign: TextAlign.center,
            style: new TextStyle(fontFamily: 'Montserrat Bold'),
            onChanged: (text) {
              setState(() {
                title_to_add = text;
              });
            },
            decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Title",
                hintStyle: new TextStyle(fontFamily: 'Montserrat Bold')),
          ),*/
          new Center(
            child: new Text(title_to_add, style: new TextStyle(fontFamily: 'Montserrat Bold'),),
          ),
          new Container(
            height: 250.0,
            padding: new EdgeInsets.all(16.0),
            child: new Card(
              shape: new RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              elevation: 0.0,
              child: new Column(children: <Widget>[
                new TextField(
                  controller: _controller_task,
                  style: new TextStyle(fontFamily: 'Montserrat Bold'),
                  onChanged: (text) {
                    setState(() {
                      curr_task = text;
                    });
                  },
                  autocorrect: true,
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      contentPadding: new EdgeInsets.all(16.0),
                      hintText: "Task",
                      hintStyle: new TextStyle(fontFamily: 'Montserrat Bold')),
                ),
                new Container(
                    height: 80.0,
                    child: new TextField(
                      controller: _controller_sum,
                      style: new TextStyle(fontFamily: 'Montserrat'),
                      onChanged: (text) {
                        setState(() {
                          curr_sum = text;
                        });
                      },
                      autocorrect: true,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          contentPadding: new EdgeInsets.all(16.0),
                          hintText: "Summary",
                          hintStyle: new TextStyle(fontFamily: 'Montserrat')),
                    )),
                new RaisedButton.icon(
                    icon: Icon(Icons.check),
                    shape: StadiumBorder(),
                    label: Text(
                      "Add to list",
                      style: TextStyle(fontFamily: 'Montserrat Bold'),
                    ),
                    color: Colors.deepPurple,
                    splashColor: Colors.deepPurpleAccent,
                    onPressed: () {
                      setState(() {
                        task_list_add.add(curr_task);
                        sum_list_add.add(curr_sum);
                        print(task_list_add);
                        print(sum_list_add);
                        _controller_sum.clear();
                        _controller_task.clear();
                      });
                    }),
              ]),
            ),
          ),
          new Expanded(
              child: ListView.builder(
            itemCount: task_list_add != null ? task_list_add.length : 0,
            itemBuilder: (context, i) {
              return ListTile(
                title: new Text(task_list_add[i]),
                subtitle: new Text(sum_list_add[i]),
                trailing: new IconButton(
                    icon: Icon(Icons.cancel),
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        task_list_add.remove(task_list_add[i]);
                        sum_list_add.remove(sum_list_add[i]);
                      });
                    }),
              );
            },
          )),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../database/DB.dart';
import 'dart:convert';
import 'home_View.dart';

class CreateList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new CreateListState();
  }
}

class CreateListState extends State<CreateList> {
  DbHelper _data;
  List<Holder> titles;
  String title_to_add;
  String curr_task;
  String curr_sum;
  List<String> task_list_add = [];
  List<String> sum_list_add = [];
  var _color = 'Default';
  final _controller_task = new TextEditingController();
  final _controller_sum = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    _data = new DbHelper();
    titles = await _data.getTitle();
    //await _data.deleteTitle(1);
    print(titles);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: new FloatingActionButton.extended(
        elevation: 0.0,
        icon: Icon(Icons.add),
        label: new Text("Create",
            style: new TextStyle(fontFamily: 'Montserrat Bold')),
        onPressed: () {
          final form = formKey.currentState;
          if (form.validate()) {
            form.save();
            _data.saveTitle(Holder(title_to_add, json.encode(task_list_add),
                json.encode(sum_list_add), _color));
          /*Navigator.push(context, new MaterialPageRoute(
            builder: (context) => new HomePage()
          ));*/
          //Navigator.of(context).pop(true);
          Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName(''));
          }
        },
      ),
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: new Text('Create a new list',
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
            controller: _controller_title,
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
          new Form(
            key: formKey,
            child: new TextFormField(
              textAlign: TextAlign.center,
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: 'Title',
                hintStyle: new TextStyle(fontFamily: 'Montserrat Bold'),
              ),
              validator: (text) =>
                  text.isEmpty ? 'Title can\'t be empty' : null,
              onSaved: (text) {
                setState(() {
                  title_to_add = text;
                });
              },
            ),
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
                        curr_task = "";
                        curr_sum = "";
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

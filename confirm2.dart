import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8, json;

List<Bus> arriveCells = List<Bus>();
List<Bus> departCells = List<Bus>();

String dropdownValue = '터미널 1';
String detailValue = '1 - 1';

bool fixed = false;

class Confirm2App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: '2019 국제대회 주차부',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new Confirm2Page(title: '홍길동형제 - 오후'),
    );
  }
}

class Confirm2Page extends StatefulWidget {
  Confirm2Page({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ConfirmState createState() => new _ConfirmState();
}

class _ConfirmState extends State<Confirm2Page> {
  bool _isLoading = false;

  SharedPreferences prefs;

  Future<Map<String, dynamic>> _user() async {
    prefs = await SharedPreferences.getInstance();
    final response = await http.get (
      "https://ip2019.tk/guide/api?token=" + prefs.getString("token"),
      headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
      },
    );
    return json.decode(utf8.decode(response.bodyBytes));
  }

  void currentUser() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    currentUser();
    // cells에 add 메서드 사용하여 정보 입력
    arriveCells.add(new Bus("12가 3456", "부천역곡중앙"));
    arriveCells.add(new Bus("34가 5678", "부천역곡동부"));
    arriveCells.add(new Bus("56가 7890", "부천중앙"));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () async {
              String url;
              if (Platform.isAndroid) {
                url = "https://jisang-dev.github.io/hyla981020/terminal.html";
                if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceSafariVC: true,
                    forceWebView: true,
                    enableJavaScript: true,
                  );
                }
              } else {
                url = "https://jisang-dev.github.io/hyla981020/terminal.html";
                try {
                  await launch(
                    url,
                    forceSafariVC: true,
                    forceWebView: true,
                    enableJavaScript: true,
                  );
                } catch (e) {
                  print(e.toString());
                }
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {

            },
          ),
        ],
      ),
      body: _showBody(),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: FutureBuilder<Map<String, dynamic>> (
          future: _user(),
          builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              return new ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child:  ListView(
                      // Important: Remove any padding from the ListView.
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          Text(snapshot.data['bus_info']['bus_name'], style: TextStyle(fontSize: 20),),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                              child: new MaterialButton(
                                elevation: 5.0,
                                minWidth: 200.0,
                                height: 42.0,
                                color: Colors.blue,
                                child:new Text('로그아웃'),
                                onPressed: logout,
                              )
                          ),
                        ]
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: Text('이름: ' + snapshot.data['bus_info']['bus_guide_name']),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(dropdownValue),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            } else {
              return new ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child:  ListView(
                      // Important: Remove any padding from the ListView.
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          Text('', style: TextStyle(fontSize: 20),),
                          Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                              child: new MaterialButton(
                                elevation: 5.0,
                                minWidth: 200.0,
                                height: 42.0,
                                color: Colors.blue,
                                child:new Text('로그아웃'),
                                onPressed: logout,
                              )
                          ),
                        ]
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    title: Text('이름: '),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(dropdownValue),
                    onTap: () {
                      // Update the state of the app
                      // ...
                      // Then close the drawer
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void logout() async {
    await prefs.setString('id', null);
    await prefs.setString('pw', null);
    await prefs.setString('token', null);
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) => new MyApp()
      ),
    );
  }

  Widget _showBody(){
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          terminalArrive(),
          _buildSuggestions(),
          terminalDepart(),
          _buildSuggestions2(),
        ],
      ),
    );
  }

  Widget terminalArrive() {
    return ListTile(
      title: Text("터미널 도착 예정 버스 목록", style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 30)),
    );
  }

  Widget terminalDepart() {
    return ListTile(
      title: Text("터미널 출발 예정 버스 목록", style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 30)),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(1.0),

        itemCount: arriveCells.length,
        itemBuilder: (BuildContext _context, int i) {
          return _buildRow(arriveCells[i], i);
        });
  }

  Widget _buildRow(Bus pair, int i) {
    return ListTile(
      title: Text("차 번호: " + pair.busCode + ", 회중명: " + pair.congregation),
      trailing: MaterialButton (
        elevation: 5.0,
        minWidth: 10.0,
        height: 42.0,
        color: Colors.blue,
        child: new Icon(Icons.delete_sweep),
        onPressed: () {
          showDialog(
              context: context,
              builder: ((BuildContext context) {
                return MyDialog1(message: "차 번호: " + pair.busCode + "\n회중명: " + pair.congregation + "\n버스가 출발하였습니까?", position: i, parent: this,);
              }
              )
          );
        },
      ),
    );
  }

  Widget _buildSuggestions2() {
    return new ListView.builder(
        padding: const EdgeInsets.all(1.0),
        shrinkWrap: true,

        itemCount: departCells.length,
        itemBuilder: (BuildContext _context, int i) {
          return _buildRow2(departCells[i], i);
        });
  }

  Widget _buildRow2(Bus pair, int i) {
    return ListTile(
      title: Text("차 번호: " + pair.busCode + ", 회중명: " + pair.congregation),
      trailing: MaterialButton (
        elevation: 5.0,
        minWidth: 10.0,
        height: 42.0,
        color: Colors.blue,
        child: new Icon(Icons.delete_sweep),
        onPressed: () {
          confirmD("차 번호: " + pair.busCode + "\n회중명: " + pair.congregation + "\n버스가 출발하였습니까?", i);
        },
      ),
    );
  }

  Future<void> confirmD(String message, int process) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('네'),
              onPressed: () {
                setState(() {
                  departCells.removeAt(process);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Bus {
  String busCode;
  String congregation;

  Bus(String busCode, String congregation) {
    this.busCode = busCode;
    this.congregation = congregation;
  }
}

class MyDialog1 extends StatefulWidget {
  MyDialog1({this.message, this.position, this.parent});
  final String message;
  final int position;
  final _ConfirmState parent;

  @override
  _MyDialogState1 createState() => new _MyDialogState1(message, position, parent);
}

class _MyDialogState1 extends State<MyDialog1> {
  String message;
  int position;

  _ConfirmState parent;

  _MyDialogState1(String message, int position, _ConfirmState parent) {
    this.message = message;
    this.position = position;
    this.parent = parent;
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(message),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              color: !fixed ? Colors.white : Colors.grey,
              child: Row(
                children: <Widget>[
                  DropdownButton<String>(
                    value: dropdownValue,
                    iconDisabledColor: Colors.grey,
                    onChanged: (String newValue) {
                      if (!fixed) {
                        setState(() {
                          dropdownValue = newValue;
                          if (newValue == '터미널 1') {
                            detailValue = '1 - 1';
                          } else {
                            detailValue = '2 - 1';
                          }
                        });
                      }
                    },
                    items: <String>['터미널 1', '터미널 2']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Checkbox(
                    value: fixed,
                    onChanged: (bool value) {
                      setState(() {
                        fixed = value;
                      });
                    },
                  ),
                  Text("값 고정"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
              child: Row(
                children: <Widget>[
                  DropdownButton<String>(
                    value: detailValue,
                    onChanged: (String newValue) {
                      setState(() {
                        detailValue = newValue;
                      });
                    },
                    items: (dropdownValue == '터미널 1') ? <String>['1 - 1', '1 - 2','1 - 3', '1 - 4','1 - 5']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList() : <String>['2 - 1', '2 - 2','2 - 3', '2 - 4','2 - 5','2 - 6','2 - 7']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('아니오'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('네'),
          onPressed: () {
            this.parent.setState(() {
              departCells.add(arriveCells.removeAt(position));
            });
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdsample/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8, json;

String dropdownValue = '터미널 1';
String detailValue = '1 - 1';

class CountApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<CountApp> {
  int _count = 0;

  SharedPreferences prefs;

  TextEditingController _textFieldController = TextEditingController();

  void currentUser() async {
    prefs = await SharedPreferences.getInstance();
  }

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

  @override
  void initState() {
    super.initState();
    currentUser();
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

  Widget _main() {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            '대략적인 버스와 승용차 통과 수:',
          ),
          new Text(
            '$_count',
            style: Theme.of(context).textTheme.display1,
          ),
          _reduceButton(),
          _setButton(),
        ],
      ),
    );
  }

  Widget _reduceButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new MaterialButton(
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child:new Icon(Icons.exposure_neg_1),
          onPressed: () {
            setState(() {
              _count--;
            });
          },
        )
    );
  }

  Widget _setButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new MaterialButton(
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child:new Text('설정',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: setCount,
        ));
  }

  Future<void> setCount() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("차량 통과 대수를 입력해주세요."),
          content: TextField(
            controller: _textFieldController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "차량 통과 대수 입력"),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('아니오'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('네'),
              onPressed: () async {
                Navigator.of(context).pop();
                setState(() {
                  _count = int.parse(_textFieldController.text);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("터미널 계수"),
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
      body: Stack(
        children: <Widget>[
          _main(),
        ],
      ),
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
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
  void _incrementCounter() {
    // Built in Flutter Method.
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _count++;
    });
  }
}
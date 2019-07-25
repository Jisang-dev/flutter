import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pdsample/main.dart';
import 'package:pdsample/init.dart';
import 'package:pdsample/send.dart';
import 'package:pdsample/receive.dart';
import 'package:pdsample/count.dart';
import 'package:pdsample/confirm.dart';
import 'package:pdsample/confirm2.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'send.dart';
import 'confirm.dart';
import 'receive.dart';

// 이 화면은 임시로 쓰이는 화면입니다. 버튼을 눌러 원하는 화면으로 이동하세요.

class TempApp extends StatelessWidget {
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
      home: new TempPage(),
    );
  }
}

class TempPage extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<TempPage> {
  SharedPreferences prefs;
  String id = ""; /// prefs가 Future 함수에 의존하기에 알고리즘을 이런 식으로... 나중에 FutureBuilder 사용해보자

  @override
  void initState() {
    currentUser();
    super.initState();
  }

  void currentUser() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id'); ///
    });
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

  void init() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) => new InitApp()
      ),
    );
  }

  void send() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) => new SendApp()
      ),
    );
  }

  void receive() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) => new ReceiveApp()
      ),
    );
  }

  void count() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) => new CountApp()
      ),
    );
  }

  void confirm() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) => new ConfirmApp()
      ),
    );
  }

  void confirm2() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
          builder: (BuildContext context) => new Confirm2App()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("임시 화면"),
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
        ],
      ),
      body: Stack(
        children: <Widget>[
          _showBody(),
        ],
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(id),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _showBody(){
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          new Text("이 화면은 모든 화면에 접근하기 위해 임시로 쓰이는 화면입니다. 버튼을 눌러 원하는 화면으로 이동하세요."),
          _init(),
          _send(),
          _receive(),
          _count(),
          _confirm(),
          _confirm2(),
          _logout(),
        ],
      ),
    );
  }

  Widget _init() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new MaterialButton(
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child:new Text('운전기사 번호 입력',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: init,
        ));
  }

  Widget _send() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new MaterialButton(
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child:new Text('하차',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: send,
        ));
  }

  Widget _receive() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new MaterialButton(
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child:new Text('승차',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: receive,
        ));
  }

  Widget _count() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new MaterialButton(
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child:new Text('계수',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: count,
        ));
  }

  Widget _confirm() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new MaterialButton(
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child:new Text('터미널 상황 - 오전',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: confirm,
        ));
  }

  Widget _confirm2() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new MaterialButton(
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child:new Text('터미널 상황 - 오후',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: confirm2,
        ));
  }

  Widget _logout() {
    return new Padding(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: new MaterialButton(
        elevation: 5.0,
        minWidth: 200.0,
        height: 42.0,
        color: Colors.blue,
        child:new Text('로그아웃',
            style: new TextStyle(fontSize: 20.0, color: Colors.white)),
        onPressed: logout,
      ));
  }
}
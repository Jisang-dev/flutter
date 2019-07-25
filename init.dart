// 이 화면은 초기 버스 정보값(버스기사 번호 등)을 받기 위한 화면으로 사용될 예정입니다.
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdsample/main.dart';
import 'package:pdsample/send.dart';
import 'package:http/http.dart' as http;

class Post {
  final bool ok;
  final String token;
  final String reason;

  Post({this.ok, this.token, this.reason});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      ok: json['ok'],
      token: json['token'],
      reason: json['reason'],
    );
  }
}

class Init {
  final bool ok;
  final String reason;

  Init({this.ok, this.reason});

  factory Init.fromJson(Map<String, dynamic> json) {
    return Init(
      ok : json['ok'],
      reason : json['reason'],
    );
  }
}

class InitApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<InitApp> {
  final _formKey = new GlobalKey<FormState>();
  String _guideName;
  String _busDriver;
  String _busCode;
  String _confirm;
  bool _isLoading = false;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    currentUser();
  }

  void currentUser() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '초기값 입력',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Stack(
          children: <Widget>[
            _showBody(),
            _showCircularProgress(),
          ],
        ),
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(height: 0.0, width: 0.0,);
  }

  Widget _showBody() {
    return new Container(
      padding: EdgeInsets.all(16.0),
      child: new Form(
        key: _formKey,
        child: new ListView(
          shrinkWrap: true,
          children: <Widget>[
            _guideNameInput(),
            _busDriverInput(),
            _busCodeInput(),
            _memo(),
            _submit(),
            _logoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _guideNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: true,
        decoration: new InputDecoration(
            hintText: '인솔자 이름 입력',
            icon: new Icon(
              Icons.directions_bus,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? '값을 입력하세요.' : null,
        onSaved: (value) => _guideName = value,
      ),
    );
  }

  Widget _busDriverInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: true,
        decoration: new InputDecoration(
            hintText: '버스기사 전화번호 입력',
            icon: new Icon(
              Icons.directions_bus,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? '값을 입력하세요.' : null,
        onSaved: (value) => _busDriver = value,
      ),
    );
  }

  Widget _busCodeInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: '버스 번호 입력 (예: 12가 3456)',
            icon: new Icon(
              Icons.directions_bus,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? '값을 입력하세요.' : null,
        onSaved: (value) => _busCode = value,
      ),
    );
  }

  Widget _memo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: '기타 요청사항 입력',
            icon: new Icon(
              Icons.directions_bus,
              color: Colors.grey,
            )),
        onSaved: (value) => _confirm = value,
      ),
    );
  }

  Widget _submit() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: new MaterialButton(
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child: new Text('제출',
              style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: _validateAndSubmit,
        ));
  }

  Widget _logoutButton() { // for AndroidOS
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
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

  Future<Init> fetchPost(String _token, String _guideName, String _busDriver, String _busCode, String _confirm, String _status) async {
    final response = await http.post (
      "https://ip2019.tk/guide/api/info",
      body: json.encode({
        "token" : _token,
        "bus_guide_name": _guideName,
        "bus_number": _busCode,
        "bus_driver_phone": _busDriver,
        "bus_guide_memo": _confirm,
        "status": _status, /// 킨텍스 거리에 따라 바뀌어야 함
        "bus_day": 0, /// 매일 바뀌어야 함
      }),
      headers: {
        "content-type" : "application/json",
        "accept" : "application/json",
      },
    );
    return Init.fromJson(json.decode(response.body));
  }

  void _validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      await fetchPost(prefs.getString('token'), _guideName, _busDriver, _busCode, _confirm, "start").then((post) async {
        print(prefs.getString('token'));
        print(post.ok);
        print(post.reason);
        if (post.ok) {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new SendApp()
            ),
          );
        } else {
          await alert(post.reason != null ? post.reason : "관리자 문의");
        }
      }).catchError((e) async {
        await alert("네트워크를 확인해주세요.");
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> alert(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('네'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
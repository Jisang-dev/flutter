import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class Cell {
  final double latitude;
  final double longitude;
  final String token;
  final String dnumber; // 기사 전화번호
  final String depart;
  final String departSch; // 출발 예정시각
  final String pass1;
  final String pass2;
  final String tArrive;
  final String tDepart;
  final int type;
  final bool access;
  final DocumentReference reference;

  Cell.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['lat'] != null),
        assert(map['long'] != null),
        assert(map['token'] != null),
        latitude = map['lat'],
        longitude = map['long'],
        token = map['token'],
        dnumber = map['dnumber'],
        depart = map['depart'],
        departSch = map['departSch'],
        pass1 = map['pass1'],
        pass2 = map['pass2'],
        tArrive = map['tArrive'],
        tDepart = map['tDepart'],
        type = map['type'],
        access = map['access'];


  Cell.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$latitude:$longitude>";
}
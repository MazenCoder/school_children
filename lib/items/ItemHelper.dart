import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

Future<List> gse_parent_details(String MatriculeParent) async {
  final response = await http.post("http://10.0.2.2:8080/school_children/gse_parent_details.php", body: {
    "MatriculeParent": MatriculeParent,
  }).catchError((e, s) {
    debugPrint("e: $e , s: $s");
  });
  return json.decode(response.body);
}

Future<List> tableExam() async {
  final response = await http.post("http://10.0.2.2:8080/school_children/query_table.php")
      .catchError((e, s) {
    debugPrint("e: $e , s: $s");
  });
  return json.decode(response.body);
}

Future<List> queryCinq() async {
  final response = await http.post("http://10.0.2.2:8080/school_children/query_cinq.php")
      .catchError((e, s) {
    debugPrint("e: $e , s: $s");
  });
  return json.decode(response.body);
}

Future<List> queryExamId(String table, String matricule) async {
  final response = await http.post("http://10.0.2.2:8080/school_children/query_exam_id.php", body: {
    "tabLevel"  : table,
    "matricule" : matricule,
  }).catchError((e, s) {
    debugPrint("e: $e , s: $s");
  });
  return json.decode(response.body);
}

Future<List> queryCinqParent(String matricule) async {
  final response = await http.post("http://10.0.2.2:8080/school_children/query_cinq_parent.php", body: {
    "matricule" : matricule,
  }).catchError((e, s) {
    debugPrint("e: $e , s: $s");
  });
  return json.decode(response.body);
}

Future<List> queryExamParentId(String table, String MatriculeParent) async {
  final response = await http.post("http://10.0.2.2:8080/school_children/query_exam_parent_id.php", body: {
    "tabLevel"       : table,
    "MatriculeParent" : MatriculeParent,
  }).catchError((e, s) {
    debugPrint("e: $e , s: $s");
  });
  return json.decode(response.body);
}

Future<List> gse_intr_parent_eleve(String MatriculeParent) async {
  final response = await http.post("http://10.0.2.2:8080/school_children/gse_intr_parent_eleve.php", body: {
    "MatriculeParent": MatriculeParent,
  }).catchError((e, s) {
    debugPrint("e: $e , s: $s");
  });
  if(response == null) {
    print("null...");
  }
  return json.decode(response.body);
}

Future<List> infra_gse_eleve(String MatriculeElvFk) async {
  final response = await http.post("http://10.0.2.2:8080/school_children/infra_gse_eleve.php", body: {
    "MatriculeElvFk": MatriculeElvFk,
  }).catchError((e, s) {
    debugPrint("e: $e , s: $s");
  });
  return json.decode(response.body);
}

Future<List> est_iap(String iap, String MatriculeElv) async {
  final response = await http.post("http://10.0.2.2:8080/school_children/conn_est_iap.php", body: {
    "iap"          : iap,
    "MatriculeElv" : MatriculeElv,
  }).catchError((e, s) {
    debugPrint("e: $e , s: $s");
  });
  return await json.decode(response.body);
}

Future<List> est_iap_absence(String iap, String MatriculeElv) async {
  final response = await http.post("http://10.0.2.2:8080/school_children/est_iap_absence.php", body: {
    "iap"          : iap,
    "MatriculeElv" : MatriculeElv,
    "table"        : "gse_absence"
  }).catchError((e, s) {
    debugPrint("e: $e , s: $s");
  });
  return await json.decode(response.body);
}
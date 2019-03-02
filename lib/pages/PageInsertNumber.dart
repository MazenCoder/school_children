import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:school_children/items/ItemHelper.dart' as helper;
import 'package:http/http.dart' as http;

class PageInsertNumber extends StatefulWidget {

  var db_ets;
  String MatriculeParent;
  var dataStudent;

  PageInsertNumber(this. db_ets, this.dataStudent, this.MatriculeParent);

  @override
  _PageInsertNumberState createState() => _PageInsertNumberState();
}

class _PageInsertNumberState extends State<PageInsertNumber> {
  List<String> _listStages = ["الانتقال للسنه1متوسط", "شهادة التعليم المتوسط", "شهادة البكالوريا"];
  String _stage, _tabLevel, _tabLevelParent;
  var _keyField = GlobalKey<FormState>();
  final TextEditingController register_controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    print("........data........");
    print(widget.dataStudent.toString());
    print(widget.MatriculeParent);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
        title: new Text("ادخل رقم التسجيل"),
        centerTitle: true,
      ),
      body: Form(
        key: _keyField,
        child: new ListView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          children: <Widget>[

            Container(
              margin: EdgeInsets.only(top: 8),
              child: Card(
                child: new Center(
                  child: new DropdownButton<String>(
                    items: _listStages.map((String val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Container(
                            padding: EdgeInsets.all(8),
                            child: new Text("$val",textAlign: TextAlign.center, style: new TextStyle(fontSize: 24),)),
                      );
                    }).toList(),
                    hint: new Text("حدد المستوى الدراسي", textAlign: TextAlign.center, style: new TextStyle(fontSize: 24),),
                    value: _stage,
                    onChanged: (val) {
                      print(val);
                      chooseLevel(val);
                    },
                  ),
                ),
              ),
            ),

            new Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              child: new TextFormField(
                controller: register_controller,
                decoration: InputDecoration(
                    labelText: "ادخل رقم التسجيل",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    )
                ),
                validator: (val) {
                  if(val.isEmpty) {
                    return "هذا الحقل لا يمكن ان يكون فارغا";
                  }
                },
              ),
            ),

            new Center(
              child: new RaisedButton(
                  child: new Text("حفظ"),
                  textColor: Colors.white,
                  color: helper.hexToColor('#006233'),
                  onPressed: () {
                    if(_keyField.currentState.validate()) {
                      if(_stage != null) {
                        sendData(widget.dataStudent, widget.MatriculeParent);
                      }else{
                        print("please choose level");
                        _flushbar("يرجى تحديد المستوى الدراسي");
                      }
                    }
                  }),
            ),

          ],
        ),
      ),
    );
  }

  void sendData(dataStudent, String MatriculeParent) async {
    if(dataStudent != null && MatriculeParent != null) {
//      try {
        print("...... Search id elev ......");
        final response = await http.post("http://10.0.2.2:8080/school_children/query_info.php", body: {
          "tb_parent"      : _tabLevelParent,
          "matricule_bac"  : register_controller.text.trim(),
        }).catchError((e, s) {
          debugPrint("e: $e , s: $s");
        });

        var data = await json.decode(response.body);
        print(data);
        if(data.toString().length > 2) {
          print("...... Id elev exist ......");
          _flushbar("تم تسجيل هذا الطالب/ة من قبل");
        }else{
          print("...... Insert new Id ......");
          final response = await http.post("http://10.0.2.2:8080/school_children/insert_info.php", body: {
            "tabLevel"       : _tabLevel,
            "tabLevelParent" : _tabLevelParent,
            "matricule"      : register_controller.text.trim(),
            "MatriculeParent": MatriculeParent,
            "MatriculeElv"   : dataStudent['MatriculeElv'],
            "PrenomArElv"    : dataStudent['PrenomArElv'],
            "NomArElv"       : dataStudent['NomArElv'],
          }).catchError((e, s) {
            debugPrint("e: $e , s: $s");
          });
          var data = await json.decode(response.body);
          print(data);
          if(data == 11) {
            print("saved data");
            register_controller.clear();
            _flushbar("تم التسجيل بنجاح");
          }else{
            print("error");
            _flushbar("فشل في التسجيل");
          }
        }

//      } catch (e) {
//        print(e.toString());
//        _flushbar(" فشل في التسجيل $e");
//      }
    }
  }

  void chooseLevel(String val) {
    setState(() {
      this._stage = val;
    });
    switch(val) {
      case "الانتقال للسنه1متوسط": {
        setState(() {
          _tabLevel       = "cinq";
          _tabLevelParent = "cinq_parent";
        });
      }
      break;

      case "شهادة التعليم المتوسط": {
        setState(() {
          _tabLevel       = "bem";
          _tabLevelParent = "bem_parent";
        });
      }
      break;

      case "شهادة البكالوريا": {
        setState(() {
          _tabLevel       = "bac";
          _tabLevelParent = "bac_parent";
        });
      }
      break;
    }
  }

  _flushbar(String msg) {
    Flushbar()
      ..message = "$msg"
      ..icon = Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blue[300],
      )
      ..duration = Duration(seconds: 4)
      ..leftBarIndicatorColor = Colors.blue[300]
      ..show(context);
  }
}

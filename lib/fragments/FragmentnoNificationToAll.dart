import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_children/items/ItemHelper.dart' as helper;

class FragmentnoNificationToAll extends StatefulWidget {
  @override
  _FragmentnoNificationToAllState createState() => _FragmentnoNificationToAllState();
}

class _FragmentnoNificationToAllState extends State<FragmentnoNificationToAll> {

  var _key = GlobalKey<FormState>();
  final TextEditingController _title_controller = new TextEditingController();
  final TextEditingController _content_controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _key,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: new Center(
            child: SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new Text('إرسال إشعارات للجميع', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),

                  new SizedBox(height: 32,),

                  new TextFormField(
                    controller: _title_controller,
                    decoration: InputDecoration(
                      labelText: 'عنوان الرسالة',
                      icon: Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                    validator: (val) {
                      if(val.isEmpty) {
                        return "هذا الحقل لا يمكن ان يكون فارغا";
                      }
                    },
                  ),

                  new SizedBox(height: 20,),

                  new TextFormField(
                    controller: _content_controller,
                    decoration: InputDecoration(
                        hintText: 'محتوى الرسالة',
                        icon: Icon(Icons.content_paste),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        )
                    ),
                    validator: (val) {
                      if(val.isEmpty) {
                        return "هذا الحقل لا يمكن ان يكون فارغا";
                      }
                    },
                    maxLines: 8,
                  ),

                  new Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: new RaisedButton(
                        textColor: Colors.white,
                        color: helper.hexToColor('#006233'),
                        child: new Padding(padding: EdgeInsets.only(left: 16, right: 16),
                          child: new Text('ارسال', style: TextStyle(fontSize: 18),),
                        ),
                        onPressed: () {
                          if(_key.currentState.validate()) {
                            Firestore.instance.collection("NOTIFICATION").document().setData({
                              "title"   : _title_controller.text.trim(),
                              "content" : _content_controller.text.trim() ,
                              "DateTime": new DateTime.now(),
                            }).then((val) {
                              _flushbar("تم الارسال بنجاح");
                              _title_controller.clear();
                              _content_controller.clear();
                            }).catchError((e) {
                              _flushbar("فشل الارسال");
                            });
                          }
                        }
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
    );
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

import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:school_children/AccountPage.dart';
import 'package:school_children/HomePage.dart';
import 'package:school_children/items/DataModel.dart';
import 'package:school_children/localization/localizations.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:school_children/items/ItemHelper.dart' as helper;
import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;


class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passController = new TextEditingController();
  bool _loading = false, _checkboxOnChanged = false;

  @override
  void initState() {
    saveInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: _loading,
          child: Form(
            key: _formKey,
            child: new Center(
              child: new SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      new Image.asset('images/Flag_of_Algeria.png', width: 120, height: 120,),
                      //new Text(AppLocalizations.of(context).lblemail),
                      new SizedBox(height: 16,),

                      new Text('تسجيل الدخول إلى حسابك', style: TextStyle(
                        fontSize: 25,
                      ),),

                      new SizedBox(height: 32,),

                      new TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        validator: (val) {
                          if(val.isEmpty) {
                            return 'هذا الحقل لا يمكن ان يكون فارغا';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'البريد الالكتروني',
                          icon: new Icon(Icons.email),
                        ),
                      ),

                      new TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: _passController,
                        validator: (val) {
                          if(val.isEmpty) {
                            return 'هذا الحقل لا يمكن ان يكون فارغا';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'كلمه المرور',
                          icon: new Icon(Icons.lock),
                        ),
                      ),

                      new SizedBox(height: 8,),

                      new CheckboxListTile(
                        value: _checkboxOnChanged, onChanged: _onChanged,
                        title: new Text('تذكرنى'),),

                      new Container(
                        margin: EdgeInsets.symmetric(vertical: 16),
                        child: new RaisedButton(
                          textColor: Colors.white,
                          color: helper.hexToColor('#006233'),
                          child: new Padding(padding: EdgeInsets.only(left: 16, right: 16),
                            child: new Text('تسجيل الدخول', style: TextStyle(fontSize: 18),),
                          ),
                          onPressed: () {
                            print('RaisedButton');
                            if(_formKey.currentState.validate()) {
                              _getParent(
                                  _emailController.text.trim(),
                                  generateMd5(_passController.text.trim())
                              ).then((list) {
                                stateProgress(true);
                                if(list != null) {
                                  print(list);
                                  print("email: ${list[0]['email']}");

                                  stateProgress(false);
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(list)));
                                } else {
                                  stateProgress(false);
                                  print('email or password is incorrect');
                                  _flushbar('email or password is incorrect');
                                }
                              }).catchError((e) {
                                debugPrint(e);
                                stateProgress(false);
                              });
                            }
                          },
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    print('data: $digest');
    return hex.encode(digest.bytes);
  }

  Future<List> _getParent(String email, String password) async {
    try {
      stateProgress(true);
      final response = await http.post("http://10.0.2.2:8080/school_children/gse_parent.php", body: {
        "email": email,
        "password": password
      }).catchError((e, s) {
        debugPrint("e: $e , s: $s");
        stateProgress(false);
      });

      print(response.body.toString());
      var dataParent = json.decode(response.body);

      if(dataParent.length == 0){
        print('dataParent == 0');
        stateProgress(false);
        _flushbar("عنوان البريد الاكتروني او كلمه المرور غيرصحيح");
        return null;
      }else{
        stateProgress(false);
        return dataParent;
      }
    }catch(e) {
      stateProgress(false);
      print(e);
    }
  }

  stateProgress(bool loading) {
    setState(() {
      this._loading = loading;
    });
  }

  void _onChanged(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(_formKey.currentState.validate()) {
      setState(() {
        _checkboxOnChanged = value;
      });
      if(value) {
        await prefs.setString('email', _emailController.text.trim());
        await prefs.setString('pass', _passController.text.trim());
      } else {
        await prefs.remove('email');
        await prefs.remove('pass');
      }
    }else{
      print("empty field");
    }
  }

  saveInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email') ?? "");
    String pass = (prefs.getString('pass') ?? "");
    if (email.isNotEmpty && pass.isNotEmpty) {
      print(email);
      print(pass);
      setState(() {
        _emailController.text = email;
        _passController.text = pass;
        _checkboxOnChanged = true;
      });
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

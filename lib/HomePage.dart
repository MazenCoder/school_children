import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:school_children/AccountPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:school_children/fragments/FragmentAccount.dart';
import 'package:school_children/fragments/FragmentHome.dart';
import 'package:school_children/fragments/FragmentNotification.dart';
import 'package:school_children/pages/PageAdmin.dart';
//import 'package:image_picker/image_picker.dart';



class HomePage extends StatefulWidget {
  var dataParent;
  HomePage(this.dataParent);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  CollectionReference _reference = Firestore.instance.collection("USERS");
  String _token;
  int _selectedDrawerIndex = 0;
  bool isAdmin = false;

  Future<bool> _onBack() async {
    return showDialog(
        context: context,
        builder: (BuildContext) =>
            AlertDialog(
              title: new Text('هل تريد الخروج من التطبيق؟'),
              actions: <Widget>[
                FlatButton(onPressed: () => Navigator.pop(context, false),
                    child: new Text('لا')),

                FlatButton(onPressed: () => Navigator.pop(context, true),
                    child: new Text('نعم')),
              ],
            )) ?? false;
  }
  _getBottomNavigationWidget(int pos) {
    switch (pos) {
      case 0:
        return new FragmentHome(widget.dataParent);
      case 1:
        return new FragmentNotification();
      case 2:
        return new FragmentAccount(widget.dataParent);

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    //Navigator.of(context).pop(); // close the drawer
  }

  @override
  void initState() {
    // TODO: implement initState
    _configureMessaging();
    _stateToken();
    super.initState();
  }

  void _configureMessaging() async {
    _firebaseMessaging.configure(
        onLaunch: (Map<String, dynamic> msg) {
          print('onLaunch');
        },

        onResume: (Map<String, dynamic> msg) {
          print("onResume");
        },

        onMessage: (Map<String, dynamic> msg) {
          print("onMessage");
        }
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
          sound: true,
          alert: true,
          badge: true,
        )
    );

    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print('ios settings registered');
    });
  }
  void _stateToken() async {
    if(widget.dataParent[0]['MatriculeParent'] != null) {

      _token = await _firebaseMessaging.getToken();

      await _reference.document(widget.dataParent[0]['MatriculeParent']).get().then((doc) {
        if(doc != null) {
          if(doc.data['tokenId'] != _token) {
            updateToken(_token, widget.dataParent[0]['MatriculeParent'].toString().trim());
          }
        }

      }).then((val) {
        print("successfully state document");
      }).catchError((e) {
        createToken(_token, widget.dataParent[0]['MatriculeParent'].toString().trim());
        debugPrint("error: ${e.toString()}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: _onBack,
          child: _getBottomNavigationWidget(_selectedDrawerIndex),
        ),

        bottomNavigationBar: BottomNavigationBar(
          items: [
            new BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('الرئيسية'),
            ),

            new BottomNavigationBarItem(
              icon: new Icon(Icons.notifications),
              title: new Text('اشعارات'),
            ),

            new BottomNavigationBarItem(
              icon: new Icon(Icons.account_circle),
              title: new Text('حسابي'),
            ),

          ],

          onTap: _onSelectItem,
          currentIndex: _selectedDrawerIndex,
        ),


        floatingActionButton: FutureBuilder(
          future: getAdmin(widget.dataParent[0]['MatriculeParent']),
          builder: (context, snapshot) {
            switch(snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return new Center();
              case ConnectionState.active:
              case ConnectionState.done:
              print('ConnectionState.active');
              print('ConnectionState.done');
              if (snapshot.hasError) {
                return new Center();
              }
              print('data form cloud firebase: ${snapshot.data}');
            }
            try{
              if(snapshot.data["admin"] == true) {
                return FloatingActionButton(
                    child: new Icon(Icons.beenhere),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PageAdmin()));
                    }
                );
              } else {
                return new Container();
              }
            }catch(e) {
              print("error $e");
              return new Container();
            }
          },
        ),

      ),
    );
  }

  void createToken(String token, String uid) {
    if(token != null) {
      _reference.document(uid).setData({
        'tokenId': token,
        'uid'    : widget.dataParent[0]['MatriculeParent'],
        'name'   : widget.dataParent[0]['PrenomArParent']+" "+ widget.dataParent[0]['NomArParent'],
        'admin'  : false,
      }).then((val) {
        print('successfully create new account');
      }).catchError((e) {
        print("failed create token");
        print(e);
      });
    }
  }
  void updateToken(String token, String uid) {
    if(token != null && uid != null) {
      _reference.document(uid).updateData({
        'tokenId': token,
      }).then((val) {
        print('successfully update token');
      }).catchError((e) {
        print("failed update token");
        print(e);
      });
    }
  }

  Future getAdmin(String uid) async {
    if(uid != null) {
      return await _reference.document(uid).get();
    }
  }

  Future getImage() async {
    //var image = await ImagePicker.pickImage(source: ImageSource.camera);
  }
}

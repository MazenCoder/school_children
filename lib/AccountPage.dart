import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class AccountPage extends StatefulWidget {
  var dataParent;
  AccountPage(this.dataParent);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  List<String> _listStages = ["الابتدائية", "المتوسطة", "البكالوريا"];
  String _stage;
  var _file_image;
  bool _uploading;

  //  Widget
  Widget imageAccount(String image) {
    if(image != null && image.isNotEmpty) {
      return Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          child: new Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: new Border.all(
                color: Colors.blue,
                width: 3.0,
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent, Colors.black12
                ] ,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              color: Colors.blue,

            ),
            child: ClipOval(
              child: new CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: new CircularProgressIndicator(),
                errorWidget: new Image.asset('images/user.png'),
              ),
            ),
          ),
        ),
      );
    }else{
      return Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          child: new Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: new Border.all(
                color: Colors.blue,
                width: 3.0,
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.transparent, Colors.black12
                ] ,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              color: Colors.blue,

            ),
            child: ClipOval(
              child: new Image.asset('images/user.png', fit: BoxFit.cover,)
            ),
          ),
        ),
      );
    }
  }

  void getImage() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('image account', textAlign: TextAlign.center,),
            content: Container(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    color: Colors.grey.shade200,
                    child: new ListTile(
                      title: new Text('camera'),
                      leading: new Icon(Icons.camera_alt),
                      onTap: () async {
//                        var file_camera = await ImagePicker.pickImage(source: ImageSource.camera);
//                        if(file_camera != null) {
//                          uploadFile(file_camera);
//                          Navigator.pop(context);
//                          setState(() {
//                            _file_image = file_camera;
//                          });
//                        }
                      },
                    ),
                  ),

                  Container(
                    color: Colors.grey.shade300,
                    child: new ListTile(
                      title: new Text('gallery'),
                      leading: new Icon(Icons.image),
                      onTap: () async {
//                        var file_gallery = await ImagePicker.pickImage(source: ImageSource.gallery);
//                        if(file_gallery != null) {
//                          uploadFile(file_gallery);
//                          Navigator.pop(context);
//                          setState(() {
//                            _file_image = file_gallery;
//                          });
//                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Future<Null> uploadFile(File file) async {
    if(file != null && widget.dataParent[0]['MatriculeParent'] != null) {
      setState(() {
        _uploading = true;
      });
      try {
        List<int> imageBytes = file.readAsBytesSync();
        final StorageReference ref = FirebaseStorage.instance.ref()
            .child("SCHOOL")
            .child("USERS")
            .child('${widget.dataParent[0]['MatriculeParent']}.jpg');
        final StorageUploadTask task = ref.putData(imageBytes,
            StorageMetadata(contentLanguage: "en",
                contentType: 'image/jpg',
                customMetadata: <String, String>{'image': 'image carouse'})
        );

        var _dow_path = await  (await task.onComplete).ref.getPath();
        var dowUrl = await (await task.onComplete).ref.getDownloadURL().then((url) async {

          Firestore.instance.collection("USERS")
              .where('uid', isEqualTo: "${widget.dataParent[0]['MatriculeParent']}")
              .getDocuments().then((doc) {
                print("${doc.documents.length}");
                print("${doc.documents.toString()}");
          }).catchError((e) => debugPrint(e));

        }).whenComplete(() {
          setState(() {
            _uploading = false;
          });
        }).catchError((e) {
          print(e);
          setState(() {
            _uploading = false;
          });
        });

      }catch(e,s) {
        setState(() {
          _uploading = false;
        });
        print(e);
        print(s);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[

              //  PROFILE PARENTS
              new Container(
                child: FutureBuilder(
                  future: gse_parent_details(widget.dataParent[0]['MatriculeParent']),
                  builder: (context, snapshot_gse_parent_details) {
                    switch(snapshot_gse_parent_details.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return new Center(child: Container(
                            margin: EdgeInsets.only(top: 30),
                            child: new CircularProgressIndicator()),);
                      case ConnectionState.active:
                      case ConnectionState.done:
                        print('ConnectionState.active');
                        print('ConnectionState.done');
                        if (snapshot_gse_parent_details.hasError) {
                          return new Center(child: new Container(margin: EdgeInsets.only(top: 30),
                            child: Text('لا يوجد حساب بهذا الاسم'),
                          ));
                        }
                        print('data form gse parent: ${snapshot_gse_parent_details.data}');
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("images/algeria.jpeg"),
                            ),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot_gse_parent_details.data.length,
                                itemBuilder: (context, index) {
                                  return new ListTile(
                                      title: imageAccount(''),
                                      subtitle: new ListTile(
                                        title: new Text('${snapshot_gse_parent_details.data[index]['PrenomArParent'] +" "+ snapshot_gse_parent_details.data[index]['NomArParent']}',
                                          textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24),),
                                        subtitle: new FlatButton(onPressed: () {
                                          print(snapshot_gse_parent_details.data);
                                        },child: new Text("تغير كلمة المرور", textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)),
                                      )
                                  );
                                },
                              ),
                            ),
                          )
                        );
                    }
                  },
                ),
              ),

              new Container(
                alignment: Alignment.center,
                child: new FutureBuilder(
                  future: gse_intr_parent_eleve(widget.dataParent[0]['MatriculeParent']),
                  builder: (context, snapshot_gse_intr_parent_eleve) {
                    switch (snapshot_gse_intr_parent_eleve.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return new Center(
                          child: new CircularProgressIndicator(),);
                      case ConnectionState.active:
                      case ConnectionState.done:
                        print('ConnectionState.active');
                        print('ConnectionState.done');
                        if (snapshot_gse_intr_parent_eleve.hasError) {
                          return new Center(
                            child: new Text('لا يوجد لديك ابناء مسجلين'),);
                        }
                        return new ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot_gse_intr_parent_eleve.data.length,
                          itemBuilder: (context, index_parent_eleve) {
                            return new FutureBuilder(
                              future: infra_gse_eleve(snapshot_gse_intr_parent_eleve.data[index_parent_eleve]['MatriculeElvFk']),
                              builder: (context, snapshot_infra_gse_eleve) {
                                switch(snapshot_infra_gse_eleve.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                    return new Center(
                                      child: new CircularProgressIndicator(),);
                                  case ConnectionState.active:
                                  case ConnectionState.done:
                                    print('ConnectionState.active');
                                    print('ConnectionState.done');
                                    if (snapshot_infra_gse_eleve.hasError) {
                                      return new Center(child: Text('Error: ${snapshot_infra_gse_eleve.error}'),);
                                    }
                                    print(snapshot_infra_gse_eleve.data[0].toString());
                                    return FutureBuilder(
                                      future: est_iap("ets_${snapshot_infra_gse_eleve.data[0]['iap']}", snapshot_infra_gse_eleve.data[0]['MatriculeElv']),
                                      builder: (context, snapshot_est_iap) {
                                        switch(snapshot_est_iap.connectionState) {
                                          case ConnectionState.none:
                                          case ConnectionState.waiting:
                                            return new Center(
                                              child: new CircularProgressIndicator(),);
                                          case ConnectionState.active:
                                          case ConnectionState.done:
                                            print('ConnectionState.active');
                                            print('ConnectionState.done');
                                            if (snapshot_infra_gse_eleve
                                                .hasError) {
                                              return new Center(child: Text('Error: ${snapshot_infra_gse_eleve.error}'),);
                                            }
                                            print('data form est iap: ${snapshot_est_iap.data}');
                                            print(snapshot_est_iap.data.length);
                                            return Card(
                                              child: ListTile(
                                                leading: new Icon(Icons.account_circle),
                                                title: new Text('${snapshot_est_iap.data[0]['PrenomArElv'] +" "+ snapshot_est_iap.data[0]['NomArElv']}'),
                                                trailing: new Icon(Icons.arrow_drop_down),
                                                onTap: () {
//                                                  Navigator.push(context, MaterialPageRoute(
//                                                      builder: (context) => PageInsertNumber("ets_${snapshot_infra_gse_eleve.data[0]['iap']}",
//                                                              snapshot_est_iap.data[0])));
                                                },
                                              ),
                                            );
                                        }
                                      }
                                    );
                                }
                              },
                            );
                          },
                        );
                    }
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<List> gse_parent_details(String MatriculeParent) async {
    final response = await http.post("http://10.0.2.2:8080/school_children/gse_parent_details.php", body: {
      "MatriculeParent": MatriculeParent,
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
}


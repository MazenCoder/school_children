import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:school_children/pages/PageInsertNumber.dart';

class PageRegisterNumber extends StatefulWidget {
  var dataParent;
  PageRegisterNumber(this.dataParent);

  @override
  _PageRegisterNumberState createState() => _PageRegisterNumberState();
}

class _PageRegisterNumberState extends State<PageRegisterNumber> {

  List<String> _listStages = ["الابتدائية", "المتوسطة", "البكالوريا"];
  String _stage;

  /**
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
      */
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(
          title: new Text("حجز رقم التسجيل للامتحانات الرسمية"),
          centerTitle: true,
        ),
        body: Container(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[

              /**
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
              */
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
                                                    Navigator.push(context, MaterialPageRoute(
                                                        builder: (context) => PageInsertNumber("ets_${snapshot_infra_gse_eleve.data[0]['iap']}",
                                                            snapshot_est_iap.data[0], widget.dataParent[0]['MatriculeParent'].toString().trim())));
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



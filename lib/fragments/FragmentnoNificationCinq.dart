import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_children/items/ItemHelper.dart' as helper;

class FragmentnoNificationCinq extends StatefulWidget {
  @override
  _FragmentnoNificationCinqState createState() => _FragmentnoNificationCinqState();
}

class _FragmentnoNificationCinqState extends State<FragmentnoNificationCinq> {

  List<String> _list = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: new FutureBuilder(
          future: helper.queryCinq(),
          builder: (context, snapshotCinq) {
            switch(snapshotCinq.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return new Center(child: Container(
                    margin: EdgeInsets.only(top: 30),
                    child: new CircularProgressIndicator()),);
              case ConnectionState.active:
              case ConnectionState.done:
                print('ConnectionState.active');
                print('ConnectionState.done');
                if (snapshotCinq.hasError) {
                  return new Center(child: new Container(margin: EdgeInsets.only(top: 30),
                    child: Text('لا يوجد حساب بهذا الاسم'),
                  ));
                }
                print('data form queryCinq: ${snapshotCinq.data.length}');
                print('data form queryCinq: ${snapshotCinq.data}');
                return new ListView.builder(
                  itemCount: snapshotCinq.data.length,
                  itemBuilder: (context, index) {
                    return new FutureBuilder(
                      future: helper.queryCinqParent(snapshotCinq.data[index]['matricule']),
                      builder: (context, snapshotCinqParent) {
                        switch(snapshotCinqParent.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return new Center(child: Container(
                                margin: EdgeInsets.only(top: 30),
                                child: new CircularProgressIndicator()),);
                          case ConnectionState.active:
                          case ConnectionState.done:
                            print('ConnectionState.active');
                            print('ConnectionState.done');
                            if (snapshotCinq.hasError) {
                              return new Center(child: new Container(margin: EdgeInsets.only(top: 30),
                                child: Text('لا يوجد حساب بهذا الاسم'),
                              ));
                            }
                            print('data form queryCinqParent: ${snapshotCinqParent.data.length}');
                            print('data form queryCinqParent: ${snapshotCinqParent.data}');
                            _list.add(snapshotCinqParent.data[0]['MatriculeParent']);
                            return new Card(
                              child: ListTile(
                                leading: new Icon(Icons.account_circle),
                                title: Text("${snapshotCinqParent.data[0]['MatriculeParent']}"),
                              ),
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

      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.send),
        onPressed: () {
          print(_list.length);
          getUsers();
        },
      ),
    );
  }

  void getUsers() async {
    for(int i = 0; i < _list.length; i++) {
      print(_list[i]);
      await Firestore.instance
          .collection('USERS')
          .where("uid", isEqualTo: "${_list[i]}")
          .snapshots()
          .listen((data) =>
          data.documents.forEach((doc) => print(doc.data.toString())));
    }
  }
}

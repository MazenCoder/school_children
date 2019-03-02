import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FragmentNotification extends StatefulWidget {
  @override
  _FragmentNotificationState createState() => _FragmentNotificationState();
}

class _FragmentNotificationState extends State<FragmentNotification> {

  CollectionReference _reference = Firestore.instance.collection("USERS");

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('اشعارات'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: new FutureBuilder(
            future: Firestore.instance.collection("NOTIFICATION").orderBy("DateTime", descending: true).getDocuments(),
            builder: (context, snapshot) {
              switch(snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Center(child: Container(
                      margin: EdgeInsets.only(top: 30),
                      child: new CircularProgressIndicator()),);
                case ConnectionState.active:
                case ConnectionState.done:
                  print('ConnectionState.active');
                  print('ConnectionState.done');
                  if (snapshot.hasError) {
                    return new Center(child: new Container(margin: EdgeInsets.only(top: 30),
                      child: Text('لا يوجد حساب بهذا الاسم'),
                    ));
                  }
                  print('data form notification length: ${snapshot.data.documents.length}');
                  print('data form notification: ${snapshot.data.documents}');
                  return new ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return new Card(
                        child: new ListTile(
                          leading: Icon(Icons.notifications),
                          title: new Text("${snapshot.data.documents[index]['title']}"),
                          subtitle: new Text("${snapshot.data.documents[index]['content']}"),
                        ),
                      );
                    },
                  );
              }
            },
          ),
        ),
      )
    );
  }
}

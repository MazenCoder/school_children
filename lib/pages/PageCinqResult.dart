import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:school_children/items/ItemHelper.dart' as helper;

class PageCinqResult extends StatefulWidget {
  var dataParent;
  PageCinqResult(this.dataParent);

  @override
  _PageCinqResultState createState() => _PageCinqResultState();
}

class _PageCinqResultState extends State<PageCinqResult> {

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2)).then((val) {
      Flushbar()
        ..title = "مرحبا ${widget.dataParent[0]["PrenomArParent"]+" "+widget.dataParent[0]["NomArParent"]}"
        ..message = "تم الاعلان عن نتيجة عبد الله احمد"
        ..backgroundColor = Colors.green.shade500
        ..shadowColor = Colors.blue[800]
        ..duration = Duration(seconds: 5)
        ..show(context);
    });

    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('نتائج الابتدائية'),
          centerTitle: true,
        ),
        body: new Container(
          child: new FutureBuilder(
            future: helper.queryExamParentId("cinq_parent", widget.dataParent[0]['MatriculeParent']),
            builder: (context, snapshotParent) {
              switch(snapshotParent.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new Center(
                    child: new CircularProgressIndicator(),);
                case ConnectionState.active:
                case ConnectionState.done:
                  print('ConnectionState.active');
                  print('ConnectionState.done');
                  if (snapshotParent.hasError) {
                    return new Center(
                      child: new Text('لا يوجد لديك ابناء مسجلين في الابتدائية او لم يتم ادخال رقم التسجيل'),);
                  }
                  print("id parent: ${widget.dataParent[0]["MatriculeParent"]}");
                  print('data form snapshotParent: ${snapshotParent.data}');
                  return ListView.builder(
                    itemCount: snapshotParent.data.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: helper.queryExamId("cinq", snapshotParent.data[index]['matricule_bac']),
                        builder: (context, snapShotCinqId) {
                          switch(snapShotCinqId.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return new Center(
                                child: new CircularProgressIndicator(),);
                            case ConnectionState.active:
                            case ConnectionState.done:
                              print('ConnectionState.active');
                              print('ConnectionState.done');
                              if (snapshotParent.hasError) {
                                return new Center(
                                  child: new Text('لا يوجد لديك ابناء مسجلين في الابتدائية او لم يتم ادخال رقم التسجيل'),);
                              }
                              //print("id parent: ${widget.dataParent[0]["matricule"]}");
                              if(snapShotCinqId.data != null) {
                                try{
                                  print('data form snapShotCinqId: ${snapShotCinqId.data}');
                                  return new Card(
                                    child: new ListTile(
                                      leading: Icon(Icons.account_circle),
                                      title: new Text("${snapShotCinqId.data[0]['prenom']+" "+snapShotCinqId.data[0]['nom']}"),
                                      subtitle: new Text('معدل الشهادة: ${snapShotCinqId.data[0]['MoyenneMe']}'),
                                      trailing: stateDeclared(snapShotCinqId.data[0]['MoyenneMe']),
                                    ),
                                  );
                                }catch(e) {
                                  print("error: e");
                                  return new Container();
                                }
                              }else{
                                return new Container();
                              }
                          }
                        },
                      );
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget stateDeclared(String moyenne) {
    try{
      int val = int.parse(moyenne) ?? 0;
      assert(val is int);

      if(val > 0) {
        return new Icon(Icons.brightness_1, color: Colors.green.shade800,);
      }else{
        return new Icon(Icons.brightness_1,);
      }
    }catch(e) {
      print("error: ${e.toString()}");
      return new Icon(Icons.brightness_1,);
    }


  }
}

import 'package:flutter/material.dart';
import 'package:school_children/items/ItemHelper.dart' as helper;

class PageBacResult extends StatefulWidget {
  var dataParent;
  PageBacResult(this.dataParent);

  @override
  _PageBacResultState createState() => _PageBacResultState();
}

class _PageBacResultState extends State<PageBacResult> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('نتائج البكالوريا'),
          centerTitle: true,
        ),
        body: new Container(
          child: new FutureBuilder(
            future: helper.queryExamParentId("bac_parent", widget.dataParent[0]['MatriculeParent']),
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
                        future: helper.queryExamId("bac", snapshotParent.data[index]['matricule_bac']),
                        builder: (context, snapShotBacId) {
                          switch(snapShotBacId.connectionState) {
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
                              if(snapShotBacId.data != null) {
                                try{
                                  print('data form snapShotBacId: ${snapShotBacId.data}');
                                  if(snapShotBacId.data.length <= 0) {
                                    print("... null ...");
                                  }
                                  return new Card(
                                    child: new ListTile(
                                      leading: Icon(Icons.account_circle),
                                      title: new Text("${snapShotBacId.data[0]['prenom']+" "+snapShotBacId.data[0]['nom']}"),
                                      subtitle: new Text('معدل الشهادة: ${snapShotBacId.data[0]['MoyenneMe']}'),
                                      trailing: stateDeclared(snapShotBacId.data[0]['MoyenneMe']),
                                    ),
                                  );
                                }catch(e) {
                                  print("error: $e");
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

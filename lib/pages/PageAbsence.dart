import 'dart:ui';
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:school_children/items/ItemHelper.dart' as helper;

class PageAbsence extends StatefulWidget {
  var dataParent;
  PageAbsence(this.dataParent);

  @override
  _PageAbsenceState createState() => _PageAbsenceState();
}

class _PageAbsenceState extends State<PageAbsence> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: new AppBar(
          title: new Text('الغيابات'),
          centerTitle: true,
        ),
        body: Container(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[

              new Container(
                alignment: Alignment.center,
                child: new FutureBuilder(
                  future: helper.gse_intr_parent_eleve(
                      widget.dataParent[0]['MatriculeParent']),
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
                              future: helper.infra_gse_eleve(
                                  snapshot_gse_intr_parent_eleve.data[index_parent_eleve]['MatriculeElvFk']),
                              builder: (context, snapshot_infra_gse_eleve) {
                                switch (snapshot_infra_gse_eleve.connectionState) {
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
                                    print("...data form snapshot_infra_gse_eleve...");
                                    print(snapshot_infra_gse_eleve.data[0].toString());
                                    return FutureBuilder(future: helper.est_iap(
                                        "ets_${snapshot_infra_gse_eleve.data[0]['iap']}",
                                            snapshot_infra_gse_eleve.data[0]['MatriculeElv']),
                                        builder: (context, snapshot_est_iap) {
                                          switch (snapshot_est_iap
                                              .connectionState) {
                                            case ConnectionState.none:
                                            case ConnectionState.waiting:
                                              return new Center(
                                                child: new CircularProgressIndicator(),);
                                            case ConnectionState.active:
                                            case ConnectionState.done:
                                              print('ConnectionState.active');
                                              print('ConnectionState.done');
                                              if (snapshot_est_iap
                                                  .hasError) {
                                                return new Center(child: Text(
                                                    'Error: ${snapshot_est_iap
                                                        .error}'),);
                                              }
                                              print('data form est iap: ${snapshot_est_iap.data}');
                                            return new FutureBuilder(
                                              future: helper.est_iap_absence(
                                                  "ets_${snapshot_infra_gse_eleve.data[0]['iap']}",
                                                  snapshot_est_iap.data[0]['MatriculeElv']),
                                              builder: (context, snapshot_est_iap_absence) {
                                                switch(snapshot_est_iap_absence.connectionState) {
                                                  case ConnectionState.none:
                                                  case ConnectionState.waiting:
                                                    return new Center(
                                                      child: new CircularProgressIndicator(),);
                                                  case ConnectionState.active:
                                                  case ConnectionState.done:
                                                    print('ConnectionState.active');
                                                    print('ConnectionState.done');
                                                    if (snapshot_est_iap_absence
                                                        .hasError) {
                                                      return new Center(child: Text('Error: ${snapshot_est_iap_absence.error}'),);
                                                    }
                                                    if(snapshot_est_iap_absence.data != null) {
                                                      try {
                                                        print('data form est iap absence: ${snapshot_est_iap_absence.data}');
                                                        return new Card(
                                                          child: new Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: <Widget>[
                                                              new ListTile(
                                                                leading: new Icon(Icons.account_circle),
                                                                title: new Text("${snapshot_est_iap.data[0]['PrenomArElv']+" "+snapshot_est_iap.data[0]['NomArElv']}"),
                                                              ),

                                                              new Container(
                                                                child: Table(
                                                                  children: [
                                                                    TableRow(
                                                                        children: [
                                                                          new Text('بدايه الغياب', textAlign: TextAlign.center,),
                                                                          new Text('نهايه الغياب', textAlign: TextAlign.center,),
                                                                          new Text('عدد الساعات', textAlign: TextAlign.center,),
                                                                          new Text('نوع الغياب', textAlign: TextAlign.center,),
                                                                        ]
                                                                    ),

                                                                    TableRow(
                                                                        children: [
                                                                          new Text('${snapshot_est_iap_absence.data[0]['TempsDebutAbs']}', textAlign: TextAlign.center,),
                                                                          new Text('${snapshot_est_iap_absence.data[0]['TempsFinAbs']}', textAlign: TextAlign.center,),
                                                                          new Text('${snapshot_est_iap_absence.data[0]['NbrHeuresAbs']}', textAlign: TextAlign.center,),
                                                                          new Text('${snapshot_est_iap_absence.data[0]['TypeAbs']}', textAlign: TextAlign.center,),
                                                                        ]
                                                                    ),
                                                                  ],
                                                                  border: TableBorder.all(width: 1),
                                                                ),
                                                              )
                                                            ],
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
//                                              return new Text("${snapshot_est_iap_absence.data}");
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
}
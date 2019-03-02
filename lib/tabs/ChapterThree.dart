import 'package:flutter/material.dart';
import 'package:school_children/items/ItemHelper.dart' as helper;

class ChapterThree extends StatefulWidget {
  @override
  _ChapterThreeState createState() => _ChapterThreeState();
}

class _ChapterThreeState extends State<ChapterThree> {
  @override
  Widget build(BuildContext context) {
    return new Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[

        new Container(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Table(
            children: [
              TableRow(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  children: [
                    new Text('النوع', textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 18,
                    ),),
                    new Text('المستوى', textAlign: TextAlign.center, style: TextStyle(
                        fontSize: 18),),
                    new Text('تاريخ البدء', textAlign: TextAlign.center, style: TextStyle(
                        fontSize: 18),),
                    new Text('تاريخ الانتهاء', textAlign: TextAlign.center, style: TextStyle(
                        fontSize: 18),),
                  ]
              )
            ],
          ),
        ),

        new Flexible(
          child: new FutureBuilder(
              future: helper.tableExam(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return new Center(
                      child: new CircularProgressIndicator(),);
                  case ConnectionState.active:
                  case ConnectionState.done:
                    print('ConnectionState.active');
                    print('ConnectionState.done');
                    if (snapshot.hasError) {
                      return new Center(
                        child: new Text('خطأ في الاتصال، حاول لاحقاَ'),);
                    }
                    if(snapshot.data != null) {
                      try {
                        return new ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              alignment: Alignment.center,
                              child: new Table(
                                children: [
                                  TableRow(
                                      children: [
                                        new Text('${getType(snapshot.data[index]['type'].toString().trim())}', textAlign: TextAlign.center,),
                                        new Text('${snapshot.data[index]['niveau']}', textAlign: TextAlign.center,),
                                        new Text('${snapshot.data[index]['date_debut3']}', textAlign: TextAlign.center,),
                                        new Text('${snapshot.data[index]['date_fin3']}', textAlign: TextAlign.center,),
                                      ]
                                  ),
                                ],
                                textBaseline: TextBaseline.ideographic,
//                              border: TableBorder.all(style: BorderStyle.solid),
                                border: TableBorder(
                                    bottom: BorderSide(width: 1)
                                ),
                              ),
                            );
                          },
                        );
                      }catch(e) {
                        print("error $e");
                        return new Container();
                      }
                    }else{
                      return new Container();
                    }
                }
              }
          ),
        )
      ],
    );
  }

  String getType(data) {
    switch(data) {
      case "0": {
        return "استدراك";
      }
      break;

      case "1": {
        return "اختبار";
      }
      break;

      case "3": {
        return "امتحان شهادة نهاية مرحلة التعليم الابتدائي";
      }
      break;

      case "4": {
        return "امتحان شهادة التعليم المتوسط";
      }
      break;

      case "5": {
        return "امتحان شهادة البكالوريا";
      }
      break;

      default: {
        return "";
      }
    }
  }
}

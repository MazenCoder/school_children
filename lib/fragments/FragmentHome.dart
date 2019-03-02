import 'dart:ui';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:school_children/items/ItemHelper.dart' as helper;
import 'package:school_children/pages/PageAbsence.dart';
import 'package:school_children/pages/PageBacResult.dart';
import 'package:school_children/pages/PageBemResult.dart';
import 'package:school_children/pages/PageCinqResult.dart';
import 'package:school_children/pages/PageRegisterNumber.dart';
import 'package:school_children/pages/PageTableExam.dart';

class FragmentHome extends StatefulWidget {
  var dataParent;
  FragmentHome(this.dataParent);

  @override
  _FragmentHomeState createState() => _FragmentHomeState();
}

class _FragmentHomeState extends State<FragmentHome> {

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          new Container(
            child: FutureBuilder(
              future: helper.gse_parent_details(widget.dataParent[0]['MatriculeParent']),
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
                                    subtitle: new Container(
                                      margin: EdgeInsets.symmetric(vertical: 8),
                                      child: new Text('${snapshot_gse_parent_details.data[index]['PrenomArParent'] +" "+ snapshot_gse_parent_details.data[index]['NomArParent']}',
                                        textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24),
                                      ),
                                    )
                                );
                              },
                            ),
                          ),
                        ),
                    );
                }
              },
            ),
          ),

          new Container(
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: Card(
                      child: Container(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        alignment: Alignment.center,
                        child: new ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PageCinqResult(widget.dataParent)));
                          },
                          title: new SvgPicture.asset("images/element1.svg",
                            color: Colors.green.shade800,
                            height: 80,
                            width: 80,
                          ),
                          subtitle: new Container(
                            padding: EdgeInsets.only(top: 16),
                            child: new Text("نتائج الابتدائية",
                              style: new TextStyle(fontSize: 20,
                                  color: Colors.green.shade800
                              ),
                              textAlign: TextAlign.center,),
                          ),
                        ),
                      )
                  ),
                ),
                new Expanded(
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      alignment: Alignment.center,
                      child: new ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PageBemResult(widget.dataParent)));
                        },
                        title: new SvgPicture.asset("images/element2.svg",
                          color: Colors.green.shade800,
                          height: 80,
                          width: 80,
                        ),
                        subtitle: new Container(
                          padding: EdgeInsets.only(top: 16),
                          child: new Text("نتائج المتوسط",
                            style: new TextStyle(fontSize: 20,
                                color: Colors.green.shade800
                            ),
                            textAlign: TextAlign.center,),
                        ),
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),

          new Container(
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: Card(
                      child: Container(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        alignment: Alignment.center,
                        child: new ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PageBacResult(widget.dataParent)));
                          },
                          title: new SvgPicture.asset("images/element3.svg",
                            color: Colors.green.shade800,
                            height: 80,
                            width: 80,
                          ),
                          subtitle: new Container(
                            padding: EdgeInsets.only(top: 16),
                            child: new Text("نتائج البكالوريا",
                              style: new TextStyle(fontSize: 20,
                                  color: Colors.green.shade800
                              ),
                              textAlign: TextAlign.center,),
                          ),
                        ),
                      )
                  ),
                ),
                new Expanded(
                  child: Card(
                      child: Container(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        alignment: Alignment.center,
                        child: new ListTile(
                          title: new SvgPicture.asset("images/element4.svg",
                            color: Colors.green.shade800,
                            height: 80,
                            width: 80,
                          ),
                          subtitle: new Container(
                            padding: EdgeInsets.only(top: 16),
                            child: new Text("النتائج الفصلية",
                              style: new TextStyle(fontSize: 20,
                                  color: Colors.green.shade800
                              ),
                              textAlign: TextAlign.center,),
                          ),
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),

          new Container(
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: Card(
                      child: Container(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        alignment: Alignment.center,
                        child: new ListTile(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PageAbsence(widget.dataParent)));
                          },
                          title: new SvgPicture.asset("images/element5.svg",
                            color: Colors.green.shade800,
                            height: 80,
                            width: 80,
                          ),
                          subtitle: new Container(
                            padding: EdgeInsets.only(top: 16),
                            child: new Text("الغيابات",
                              style: new TextStyle(fontSize: 20,
                                  color: Colors.green.shade800
                              ),
                              textAlign: TextAlign.center,),
                          ),
                        ),
                      )
                  ),
                ),
                new Expanded(
                  child: Card(
                      child: Container(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        alignment: Alignment.center,
                        child: new ListTile(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PageTableExam())),
                          title: new SvgPicture.asset("images/element6.svg",
                            color: Colors.green.shade800,
                            height: 80,
                            width: 80,
                          ),
                          subtitle: new Container(
                            padding: EdgeInsets.only(top: 16),
                            child: new Text("جدول الاختبارات",
                              style: new TextStyle(fontSize: 20,
                                  color: Colors.green.shade800
                              ),
                              textAlign: TextAlign.center,),
                          ),
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),

          Card(
            child: Container(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              alignment: Alignment.center,
              child: new ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PageRegisterNumber(widget.dataParent)));
                },
                title: new SvgPicture.asset("images/element7.svg",
                  color: Colors.green.shade800,
                  height: 80,
                  width: 80,
                ),
                subtitle: new Container(
                  padding: EdgeInsets.only(top: 16),
                  child: new Text("حجز ارقام التسجيل للامتحانات الرسمية",
                    style: new TextStyle(fontSize: 20,
                        color: Colors.green.shade800
                    ),
                    textAlign: TextAlign.center,),
                ),
              ),
            ),
          ),

        ],
      )
    );
  }
}

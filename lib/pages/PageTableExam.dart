import 'package:flutter/material.dart';
import 'package:school_children/tabs/ChapterOne.dart';
import 'package:school_children/tabs/ChapterThree.dart';
import 'package:school_children/tabs/ChapterTwo.dart';

class PageTableExam extends StatefulWidget {
  @override
  _PageTableExamState createState() => _PageTableExamState();
}

class _PageTableExamState extends State<PageTableExam> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: new Text('جدول الاختبارات'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: "الفصل الأول",),
              Tab(text: "الفصل الثاني",),
              Tab(text: "الفصل الثالث",),
            ],
          ),
        ),

          body: TabBarView(
            children: [
              new ChapterOne(),
              new ChapterTwo(),
              new ChapterThree(),
            ],
          ),
      ),
    );
  }
}

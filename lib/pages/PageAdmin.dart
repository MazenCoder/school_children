import 'package:flutter/material.dart';
import 'package:school_children/fragments/FragmentnoNificationBac.dart';
import 'package:school_children/fragments/FragmentnoNificationBem.dart';
import 'package:school_children/fragments/FragmentnoNificationCinq.dart';
import 'package:school_children/fragments/FragmentnoNificationToAll.dart';

class PageAdmin extends StatefulWidget {
  @override
  _PageAdminState createState() => _PageAdminState();
}

class _PageAdminState extends State<PageAdmin> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: new Text('الاشعارات'),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: "للجميع",),
              Tab(text: "الابتدائي",),
              Tab(text: "المتوسط",),
              Tab(text: "البكالوريا",),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            new FragmentnoNificationToAll(),
            new FragmentnoNificationCinq(),
            new FragmentnoNificationBem(),
            new FragmentnoNificationBac(),
          ],
        ),
      ),
    );
  }
}

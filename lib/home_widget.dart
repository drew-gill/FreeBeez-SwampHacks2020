import 'package:flutter/material.dart';
import 'pop_ups/newListing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'google_map_page.dart';

final databaseReference = Firestore.instance;

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: FreeMap(),
      appBar: AppBar(
        title: Text('FreeBeeez'),
        backgroundColor: Colors.blue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter),
            onPressed: () {
              dialogBox(context);
            },
          )
        ],
      ),
    );
  }
}

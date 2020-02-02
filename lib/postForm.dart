import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'camera_widget.dart';
import 'package:freebeezswamphacks/globals.dart' as globalVar;

final db = Firestore.instance;
class PostPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PostPageState();
  }
}
class PostForm {
  String title = '';
  String desc = '';


  Future<Position> getGPS() {
    return Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> save(Position position) {
    GeoPoint coordinates = new GeoPoint(position.latitude, position.longitude);

    return db
        .collection("postings")
        .add({
          'title': this.title, 
          'desc': this.desc,
          'itemCode': 3, 
          'loc': coordinates, 
          'imageURL': globalVar.imagePath, 
          'rating': 0, 
          'meetingRequired': false,
          'signingRequired': false,
          'postingTime': Timestamp.now(),
          });
  }
}


class Freebee {
  String title = '';
  String desc = '';
  GeoPoint coordinates;

  Freebee({this.title, this.desc, this.coordinates});

  Map<String, dynamic> toJson() => {
        'title': title,
        'desc': desc,
        'coordinates': coordinates
      };
}

class _PostPageState extends State<PostPage> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _post = PostForm();

  @override
  Widget build(BuildContext context) {
    return Container(
      //describes the body of the post
      padding: const EdgeInsets.symmetric(
          vertical: 16.0, horizontal: 16.0), //sets a padded border around form
      child: Builder(
        builder: (context) => Form(
          key: _formKey, //assigns the key to the generated key
          child: Column(
            //create a list-like form
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //create the fields of the form
              TextFormField(
                  //defines a field
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    //if the user doesn't input a title, they get an error msg
                    if (value.isEmpty) {
                      return 'Please enter a title';
                    }
                  },
                  onSaved: (val) => setState(() => _post.title = val)),
              TextFormField(
                  //defines a field
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    //if the user doesn't input a title, they get an error msg
                    if (value.isEmpty) {
                      return 'Please enter a description';
                    }
                  },
                  onSaved: (val) => setState(() => _post.desc = val)),

              Text(
                  'Location: My Location'), //to-do: put in dynamic location selection for user (currentl defaults to their phone's GPS coords)
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    globalVar.imagePath = "";
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ImagePick()),
                    );
                  },
                  child: Text('Upload a picture!'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      _post.getGPS().then((position) => _post.save(position));
                    }
                  },
                  child: Text('Submit'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

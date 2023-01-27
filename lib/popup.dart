import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore=FirebaseFirestore.instance;

Future<void> showMyDialog(context,String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(

        content: SingleChildScrollView(
          child: ListBody(
            children:  <Widget>[
              Text(message),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<bool?> requestDialog(context,String id) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(

        content: SingleChildScrollView(
          child: ListBody(
            children:  <Widget>[
              Text('Do you want to accept or reject the request?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Accept'),
            onPressed: () {
              _firestore.collection('requests').doc(id).update(
                  {
                    'status':'accepted',
                  }
              );
              Navigator.of(context).pop();


            },
          ),
          TextButton(
            child: const Text('Reject'),
            onPressed: () {
              _firestore.collection('requests').doc(id).delete();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
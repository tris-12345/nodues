import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/popup.dart';
import 'authenticate.dart';

class reqs extends StatefulWidget {
  const reqs({Key? key}) : super(key: key);

  @override
  State<reqs> createState() => _reqs();
}

class _reqs extends State<reqs> {
  final _firestore=FirebaseFirestore.instance;
  final _auth= FirebaseAuth.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late String receiverid;
  late String item;
  late User loggedInUser;

  @override

  void initState(){
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser()async{
    final user= await _auth.currentUser!;
    if (user!=null){
      loggedInUser=user;
      currentuser=loggedInUser.email.toString();
    }
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Request'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  receiverid = value;
                },
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Receiver id',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  item = value;
                },
                controller: itemController,

                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'item',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  child: const Text('Send Request'),
                  onPressed: () async {
                    if(await checkIfEmailInUse(receiverid)){
                      var dt = DateTime.now();
                      _firestore.collection('requests').add({
                        'item': item,
                        'receiver': receiverid,
                        'sender':loggedInUser.email,
                        'status': 'pending',
                        'day' : dt.day,
                        'month' : dt.month,
                      });
                      nameController.clear();
                      itemController.clear();
                      showMyDialog(context,'Your request has been sent.');

                    }
                    else{
                      showMyDialog(context,'Invalid UserID!');

                    }

                  },
                )),
          ]),
        ),
      ),
    );
  }
}
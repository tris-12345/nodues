import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled/popup.dart';
import 'authenticate.dart';
import 'homepage.dart';
import 'main.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUp();
}

class _SignUp extends State<SignUp> {
  final _auth= FirebaseAuth.instance;
  final _firestore=FirebaseFirestore.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late String username;
  late String password;
  late String name;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome, $currentuser'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  name = value;
                },
                controller: userController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Full Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                onChanged: (value) {
                  username = value;
                },
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: ElevatedButton(
                  child: const Text('Sign up'),
                  onPressed: () async{
                    final newuser=await _auth.createUserWithEmailAndPassword(email: username, password: password);
                    if (newuser!=null){
                      _firestore.collection('users').doc(newuser.user!.uid).set({
                        'name': name,
                        'uid' : newuser.user!.uid,
                        'email': username,
                        'accepted': 0,
                        'rejected':0,
                      });
                      Navigator.of(context).pop();
                    }

                    print(nameController.text);
                    print(passwordController.text);
                  },
                )),
          ]),
        ),
      ),
    );
  }
}
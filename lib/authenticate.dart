import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String currentuser = '';

Future<bool> checkIfEmailInUse(String emailAddress) async {
  try {
    print('Hit Func');
    final list = await FirebaseAuth.instance.fetchSignInMethodsForEmail(emailAddress);
    print('Hit Func');
    // In case list is not empty
    if (list.isNotEmpty) {
      print('User Exists');
      return true;
    } else {
      print('User Does Not Exist');
      return false;
    }
  } catch (error) {
    print('invalid email');
    return false;
  }
}
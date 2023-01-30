import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";

import 'Home.dart';
import 'Login.dart';

void main(){
  runApp(
    const MaterialApp(
      home: Login(),
    )
  );
}
import 'package:firebase_core/firebase_core.dart';
import "package:flutter/material.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../routes/RouteGenerator.dart';
import 'Login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: const Login(),
      theme: ThemeData(
          primaryColor: const Color(0xFF075E54),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color(0xFF25D366))),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
      builder: EasyLoading.init(),
    ),
  );
}

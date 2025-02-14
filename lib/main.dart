import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'HomePage.dart';
import 'controller.dart';
// import 'HomePage.dart';
import 'testfirebase.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // ✅ เรียกใช้ Firebase ก่อน
  Get.put(Controller()); // ลงทะเบียน Controller
  runApp(
    GetMaterialApp(  // ใช้ GetMaterialApp แทน MaterialApp
      home: MyApp(),  // ใช้ MyApp เป็นหน้าแรก
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Main page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => HomePage());
          },
          child: Text("เริ่มเกม"),
        ),
      ),
    );
  }
}

 


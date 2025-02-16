import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import 'HomePage.dart';
import 'controller.dart';



void main() async {
  // ✅ ต้องใช้ async เพื่อใช้ await
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ✅ เรียกใช้ Firebase ก่อน
  Get.put(Controller()); // ลงทะเบียน Controller
  runApp(
    GetMaterialApp(
      // ใช้ GetMaterialApp แทน MaterialApp
      home: MyApp(), // ใช้ MyApp เป็นหน้าแรก
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 238, 241),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 270, // ใช้เต็มพื้นที่จอ
                  height: 270, // ความสูง 400 พิกเซล
                  child: Image.asset(
                    'assets/images/main_game.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  "Tic Tac Toe ",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => HomePage());
                    },
                    style: ButtonStyle(
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF5B5693)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Text(
                        'Game start',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

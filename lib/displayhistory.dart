import 'dart:async';
import 'dart:developer';
import 'package:debug/HomePage.dart';

import 'controller.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Displayhistory extends StatefulWidget {
  const Displayhistory({super.key});

  @override
  State<Displayhistory> createState() => _DisplayhistoryState();
}

class _DisplayhistoryState extends State<Displayhistory> {
  Controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 238, 241),
      appBar: AppBar(
        title: Text(
          "Game History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 204, 153, 201),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("Game_history")
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                // ใช้ Obx ที่นี่เพื่อให้ UI อัปเดตเมื่อค่า gridSize เปลี่ยน
                return Obx(() {
                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                      // ดึงข้อมูลจาก Firestore ตาม gridSize ปัจจุบัน
                      List logs = (document.data() as Map<String, dynamic>)[
                              "log${controller.gridSize.value}"] ??
                          [];
                      final listFrom = List<String>.from(logs);
                      if (logs.isEmpty) {
                        return Container(); // ถ้าไม่มีข้อมูลให้ return Container() เพื่อไม่ให้แสดงข้อมูล
                      }
                      return Container(
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 153, 79, 122),
                                radius: 30,
                                child: FittedBox(
                                  child: Text(
                                    document["history"] ?? "",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
                                  ),
                                ),
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Winner is: " + (document["history"] ?? ""),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                      width:
                                          10), 
                                  Icon(
                                    Icons.emoji_events, 
                                    color: const Color.fromARGB(255, 209, 191, 25), 
                                    size: 24, 
                                  ),
                                ],
                              ),
                              subtitle: Text("player1: O player2: X"),
                            ),

                            // ใส่ GridView.builder ที่นี่
                            GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ GridView
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: controller.gridSize
                                    .value, // ใช้ gridSize จาก controller
                              ),
                              itemCount: logs.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 146, 109, 153),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    logs[index],
                                    style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),

                            Divider(),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                });
              },
            ),
          ),

          // ใช้ Obx() ใน Dropdown เพื่ออัปเดตค่า gridSize
          Obx(() {
            return DropdownButton<int>(
              value: controller.gridSize.value,
              onChanged: (newSize) {
                controller.setGridSize(newSize!); // อัปเดตค่า gridSize
              },
              items: [3, 4, 5].map((size) {
                return DropdownMenuItem<int>(
                  value: size,
                  child: Text(
                    "${size}x$size",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}

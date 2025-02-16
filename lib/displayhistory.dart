import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Displayhistory extends StatefulWidget {
  const Displayhistory({super.key});

  @override
  State<Displayhistory> createState() => _DisplayhistoryState();
}

class _DisplayhistoryState extends State<Displayhistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(// ใช้ StreamBuilder ในการดึงข้อมูลจาก Firebase
        stream: FirebaseFirestore.instance
            .collection("Game_history")
            .orderBy('createdAt', descending: true)
            .snapshots(), // ดึงข้อมูลจาก collection Game_history
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // สร้าง QuerySnapshot
          if (!snapshot.hasData) {
            // ถ้ายังไม่มีข้อมูล
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            // แสดงข้อมูลใน ListView
            children: snapshot.data!.docs.map((document) {
              List logs =
                  document["log"] ?? []; // ถ้าไม่มี log ให้ใช้ลิสต์ว่างๆ
              final listFrom = List<String>.from(logs);
              //print(listFrom); // [1, 2, 3]
              print("Invalid index List: $listFrom");
              return Container(
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        child: FittedBox(
                          child: Text(document["history"] ?? ""),
                        ),
                      ),
                      title: Text("list: ${listFrom.join(", ")}"),
                      subtitle: Text("player1: O" + " " + "player2: X"),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: listFrom.length,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.purple[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            listFrom[index],
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
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
        },
      ),
    );
  }
}

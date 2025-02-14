import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  RxInt gridSize = 3.obs; // ขนาดกระดาน (ค่าเริ่มต้น 3x3)
  RxList<String> gameValue = List.filled(3 * 3, "").obs; // กระดานเกม
  RxBool isX = false.obs;
  RxInt click = 0.obs;

  //เตรียม Firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference history = FirebaseFirestore.instance
      .collection('Game_history'); //สร้าง collection ชื่อ history

  void setGridSize(int size) {
    if (size < 3) size = 3; // ป้องกันค่าต่ำกว่า 3
    gridSize.value = size;
    gameValue.assignAll(List.filled(size * size, "")); // ใช้ assignAll() แทน
    click.value = 0;
  }

  void addValue(int index) {
    if (index < 0 || index >= gameValue.length) {
      print("Invalid index: $index");
      return;
    }
    if (gameValue[index] == "") {
      gameValue[index] = isX.value ? "X" : "O";
      isX.value = !isX.value;
      click.value++;
      print("Invalid index: $click");
      checkWinner();
    } else {
      print("Invalid Click");
    }
  }

  void matchDrawMessage() {
    if (click.value == gridSize.value * gridSize.value) {
      Get.defaultDialog(
        title: "Match Draw",
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setGridSize(gridSize.value); // รีเซ็ตกระดาน
                Get.back();
              },
              icon: Icon(Icons.close),
              label: Text("Cancel"),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setGridSize(gridSize.value); // เล่นใหม่
                Get.back();
              },
              icon: Icon(Icons.play_arrow),
              label: Text("Play Again"),
            ),
          ],
        ),
      );
    }
  }

  void checkWinner() async {
    int N = gridSize.value;

    // ตรวจสอบแนวนอน
    for (int row = 0; row < N; row++) {
      int start = row * N;
      if (gameValue[start] != "" &&
          List.generate(N, (i) => gameValue[start + i]).toSet().length == 1) {
        history.add({
          'createdAt': FieldValue.serverTimestamp(),
          'history': gameValue[start],
          'log': List.from(gameValue),
        });
        print("Save to firebase: ${List.from(gameValue)}");
        winnerDialogBox(gameValue[start]);
        return;
      }
    }

    // ตรวจสอบแนวตั้ง
    for (int col = 0; col < N; col++) {
      if (gameValue[col] != "" &&
          List.generate(N, (i) => gameValue[col + i * N]).toSet().length == 1) {
        history.add({
          'createdAt': FieldValue.serverTimestamp(),
          'history': gameValue[col],
          'log': List.from(gameValue),
        });
        print("Save to firebase: ${List.from(gameValue)}");
        winnerDialogBox(gameValue[col]);
        return;
      }
    }

    // ตรวจสอบแนวทแยงมุมหลัก (\)
    if (gameValue[0] != "" &&
        List.generate(N, (i) => gameValue[i * (N + 1)]).toSet().length == 1) {
      history.add({
        'createdAt': FieldValue.serverTimestamp(),
        'history': gameValue[0],
        'log': List.from(gameValue),
      });
      print("Save to firebase: ${List.from(gameValue)}");
      winnerDialogBox(gameValue[0]);
      return;
    }

    // ตรวจสอบแนวทแยงมุมรอง (/)
    if (gameValue[N - 1] != "" &&
        List.generate(N, (i) => gameValue[(i + 1) * (N - 1)]).toSet().length == 1) {
          history.add({
          'createdAt': FieldValue.serverTimestamp(),
          'history': gameValue[N - 1],
          'log': List.from(gameValue),
        });
        print("Save to firebase: ${List.from(gameValue)}");
      winnerDialogBox(gameValue[N - 1]);
      return;
    }

    // ตรวจสอบว่าเสมอหรือไม่
    if (!gameValue.contains("")) {
      history.add({
          'createdAt': FieldValue.serverTimestamp(),
          'history': "Draw",
          'log': List.from(gameValue),
        });
        print("Save to firebase: ${List.from(gameValue)}");
      matchDrawMessage();
    }
  }

  void winnerDialogBox(String winner) {
    Get.defaultDialog(
      title: "🥇 Winner 🥇",
      content: Column(
        children: [
          Icon(Icons.emoji_events, size: 50, color: Colors.green),
          SizedBox(height: 10),
          Text(
            "$winner Wins!",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.close),
                label: Text("Close"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  setGridSize(gridSize.value);
                  Get.back();
                },
                icon: Icon(Icons.play_arrow),
                label: Text("Play Again"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

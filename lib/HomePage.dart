import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'displayhistory.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Controller controller = Get.put(Controller());

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: TabBarView(
            children: [
              GamePage(),
              Displayhistory(),
            ],
          ),
          backgroundColor: Colors.pink[20],
          bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.gamepad),
                text: "Game",
              ),
              Tab(
                icon: Icon(Icons.history),
                text: "History",
              ),
            ],
          ),        
        ));
  }
}

class GamePage extends StatelessWidget {
  GamePage({super.key});
  Controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 238, 241),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 204, 153, 201),
        title: Text(
          "Tic Tac Toe (OX)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            controller.setGridSize(controller.gridSize.value);
          },
        ),
        actions: [
            IconButton(
              icon: Icon(Icons.replay),
              onPressed: () {
                controller.setGridSize(controller.gridSize.value);
              },
            ),
          ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    decoration: BoxDecoration(
                      color: controller.isX.value == false
                          ? const Color.fromARGB(255, 153, 79, 122)
                          : const Color.fromARGB(255, 247, 238, 241),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "O",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Player 1",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    decoration: BoxDecoration(
                      color: controller.isX.value == false
                          ? const Color.fromARGB(255, 247, 238, 241)
                          : const Color.fromARGB(255, 153, 79, 122),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "X",
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 24,
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Player 2",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Obx(() => GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          max(controller.gridSize.value, 3), // ป้องกันค่า 0
                    ),
                    itemCount: controller.gridSize.value *
                        controller.gridSize.value, // คำนวณจำนวนช่อง
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          controller.addValue(index);
                        },
                        child: Obx(() => Container(
                              margin: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 146, 109, 153),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(
                                child: Text(
                                  controller.gameValue[index],
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )),
                      );
                    },
                  )),
            ),
            Obx(() {
              return DropdownButton<int>(
                value:
                    controller.gridSize.value, // ใช้ค่า gridSize จาก controller
                onChanged: (newSize) {
                  controller.setGridSize(
                      newSize!); // เมื่อมีการเลือกใหม่ จะเรียก setGridSize
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
          ]),
        ),
      ),
    );
  }
}

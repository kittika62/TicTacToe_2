import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';
import 'displayhistory.dart';
import 'testfirebase.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Controller controller = Get.put(Controller());
    
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Game X-O"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserForm()),
                  );
                  print('Menu button pressed');
                },
              ),
            ],
          ),
          body: TabBarView(
            children: [
              GamePage(),
              Displayhistory(),
            ],
          ),
          backgroundColor: Colors.pink[20],
          bottomNavigationBar:  TabBar(
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
    return SafeArea(
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
                        ? Colors.purple[200]
                        : Colors.pink[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "O",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Obx(
                () => Container(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  decoration: BoxDecoration(
                    color: controller.isX.value == false
                        ? Colors.pink[100]
                        : Colors.purple[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "X",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Expanded(
            child: Obx(() => GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        max(controller.gridSize.value, 3), // ป้องกันค่า 0
                  ),
                  itemCount:
                      controller.gridSize.value * controller.gridSize.value,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        controller.addValue(index);
                      },
                      child: Obx(() => Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: Colors.purple[100],
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
                  child: Text("${size}x$size"),
                );
              }).toList(),
            );
          }),
        ]),
      ),
    );
  }
}

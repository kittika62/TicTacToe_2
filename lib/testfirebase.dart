import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _savedData = "";
  //เตรียม Firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference character = FirebaseFirestore.instance.collection('Game_character'); //สร้าง collection ชื่อ character

  void _saveData() async{
    if (_formKey.currentState!.validate()) {
      setState(() {
        _savedData =
            "ชื่อ: ${_nameController.text}\nอีเมล: ${_emailController.text}";
        character.add({
          'name': _nameController.text,
          'email': _emailController.text,
        });
        _formKey.currentState!.reset();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("บันทึกข้อมูลสำเร็จ!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("Error: ${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text("แบบฟอร์มกรอกข้อมูล"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(labelText: "ชื่อ-นามสกุล"),
                        validator: (value) =>
                            value!.isEmpty ? "กรุณากรอกชื่อ" : null,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: "อีเมล"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value!.contains("@")
                            ? null
                            : "กรุณากรอกอีเมลให้ถูกต้อง",
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _saveData,
                        child: Text("บันทึก"),
                      ),
                      SizedBox(height: 20),
                      Text(_savedData,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

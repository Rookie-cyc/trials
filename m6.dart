#database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'student.dart';

class DatabaseHelper {
  static Database? _database;
  static DatabaseHelper instance = DatabaseHelper._privateConstructor();

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, 'students.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        String sql =
            'CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, regno TEXT, cgpa REAL)';
        await db.execute(sql);
      },
    );

    return _database!;
  }

  Future<int> insertStudent(Student student) async {
    Database db = await instance.database;
    return await db.insert(
      'students',
      {'name': student.name, 'regno': student.regno, 'cgpa': student.cgpa},
    );
  }

  Future<List<Student>> readAllStudents() async {
    Database db = await instance.database;
    final records = await db.query("students");
    return records.map((record) => Student.fromRow(record)).toList();
  }
}


#main.dart
import 'package:flutter/material.dart';
import 'student.dart';
import 'database_helper.dart';

void main() {
  runApp(const MaterialApp(
    title: "Students Info Management",
    home: StudentsADD(),
  ));
}

class StudentsADD extends StatefulWidget {
  const StudentsADD({super.key});

  @override
  State<StudentsADD> createState() => _StudentsADDState();
}

class _StudentsADDState extends State<StudentsADD> {
  // state variables
  final _formkey = GlobalKey<FormState>();
  final _namecontroller = TextEditingController();
  final _regnocontroller = TextEditingController();
  final _cgpacontroller = TextEditingController();
  List<Student> _students = [];

  void _showAllStudents() async {
    final students = await DatabaseHelper.instance.readAllStudents();
    setState(() {
      _students = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Students Information Management"),
        backgroundColor: const Color.fromARGB(255, 211, 24, 24),
      ),
      body: Form(
        key: _formkey,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: _namecontroller,
                decoration: const InputDecoration(
                  labelText: "Enter Student Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Student Name!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _regnocontroller,
                decoration: const InputDecoration(
                  labelText: "Enter Register Number",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter Register Number!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cgpacontroller,
                decoration: const InputDecoration(
                  labelText: "Enter Student CGPA",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter CGPA!";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    String name = _namecontroller.text;
                    String regno = _regnocontroller.text;
                    double cgpa = double.parse(_cgpacontroller.text);

                    Student student =
                        Student(name: name, regno: regno, cgpa: cgpa);
                    await DatabaseHelper.instance.insertStudent(student);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Data Saved")),
                    );

                    _namecontroller.clear();
                    _regnocontroller.clear();
                    _cgpacontroller.clear();
                    _showAllStudents();
                  }
                },
                child: const Text("Save Details"),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _students.length,
                  itemBuilder: (context, index) {
                    final student = _students[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(student.name[0]),
                      ),
                      title: Text(student.name),
                      subtitle: Text(
                          "Regno: ${student.regno}, CGPA: ${student.cgpa}"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

#student.dart
class Student {
  int? id;
  String name;
  String regno;
  double cgpa;

  Student({
    this.id,
    required this.name,
    required this.regno,
    required this.cgpa,
  });

  factory Student.fromRow(Map<String, dynamic> row) {
    return Student(
      id: row['id'],
      name: row['name'],
      regno: row['regno'],
      cgpa: row['cgpa'],
    );
  }
}


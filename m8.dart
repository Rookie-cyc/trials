#flutter08
#setup database first 
# place this <your_project>/app/google-services.json


#commands

dart pub global activate flutterfire_cli
flutterfire configure


 #android/app/build.gradle


plugins {
    id "com.android.application"
    // START: FlutterFire Configuration
    id 'com.google.gms.google-services'
    // END: FlutterFire Configuration
    id "kotlin-android"
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id "dev.flutter.flutter-gradle-plugin"
}

android {
    namespace = "com.example.flutter08"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.flutter08"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.debug
        }
    }
}

flutter {
    source = "../.."
}
-------------------------------------------
android/build.gradle


allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.buildDir = "../build"
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
---------------------------
#pubspec.yaml

name: flutter08
description: "A new Flutter project."

publish_to: 'none' # Remove this line if you wish to publish to pub.dev

version: 1.0.0+1

environment:
  sdk: ^3.5.3


dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.30.0
  cloud_firestore: ^4.14.0


  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter

 
  flutter_lints: ^4.0.0


flutter:


  uses-material-design: true

------------------------------------
#main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BookSearchPage(),
    );
  }
}

class BookSearchPage extends StatefulWidget {
  const BookSearchPage({super.key});

  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  TextEditingController bookController = TextEditingController();
  String result = "";

  Future<void> searchBook() async {
    var query = await FirebaseFirestore.instance
        .collection('products')
        .where('title', isEqualTo: bookController.text.trim())
        .get();

    if (query.docs.isEmpty) {
      setState(() => result = "❌ Book not found");
    } else {
      var data = query.docs.first.data();
      String title = data['title'];
      String author = data['author'];
      int qty = data['copies'];

      result = "📘 Title: $title\n✍ Author: $author\n📦 Copies: $qty";

      if (qty < 3) {
        result += "\n⚠️ Low Stock!";
      }

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Library Book Search")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: bookController,
              decoration: const InputDecoration(
                labelText: "Enter Book Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: searchBook,
              child: const Text("Search"),
            ),
            const SizedBox(height: 20),
            Text(
              result,
              style: TextStyle(
                fontSize: 18,
                color: result.contains("⚠️") ? Colors.red : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
-------------
#book_search.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookSearchPage extends StatefulWidget {
  @override
  State<BookSearchPage> createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  TextEditingController titleCtrl = TextEditingController();
  String msg = "";

  searchBook() async {
    var data = await FirebaseFirestore.instance
        .collection('books')
        .where('title', isEqualTo: titleCtrl.text.trim())
        .get();

    if (data.docs.isEmpty) {
      setState(() => msg = "Book not found");
    } else {
      var book = data.docs.first.data();
      int copies = book['copies'];
      msg =
          "Title: ${book['title']}\nAuthor: ${book['author']}\nCopies: $copies";

      if (copies == 0) msg += "\n❌ Not Available – All Copies Issued";

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Library Search")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(
            controller: titleCtrl,
            decoration: InputDecoration(labelText: "Enter book title"),
          ),
          ElevatedButton(onPressed: searchBook, child: Text("Search")),
          SizedBox(height: 15),
          Text(msg, style: TextStyle(fontSize: 18))
        ]),
      ),
    );
  }
}
--------------
#commads to run
flutter clean
flutter pub get
flutterfire configure
flutter run



 

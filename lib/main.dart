import 'dart:io';
import 'package:file_pick/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';.
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

Future<void> main() async {
  //next two code lines ensure that this exception that i have mentioned below should not occur in it
  // this exception- I/flutter (14378): [core/no-app] No Firebase App '[DEFAULT]' has been created - call Firebase.initializeApp()
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyArUytNPRnLt-n81RxqWvgzYBHFpquXWKU',
      appId: '1:401210009029:android:5d918132573fe7ce4917ac',
      messagingSenderId: '401210009029',
      projectId: 'filepicker-782b4',
      storageBucket: 'filepicker-782b4.appspot.com',
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? file;
  UploadTask? task;
  late String fileName;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) {
      return;
    } else {
      final path = result.files.single.path!;
      setState(() {
        file = File(path);
      });
    }
  }

  uploadFile() {
    if (file == null) {
      return;
    } else {
      final fileName = basename(file!.path);
      final destination = 'files/$fileName';
      task = MyFirebaseStorage.uploadFile(destination, file!);
      setState(() {
        //refreshes the widget
      });
    }
  }

  Widget uploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
      stream: task.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data!;
          final progress = snap.bytesTransferred / snap.totalBytes;
          final uploadPercent = (progress * 100).toStringAsFixed(2);
          return Text('$uploadPercent %');
        } else {
          return Container();
        }
      });

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      fileName = "No file selected";
    } else {
      fileName = basename(file!.path);
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("File Picker"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    selectFile();
                  },
                  child: const Text("SELECT FILES")),
              Text(fileName),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    uploadFile();
                  },
                  child: const Text('UPLOAD FILE')),
              task != null ? uploadStatus(task!) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

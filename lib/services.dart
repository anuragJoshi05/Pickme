import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
class MyFirebaseStorage{
  static UploadTask? uploadFile(String destination, File file){
    try{
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    } on FirebaseException catch(e){
      print("ERROR OCCURED");
      print(e);
      return null;
    }
    //addon list.buildrr
  }
}

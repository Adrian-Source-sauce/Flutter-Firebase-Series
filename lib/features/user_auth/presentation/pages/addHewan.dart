import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/features/user_auth/presentation/services/database.dart';
import 'package:random_string/random_string.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';


class AddHewan extends StatefulWidget {
  const AddHewan({super.key});

  @override
  State<AddHewan> createState() => _AddHewanState();
}

String? dropdownValue;

class _AddHewanState extends State<AddHewan> {
  TextEditingController jenisHewanController = TextEditingController();
  TextEditingController beratHewanController = TextEditingController();
  TextEditingController asalHewanController = TextEditingController();
  TextEditingController namaPemotongHewanController = TextEditingController();
  File? _image;

  Future<void> pickImage() async {
  final ImagePicker _picker = ImagePicker();
  // Pick an image
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    setState(() {
      _image = File(image.path);
    });
  }
}
Future<String> uploadImageToFirebase(File imageFile) async {
  String downloadURL = "";
  try {
    String fileName = basename(imageFile.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;

    // Get the download URL
    downloadURL = await taskSnapshot.ref.getDownloadURL();
    print("Done: $downloadURL"); // Cetak URL untuk memeriksa konsol debug
  } catch (e) {
    print("Error uploading image: $e");
  }
  return downloadURL;
}


Future<void> saveHewanInfo() async {
  if (_image == null) {
    Fluttertoast.showToast(
      msg: "Silakan pilih gambar terlebih dahulu",
      backgroundColor: Colors.red,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1);
    return; // Keluar dari method jika _image null
  }

  String imageUrl = await uploadImageToFirebase(_image!);

  String Id = randomAlphaNumeric(10);
  final timestamp = Timestamp.fromDate(selectedDate);
  Map<String, dynamic> hewanInfoMap = {
    "jenisHewan": jenisHewanController.text,
    "beratHewan": beratHewanController.text,
    "asalHewan": asalHewanController.text,
    'id': Id,
    "kondisiKesehatan": dropdownValue,
    "namaPemotongHewan": namaPemotongHewanController.text,
    "timestamp": timestamp,
    "imageUrl": imageUrl,
  };

  await FirebaseFirestore.instance.collection('hewan').doc(Id).set(hewanInfoMap).then((value) {
    Fluttertoast.showToast(
        msg: "Data berhasil ditambahkan",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  });
}



  final selectedDate = DateTime.now();

  final CollectionReference collection =
      FirebaseFirestore.instance.collection('time');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Tambah Data Hewan"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back), 
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Jenis Hewan',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                SizedBox(height: 8),
                TextField(
                  controller: jenisHewanController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Berat Hewan (Kg)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: beratHewanController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Asal Hewan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8), 
                TextField(
                  controller: asalHewanController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Kondisi Kesehatan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 200,
                    padding: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownValue,
                        icon: const Icon(Icons.add),
                        style: const TextStyle(color: Colors.deepPurple),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        },
                        items: <String>['Sehat', 'Sakit', 'Mati']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Text(value,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Atas Nama Pemotong Hewan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: namaPemotongHewanController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),


                 ElevatedButton(
              onPressed: () {
                pickImage();
              },
              child: Text('Pilih Gambar Hewan'),
            ),
            _image != null ? Image.file(_image!) : Container(),
          


                SizedBox(height: 26),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 204, 0),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                     if (_image == null) {
    Fluttertoast.showToast(
      msg: "Silakan pilih gambar terlebih dahulu",
      backgroundColor: Colors.red,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1);
    return;
  }
  await saveHewanInfo();  
                    // await uploadImageToFirebase(context);
                    // if (dropdownValue == 'Sakit' || dropdownValue == 'Mati') {
                    //   // Show an error message
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //         content: Text(
                    //             'Hewan yang sakit atau mati tidak dapat ditambahkan ke dalam sistem')),
                    //   );
                    // } else {
                    //   String Id = randomAlphaNumeric(10);
                    //   final timestamp = Timestamp.fromDate(selectedDate);
                    //   Map<String, dynamic> hewanInfoMap = {
                    //     "jenisHewan": jenisHewanController.text,
                    //     "beratHewan": beratHewanController.text,
                    //     "asalHewan": asalHewanController.text,
                    //     'id': Id,
                    //     "kondisiKesehatan": dropdownValue,
                    //     "namaPemotongHewan": namaPemotongHewanController.text,
                    //     "timestamp": timestamp,
                        
                    //   };

                    //   final docRef = collection.doc('time');
                    //   await docRef.set(hewanInfoMap).then((value) {});

                    //   await DatabaseMethods()
                    //       .addHewanDetails(hewanInfoMap, Id)
                    //       .then((value) {
                    //     Fluttertoast.showToast(
                    //         msg: "Data berhasil ditambahkan",
                    //         backgroundColor: Colors.green,
                    //         textColor: Colors.white,
                    //         toastLength: Toast.LENGTH_SHORT,
                    //         gravity: ToastGravity.BOTTOM,
                    //         timeInSecForIosWeb: 1);
                    //   });
                    // }
                  },
                  child: Text("Tambah",
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 33, 29, 29))),
                )
              ],
            ),
          ),
        ));
  }
}

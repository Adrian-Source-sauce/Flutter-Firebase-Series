import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/features/user_auth/presentation/model/hewan.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/addHewan.dart';
import 'package:flutter_firebase/features/user_auth/presentation/model/time.dart';
import 'package:flutter_firebase/features/user_auth/presentation/services/database.dart';

class LookData extends StatefulWidget {
  const LookData({super.key});

  @override
  State<LookData> createState() => _LookDataState();
}

String? dropdownValue;

class _LookDataState extends State<LookData> {
  Stream? HewanStream;
  final CollectionReference collection =
      FirebaseFirestore.instance.collection('time');

  TextEditingController jenisHewanController = TextEditingController();
  TextEditingController beratHewanController = TextEditingController();
  TextEditingController asalHewanController = TextEditingController();
  TextEditingController namaPemotongHewanController = TextEditingController();
  final selectedDate = DateTime.now();
//   final retrievedAnimalData = Time.fromMap(doc.data() as Map<String, dynamic>);

//   final retrievedTimestamp = retrievedAnimalData.timestamp;
// final retrievedDateTime = retrievedTimestamp.toDate();

  // Future<void> getAnimal() async {
  //   final doc = await collection.doc('time').get();
  //   final retrievedAnimalData = hewanList(doc.data());
  //   // Use retrievedAnimalData here
  // }

  Widget allHewanList() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('hewan').snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        // final filteredDocs = snapshot.data.docs.where((doc) {
        //   return search.isEmpty ||
        //       doc['jenisHewan'].toLowerCase().contains(search.toLowerCase());
        // }).toList();
        // final filteredDocs = snapshot.data.docs.where((doc) {
        //   return search.isEmpty ||
        //       doc['beratHewan']
        //           .toString()
        //           .toLowerCase()
        //           .contains(search.toLowerCase());
        // }).toList();
        // final filteredDocs = snapshot.data.docs.where((doc) {
        //   final date =
        //       DateFormat('yyyy-MM-dd').format(doc['timestamp'].toDate());
        //   return search.isEmpty || date.contains(search);
        // }).toList();
        final filteredDocs = snapshot.data.docs.where((doc) {
          final date =
              DateFormat('yyyy-MM-dd').format(doc['timestamp'].toDate());
          return search.isEmpty ||
              doc['jenisHewan'].toLowerCase().contains(search.toLowerCase()) ||
              doc['namaPemotongHewan']
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              doc['beratHewan']
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase()) ||
              date.contains(search);
        }).toList();
        return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = filteredDocs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            width: 150.0, // Tentukan lebar tetap
                            height: 150.0, // Tentukan tinggi tetap
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  50), // Membuat sudut kontainer menjadi circular
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  20), // Membuat gambar menjadi circular
                              child: Image.network(
                                ds["imageUrl"],
                                fit: BoxFit
                                    .cover, // Mengisi kontainer sepenuhnya tanpa mengubah rasio aspek
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Text(
                                      'Could not load image'); // Tampilkan teks ini jika gambar tidak dapat dimuat
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Jenis Hewan : ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ds["jenisHewan"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: Colors
                                              .orange, // Change this to your desired color
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    jenisHewanController.text =
                                        ds["jenisHewan"];
                                    beratHewanController.text =
                                        ds["beratHewan"];
                                    asalHewanController.text = ds["asalHewan"];
                                    dropdownValue = ds["kondisiKesehatan"];
                                    namaPemotongHewanController.text =
                                        ds["namaPemotongHewan"];
                                    EditHewan(ds["id"]);
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('Hapus data'),
                                            content:
                                                const Text('Apa anda yakin'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child:
                                                      const Text('Batalkan')),
                                              TextButton(
                                                  onPressed: () {
                                                    DatabaseMethods()
                                                        .deleteHewanDetails(
                                                            ds["id"]);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Hapus"))
                                            ],
                                          );
                                        });
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Berat Hewan : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ds["beratHewan"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Colors
                                            .orange, // Change this to your desired color
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Asal Hewan : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ds["asalHewan"],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Colors
                                            .orange, // Change this to your desired color
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                  text: "Kondisi Kesehatan : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.blue,
                                  ),
                                ),
                                TextSpan(
                                  text: ds["kondisiKesehatan"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors
                                        .orange, // Change this to your desired color
                                  ),
                                )
                              ]))),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                                text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Atas Nama Pemotong : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blue,
                                  ),
                                ),
                                TextSpan(
                                  text: ds["namaPemotongHewan"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors
                                        .orange, // Change this to your desired color
                                  ),
                                ),
                              ],
                            )),
                          ),
                          Text(
                            DateFormat('yyyy-MM-dd')
                                .format(ds["timestamp"].toDate()),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
              );
            });
      },
    );
  }

  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Lihat Data"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              //      ElevatedButton(
              //   onPressed: () {
              //     // Navigate to addHewan.dart and pass the addDataToList function
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => AddHewan(addDataCallback: addDataToList),
              //       ),
              //     );
              //   },
              //   child: Text('Add Data'),
              // ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Cari Hewan",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Expanded(child: allHewanList()),
            ],
          )),
    );
  }

  Future EditHewan(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () => {Navigator.pop(context)},
                            child: Icon(Icons.cancel)),
                        SizedBox(width: 30),
                        Text(
                          "Edit Data Hewan",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Jenis Hewan',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 200,
                        padding: EdgeInsets.only(left: 8),
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
                        'Atas Nama Pemotong',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: namaPemotongHewanController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: () {
                          Map<String, dynamic> hewanInfoMap = {
                            "jenisHewan": jenisHewanController.text,
                            "beratHewan": beratHewanController.text,
                            "asalHewan": asalHewanController.text,
                            "kondisiKesehatan": dropdownValue,
                            "namaPemotongHewan":
                                namaPemotongHewanController.text,
                          };
                          DatabaseMethods()
                              .editHewanDetails(id, hewanInfoMap)
                              .then((value) {
                            Navigator.pop(context);
                          });
                          Navigator.pop(context);
                        },
                        child: Text("Edit Data"))
                  ],
                ),
              ),
            ),
          ));
}

import 'package:flutter/material.dart';

class AddHewan extends StatefulWidget {
  const AddHewan({super.key});

  @override
  State<AddHewan> createState() => _AddHewanState();
}

class _AddHewanState extends State<AddHewan> {
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
      body: Center(
        child: Text("Tambah Data Hewan"),
      ),
    );
  }
}

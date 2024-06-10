import 'package:flutter/material.dart';

class LookData extends StatefulWidget {
  const LookData({super.key});

  @override
  State<LookData> createState() => _LookDataState();
}

class _LookDataState extends State<LookData> {
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
      body: Center(
        child: Text("Lihat Data"),
      ),
    );
  }
}
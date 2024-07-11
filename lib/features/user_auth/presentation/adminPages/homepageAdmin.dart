import 'package:flutter/material.dart';

class Homepageadmin extends StatefulWidget {
  const Homepageadmin({super.key});

  @override
  State<Homepageadmin> createState() => _HomepageadminState();
}

class _HomepageadminState extends State<Homepageadmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homepage Admin'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/hewan');
              },
              child: Text('Data Hewan'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/lihat');
              },
              child: Text('Lihat Data'),
            ),
          ],
        ),
      ),
    );
  }
}
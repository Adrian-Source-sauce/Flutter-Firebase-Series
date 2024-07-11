import 'package:flutter/material.dart';
import 'package:flutter_firebase/features/user_auth/presentation/model/hewan.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/addHewan.dart';

class Hewan extends StatefulWidget {
  const Hewan({super.key});

  @override
  State<Hewan> createState() => _HewanState();
}

class _HewanState extends State<Hewan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Pilih Hewan"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AddHewan();
                  }));
                },
                child: Container(
                  color: const Color.fromARGB(255, 106, 131, 151),
                  margin: EdgeInsets.all(4.0),
                  child: Center(
                    child: Column(
                      children: <Widget> [
                        Image.network(hewanList[index].imageUrl,
                          width: 170,
                          height: 140,
                          fit: BoxFit.cover,),
                        Text(hewanList[index].name,
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                                          ),
                      ],
                    ),
                  )
                ));
          },
          itemCount: hewanList.length,
        ));
  }
}

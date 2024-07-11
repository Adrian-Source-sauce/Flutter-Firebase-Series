import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import '../../../../global/common/toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List imageList = [
    {
      "id": 1,
      "image":
          'https://assets.promediateknologi.id/crop/0x0:0x0/750x500/webp/photo/2023/06/11/funny-goats-1680x1050-entertainment-funny-hd-art-wallpaper-preview-2846425286.jpg'
    },
    {
      "id": 2,
      "image":
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPQ6FHLQHq9c1FpZr4d2DEQkILR5ogV_FDIA&s'
    },
    {
      "id": 3,
      "image":
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmVDxUjIl7w0kLwjaPKNmTA3_ja8q3hjPDNw&s'
    },
  ];

  final List<Map<String, dynamic>> buttons = [
    {
      "text": "Tambah Data",
      "icon": Icons.add, // Example icon
      "route": "/hewan",
    },
    {
      "text": "Lihat Data",
      "icon": Icons.remove_red_eye, // Another example icon
      "route": "/lihat",
    },
    // Add more buttons as needed
  ];

//   IconData getIconData(dynamic iconName) {
//   if (iconName is String && iconMap.containsKey(iconName)) {
//     return iconMap[iconName]!;
//   }
//   return Icons.error; // Fallback icon
// }

  final CarouselController carouselController = CarouselController();
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(""),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Portal Berita Peternakan",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Stack(
                children: [
                  InkWell(
                    onTap: () {
                      print(_current);
                    },
                    child: CarouselSlider(
                        items: imageList
                            .map((item) => Image.network(
                                  item['image'],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ))
                            .toList(),
                        carouselController: carouselController,
                        options: CarouselOptions(
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlay: true,
                          aspectRatio: 2.0,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        )),
                  ),
                  Positioned(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imageList.asMap().entries.map((entry) {
                        print(entry);
                        print(entry.key);
                        return GestureDetector(
                          onTap: () =>
                              carouselController.animateToPage(entry.key),
                          child: Container(
                            width: _current == entry.key ? 17 : 7,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: _current == entry.key
                                  ? Colors.blue
                                  : Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: buttons.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Adjust number of columns
                    crossAxisSpacing: 10, // Horizontal space between items
                    mainAxisSpacing: 10, // Vertical space between items
                  ),
                  itemBuilder: (context, index) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, buttons[index]["route"]!);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            buttons[index]["icon"] != null
                                ? buttons[index]["icon"] as IconData
                                : Icons.error,
                          ),
                          SizedBox(width: 8),
                          Text(
                            buttons[index]["text"]!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut().then((_) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushNamed(context, "/login");
                        showToast(message: "Successfully signed out");
                      });
                    });
                  },
                  child: Text("Sign Out"),
                ),
              ),
            ],
          ),
        ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addHewanDetails(Map<String, dynamic> hewanInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("hewan")
        .doc(id)
        .set(hewanInfoMap);
  }

  Future<Stream<QuerySnapshot>> getHewanDetails() async {
    return await FirebaseFirestore.instance.collection("hewan").snapshots();
  }
  Future editHewanDetails(String id, Map<String, dynamic> hewanInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("hewan")
        .doc(id)
        .update(hewanInfoMap);
  }
  Future deleteHewanDetails(String id) async {
    return await FirebaseFirestore.instance
        .collection("hewan")
        .doc(id)
        .delete();
  }

}

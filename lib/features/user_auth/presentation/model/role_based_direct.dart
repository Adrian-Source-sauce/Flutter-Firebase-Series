import 'package:flutter/material.dart';
import 'package:flutter_firebase/features/user_auth/presentation/adminPages/homepageAdmin.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/home_page.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoleBasedRedirect extends StatefulWidget {
  @override
  _RoleBasedRedirectState createState() => _RoleBasedRedirectState();
}

class _RoleBasedRedirectState extends State<RoleBasedRedirect> {
  Future<String> checkUserAuthenticationAndRole() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    User? user = auth.currentUser;
    if (user != null) {
      // Assuming there's a 'users' collection with documents named after user UIDs
      // and each user document has a 'role' field
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(user.uid).get();
          
      if (userDoc.exists && userDoc.data() is Map) {
        final userData = userDoc.data() as Map<String, dynamic>;
        return userData['role'] ??
            'user'; // Default to 'user' role if not specified
      }
    }
    
    return ''; // Return an empty string or a specific value to indicate unauthenticated/no role
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: checkUserAuthenticationAndRole(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print("Role from snapshot: ${snapshot.data}");
          // Check user role and navigate accordingly
          if (snapshot.data == 'admin') {
            // Navigate to Admin home page
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Homepageadmin()));
            });
            print("Role from snapshot: ${snapshot.data}");
          } else if (snapshot.data == 'user') {
            // Navigate to Regular user home page
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomePage()));
            });
          } else {
            // Navigate to Login page for unauthenticated users or users without a role
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            });
          }
          // Return a container to avoid widget return errors
          return Container();
        } else {
          // Show a loading indicator while waiting for the future to complete
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

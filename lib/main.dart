import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter_firebase/features/app/splash_screen/splash_screen.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/home_page.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/login_page.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/sign_up_page.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyC1U33Uw2ebz_DsJh15jCVW1QvJf4okMrc",
          authDomain: "flutter-firebase-1cf76.firebaseapp.com",
          databaseURL:
              "https://flutter-firebase-1cf76-default-rtdb.asia-southeast1.firebasedatabase.app",
          projectId: "flutter-firebase-1cf76",
          storageBucket: "flutter-firebase-1cf76.appspot.com",
          messagingSenderId: "1080900388377",
          appId: "1:1080900388377:web:7516e9b445a4f0e08f4c88",
          measurementId: "G-25KKWEW8PV"
          // Your web Firebase config options
          ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: LoginPage(),
            ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
      },
      
    );
  }
}

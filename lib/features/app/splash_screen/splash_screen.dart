import 'package:flutter/material.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/home_page.dart';
import 'package:flutter_firebase/features/user_auth/presentation/pages/login_page.dart';
// import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, required child});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
    });

    return Scaffold(
      backgroundColor: Colors.blueGrey,
        body: Stack(children: [
      Padding(
        padding: const EdgeInsets.only(top: 230),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/sapi.png'),
              fit: BoxFit.contain,
            ),
          ),
          alignment: Alignment.center,
        ),
      ),
      Center(
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            Image.asset('assets/images/Logo.png'),
            const SizedBox(
              height: 50,
            ),
            // Spacer(),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 20),
            //   child: RichText(
            //       textAlign: TextAlign.center,
            //       text: TextSpan(
            //         text: "Helping you\n to keep ",
            //         style: GoogleFonts.manrope(
            //             fontSize: 24,
            //             color: Color.fromARGB(255, 107, 131, 226),
            //             letterSpacing: 3.5 / 100,
            //             height: 152 / 100),
            //         children: const [
            //           TextSpan(
            //               text: "your bestie",
            //               style: TextStyle(
            //                   color: Color.fromARGB(255, 80, 123, 210), fontWeight: FontWeight.w800)),
            //           TextSpan(
            //             text: ' \n stay healthy',
            //           )
            //         ],
            //       )),
            // ),
          ],
        )),
      )
    ]));
  }
}

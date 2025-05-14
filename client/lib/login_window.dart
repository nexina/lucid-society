import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'board_window.dart';
import 'info_window.dart';
import 'appwrite_client.dart';
import 'package:appwrite/enums.dart';

class LoginWindow extends StatefulWidget {
  const LoginWindow({super.key});

  @override
  State<LoginWindow> createState() => _LoginWindowState();
}

class _LoginWindowState extends State<LoginWindow> {
  @override
  void initState() {
    super.initState();

    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    if (await isLoggedIn()) {
      print('logged in');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BoardWindow(),
          ),
        );
      });
    } else {
      print("logged out");
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await account.createOAuth2Session(provider: OAuthProvider.google);
      // Wait for login to complete and then check session
      await Future.delayed(Duration(seconds: 2)); // Let redirect complete
      if (await isLoggedIn()) {
        print("I AM FUCKING HERE");
        await setDataFromAuthtoDB();
        print("MINEawID: $awID");

        DocumentList userData = await getUserDatabase();
        print("USER DATA: ${userData.documents.length}");
        if (userData.documents.isEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InfoWindow()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BoardWindow()),
          );
          await setValues();
        }
      }
    } catch (e) {
      print("OAuth login error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF303032),
            Color(0xFF1C1C1C),
          ],
        ),
      ),
      child: Stack(children: [
        Stack(children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
            child: Image(
              image: AssetImage('assets/images/splash.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
              left: 0,
              top: MediaQuery.of(context).size.height * 0.1,
              child: Image(
                image: AssetImage('assets/images/splash_logo.png'),
                width: 350,
              )),
        ]),
        Positioned(
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(200)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF9BA4D4),
                  Color(0xFF50556E),
                ],
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: 250,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    signInWithGoogle(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/images/google.png"),
                      ),
                      SizedBox(width: 8),
                      Text('Sign in with email'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

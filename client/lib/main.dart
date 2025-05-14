import 'package:flutter/material.dart';
import 'login_window.dart';
import 'board_window.dart';
import 'appwrite_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppwriteClient();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SafeArea(
        child: Scaffold(
          body: FutureBuilder<bool>(
            future: isLoggedIn(), // Call the async function to check session
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child:
                        CircularProgressIndicator()); // Wait while checking login status
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data == true) {
                return BoardWindow(); // Already logged in, go to BoardWindow
              } else {
                return LoginWindow(); // Not logged in, show login screen
              }
            },
          ),
        ),
      ),
    );
  }
}

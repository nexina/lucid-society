import 'package:flutter/material.dart';
import 'board_window.dart';
import 'package:appwrite/appwrite.dart';
import 'appwrite_client.dart';

class InfoWindow extends StatelessWidget {
  const InfoWindow({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF303032),
                Color(0xFF1C1C1C),
              ],
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'We want to know more about you!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      'Select your birthdate',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    CalendarDatePicker(
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100),
                        onDateChanged: (date) {
                          selectedDate = date;
                        }),
                    ElevatedButton(
                      onPressed: () async {
                        createUserData(
                                awEmail, awName, selectedDate.toIso8601String())
                            .then((_) {
                          // Navigate to the next screen after the data is successfully added
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BoardWindow(),
                            ),
                          );
                        }).catchError((error) {
                          // Handle any errors here
                          print("Failed to add data: $error");
                        });
                      },
                      child: Text("All Done"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

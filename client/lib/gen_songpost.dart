import 'dart:ui';

import 'package:flutter/material.dart';
import 'components.dart';

class GenSongPost extends StatefulWidget {
  const GenSongPost({super.key});

  @override
  State<GenSongPost> createState() => _GenSongPostState();
}

class _GenSongPostState extends State<GenSongPost> {
  @override
  Widget build(BuildContext context) {
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
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back, color: Colors.white)),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Generate New Music",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        ),
                      ),
                      CoinsWidget()
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 2, color: Colors.white),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    'assets/images/music.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned.fill(
                                    child: Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: IconButton(
                                          onPressed: () {},
                                          iconSize: 60,
                                          icon: Icon(Icons.play_arrow),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: Text(
                                        "0:00 / 0:47",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )),
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 15, sigmaY: 15),
                                    child: Container(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  Center(
                                      child: Text(
                                    "No Music Generated",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          offset: Offset(0, 2),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                "Make Prompt Public ?",
                                style: TextStyle(color: Colors.white),
                              )),
                              Switch(value: false, onChanged: (value) {})
                            ],
                          ),
                          Container(
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Prompt for the music",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextField(
                                        maxLength: 100,
                                        maxLines: 3,
                                        minLines: 2,
                                        textInputAction:
                                            TextInputAction.newline,
                                        keyboardType: TextInputType.multiline,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText:
                                              "Try 'Spongebob theme song but weeknd is singing it'",
                                          hintStyle: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 65, 65, 65)),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.refresh))),
                            ]),
                          ),
                          Container(
                            padding: const EdgeInsets.all(14.0),
                            margin: const EdgeInsets.symmetric(vertical: 14.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Description",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  TextField(
                                    maxLines: 6,
                                    minLines: 5,
                                    textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.multiline,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: "Enter Description",
                                      hintStyle: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 65, 65, 65)),
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: TextButton(
                              onPressed: () {}, child: Text("Post"))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

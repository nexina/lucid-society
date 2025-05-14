import 'dart:ui';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucid_society/appwrite_client.dart';
import 'package:lucid_society/board_window.dart';
import 'package:lucid_society/resources.dart';
import 'components.dart';
import 'package:path_provider/path_provider.dart';

class GenerateArtPost extends StatefulWidget {
  const GenerateArtPost({super.key});

  @override
  State<GenerateArtPost> createState() => _GenerateArtPostState();
}

class _GenerateArtPostState extends State<GenerateArtPost> {
  bool makePromptPublic = false;

  String imageLoc = 'assets/images/art.jpg';

  String imageBase64 = "";
  TextEditingController promptController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  String prompt = "";
  String desc = "";

  Future<String> convertBase64ToImageFile(String base64String) async {
    final bytes = base64Decode(
        imageBase64.replaceFirst(RegExp(r'^data:image\/[^;]+;base64,'), ''));

    final directory = await getTemporaryDirectory();

    final filePath =
        '${directory.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }

  GlobalKey stackKey = GlobalKey();
  Timer? _scannerTimer;

  double scannerTopPos = 0;
  double scannerSpeed = 2;
  bool movingDown = true;
  bool setScannerVisibility = false;
  bool isAnimating = false;

  String generateArtText = "No Art Generated";

  void playScannerAnimation() {
    RenderBox renderBox =
        stackKey.currentContext?.findRenderObject() as RenderBox;
    double maxHeight = renderBox.size.height;
    setScannerVisibility = true;
    scannerTopPos = 0;
    movingDown = true;
    _scannerTimer?.cancel();

    isAnimating = true;

    _scannerTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (!isAnimating) {
        timer.cancel();
        return;
      }

      if (movingDown) {
        scannerTopPos += scannerSpeed;
        if (scannerTopPos >= maxHeight - 100) {
          movingDown = false;
        }
      } else {
        scannerTopPos -= scannerSpeed;
        if (scannerTopPos <= 0) {
          movingDown = true;
        }
      }

      setState(() {});
    });
  }

  Future<void> getGenImageData(String prompt) async {
    imageBase64 = "";

    playScannerAnimation();
    generateArtText = "Generating Art...";

    await Future.delayed(Duration(seconds: 3));
    String getImageData = timageData;

    isAnimating = false; // Stop the animation
    _scannerTimer?.cancel();

    setState(() {
      imageBase64 = getImageData;
      setScannerVisibility = false;
    });
  }

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
                            "Generate New Art",
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
                                key: stackKey,
                                children: [
                                  (imageBase64 == '')
                                      ? Image.asset(imageLoc)
                                      : Image.memory(
                                          base64Decode(imageBase64.replaceFirst(
                                              RegExp(
                                                  r'^data:image\/[^;]+;base64,'),
                                              '')),
                                          fit: BoxFit.cover,
                                        ),
                                  BackdropFilter(
                                    enabled: (imageBase64 == ''),
                                    filter: ImageFilter.blur(
                                        sigmaX: 15, sigmaY: 15),
                                    child: Container(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  Visibility(
                                    visible: setScannerVisibility,
                                    child: Positioned(
                                      top: scannerTopPos,
                                      left: 0,
                                      child: Image.asset(
                                        "assets/images/scanner.png",
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: imageBase64 == '',
                                    child: Center(
                                        child: Text(
                                      generateArtText,
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
                                  ),
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
                              Switch(
                                  value: makePromptPublic,
                                  onChanged: (value) {
                                    setState(() {
                                      makePromptPublic = value;
                                    });
                                  })
                            ],
                          ),
                          Container(
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.5),
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
                                        "Prompt for the art",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      TextField(
                                        controller: promptController,
                                        maxLength: 100,
                                        maxLines: 3,
                                        minLines: 2,
                                        textInputAction:
                                            TextInputAction.newline,
                                        keyboardType: TextInputType.multiline,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          hintText:
                                              "Try 'A beautiful sunset over a calm ocean'",
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
                                      onPressed: () async {
                                        if (promptController.text.isEmpty) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Error"),
                                                content: Text(
                                                    "Prompt cannot be empty"),
                                                actions: [
                                                  TextButton(
                                                    child: Text("OK"),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                          return;
                                        }
                                        prompt = promptController.text;
                                        await getGenImageData(prompt);
                                      },
                                      icon: Icon(Icons.refresh))),
                            ]),
                          ),
                          Container(
                            padding: const EdgeInsets.all(14.0),
                            margin: const EdgeInsets.symmetric(vertical: 14.0),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.5),
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
                                    controller: descriptionController,
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
                          child: isLoading
                              ? Center(child: CircularProgressIndicator())
                              : TextButton(
                                  onPressed: () async {
                                    if (descriptionController.text.isNotEmpty) {
                                      desc = descriptionController.text;
                                    }

                                    if (awCoins == 0) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Error"),
                                            content: Text(
                                                "You don't have enough coins to post"),
                                            actions: [
                                              TextButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      return;
                                    }
                                    if (desc.isEmpty || prompt.isEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Error"),
                                            content: Text(
                                                "You have to generate image and add description to post"),
                                            actions: [
                                              TextButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      return;
                                    } else {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      String filepath =
                                          await convertBase64ToImageFile(
                                              imageBase64);

                                      String fileID =
                                          await uploadGeneratedImage(filepath);

                                      addPosts(prompt, desc, fileID, awName,
                                              makePromptPublic)
                                          .then((_) {
                                        reduceCoin(1);
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BoardWindow()));
                                      });
                                    }
                                  },
                                  child: Text("Post"))),
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

import 'package:flutter/material.dart';
import 'package:lucid_society/board_window.dart';
import 'components.dart';
import 'gen_artpost.dart';
import 'gen_songpost.dart';

List<Map<String, String>> postTypeList = [
  {
    "title": "Art",
    "image": "assets/images/art.jpg",
    "description": "Post a new post",
  },
  {
    "title": "Song",
    "image": "assets/images/music.jpg",
    "description": "Post a new post",
  },
  {
    "title": "Story",
    "image": "assets/images/story.jpg",
    "description": "Post a new post",
  },
];

class ContentWindow extends StatelessWidget {
  const ContentWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
                HeaderBack(
                    title: "Create Post",
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        PostListItem(
                          title: postTypeList[0]["title"]!,
                          image: postTypeList[0]["image"]!,
                          description: postTypeList[0]["description"]!,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GenerateArtPost(),
                              ),
                            );
                          },
                        ),
                        PostListItem(
                          title: postTypeList[1]["title"]!,
                          image: postTypeList[1]["image"]!,
                          description: postTypeList[1]["description"]!,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GenSongPost(),
                              ),
                            );
                          },
                        ),
                        PostListItem(
                          title: postTypeList[2]["title"]!,
                          image: postTypeList[2]["image"]!,
                          description: postTypeList[2]["description"]!,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BoardWindow()
                                  // StorypostWindow(account: account),
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  //   child: ListView.builder(
                  //     itemCount: postTypeList.length,
                  //     itemBuilder: (context, index) {
                  //       return PostListItem(
                  //         title: postTypeList[index]["title"]!,
                  //         image: postTypeList[index]["image"]!,
                  //         description: postTypeList[index]["description"]!,
                  //       );
                  //     },
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

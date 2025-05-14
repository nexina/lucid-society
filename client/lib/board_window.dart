import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:lucid_society/profile_window.dart';
import 'package:lucid_society/content_window.dart';
import 'appwrite_client.dart';

import 'components.dart';

class BoardWindow extends StatefulWidget {
  const BoardWindow({super.key});

  @override
  State<BoardWindow> createState() => _BoardWindowState();
}

class _BoardWindowState extends State<BoardWindow>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchContentList();
  }

  Future<void> setData() async {
    await setDataFromAuthtoDB();
    await setValues();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List cList = [];
  List pList = [];

  Future<void> fetchContentList() async {
    cList = await contentList(); // Fetch the content list and store it
    setState(() {}); // Call setState to update the UI
  }

  Future<List> contentList() async {
    DocumentList contents = await getContentsFromDatabase();
    List result = [];
    for (var i in contents.documents) {
      List temp = [];
      if (i.data['type'] == 'post') {
        temp.add(i.data['type']);
        temp.add(i.$id);
        temp.add(await getPostContentData(i.data["documentID"]));
        pList.add(temp);
      }
      result.add(temp);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    setData();

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
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/images/splash_logo.png',
                            height: 55,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TabBar(
                                controller: _tabController,
                                tabAlignment: TabAlignment.center,
                                labelPadding:
                                    EdgeInsets.symmetric(horizontal: 10),
                                dividerHeight: 0,
                                isScrollable: true,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor: Colors.white,
                                indicatorWeight: 3,
                                labelStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                unselectedLabelStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                                tabs: [
                                  Tab(text: 'All'),
                                  Tab(text: 'Posts'),
                                  Tab(text: 'Songs'),
                                  Tab(text: 'Story'),
                                ],
                              ),
                            ),
                          ),
                          CoinsWidget(),
                        ])),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ListView.builder(
                        reverse: true,
                        itemCount: cList.length,
                        itemBuilder: (context, index) {
                          return (cList[index][0] == 'post')
                              ? ArtPost(
                                  contentID: cList[index][1],
                                  post: cList[index][2],
                                )
                              : Container();
                        },
                      ),
                      ListView.builder(
                        itemCount: pList.length,
                        itemBuilder: (context, index) {
                          return ArtPost(
                            contentID: pList[index][1],
                            post: pList[index][2],
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return;
                        },
                      ),
                      ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return;
                        },
                      ),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 60,
                      margin: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xFF9BA4D4),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.home_filled,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          IconButton(
                            icon: Icon(Icons.person, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileWindow(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -10,
                      left: MediaQuery.of(context).size.width / 2 - 30,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContentWindow(),
                            ),
                          );
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFF50556E),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/three-stars.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

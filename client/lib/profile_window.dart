import 'package:appwrite/models.dart';

import 'components.dart';
import 'package:flutter/material.dart';

import 'package:lucid_society/login_window.dart';

import 'appwrite_client.dart';

import 'data.dart';

class ProfileWindow extends StatefulWidget {
  const ProfileWindow({super.key});

  @override
  State<ProfileWindow> createState() => _ProfileWindowState();
}

class _ProfileWindowState extends State<ProfileWindow>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late String name = awName;
  late String bio = awBio;

  Future<void> fetchMyContentList() async {
    mcList = await myContentList();
    setState(() {});
  }

  Future<void> fetchMySavedList() async {
    msList = await mySavedList();
    setState(() {});
  }

  Future<List> myContentList() async {
    List result = [];
    DocumentList myContentsDL = await getContentsFromMyContents();
    for (var i in myContentsDL.documents) {
      if (i.data['type'] == 'post') {
        List temp = [];
        temp.add(i.data['type']);
        temp.add(i.$id);
        temp.add(await getPostContentData(i.data["documentID"]));
        result.add(temp);
      }
    }

    return result;
  }

  Future<List> mySavedList() async {
    List result = [];
    DocumentList myContentsDL = await getContentsFromMySaved();
    for (var i in myContentsDL.documents) {
      if (i.data['type'] == 'post') {
        List temp = [];
        temp.add(i.data['type']);
        temp.add(i.$id);
        temp.add(await getPostContentData(i.data["documentID"]));
        result.add(temp);
      }
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
    // fetchUserData();
    _tabController = TabController(length: 2, vsync: this);

    fetchMyContentList();
    fetchMySavedList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> changeBio(String newBio) async {
    await updateUserBio(newBio);
    setState(() {
      bio = newBio;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController bioController = TextEditingController(text: bio);
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
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                ),
                IconButton(
                  onPressed: () {
                    signOut().then((value) {
                      if (value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginWindow(),
                          ),
                        );
                      }
                    });
                  },
                  icon: Icon(Icons.logout),
                  color: Colors.white,
                )
              ]),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      onTapOutside: (event) {
                        setState(() {
                          changeBio(bioController.text);
                        });
                      },
                      controller: bioController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Enter Bio',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(color: Colors.white),
                    ),

                    // GestureDetector(
                    //   onTap: () {},
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 15.0, bottom: 8.0),
                    //     child: Text(
                    //       "Follow",
                    //       style: TextStyle(
                    //           color: Color(0xFF9BA4D4),
                    //           fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              Divider(endIndent: 30, indent: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TabBar(
                  controller: _tabController,
                  // tabAlignment: TabAlignment.center,
                  dividerHeight: 0,
                  // isScrollable: true,
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
                    Tab(text: 'Contents'),
                    Tab(text: 'Saved'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    ListView.builder(
                      itemCount: mcList.length, // specify the number of items
                      itemBuilder: (context, index) {
                        if (mcList[index][0] == 'post') {
                          return ArtPost(
                            contentID: mcList[index][1],
                            post: mcList[index][2],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    ListView.builder(
                      itemCount: msList.length, // specify the number of items
                      itemBuilder: (context, index) {
                        if (msList[index][0] == 'post') {
                          return ArtPost(
                            contentID: msList[index][1],
                            post: msList[index][2],
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

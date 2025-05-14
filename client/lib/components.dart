import 'package:flutter/material.dart';
import 'appwrite_client.dart';

import 'class.dart';

class ArtPost extends StatefulWidget {
  final String contentID;
  final Post post;
  const ArtPost({super.key, required this.contentID, required this.post});

  @override
  State<ArtPost> createState() => _ArtPostState();
}

class _ArtPostState extends State<ArtPost> {
  void refreshPost() {
    getPostContentData(widget.post.id);
    setState(() {});
  }

  void refreshSaved() {
    setValues();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: MemoryImage(widget.post.image),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 15,
              left: 15,
              child: Text(
                widget.post.username,
                style: TextStyle(color: Colors.white, shadows: [
                  Shadow(color: Colors.black, offset: Offset(0, 1))
                ]),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.post.description.length > 30
                        ? '${widget.post.description.substring(0, 30)}...'
                        : widget.post.description,
                    style: TextStyle(color: Colors.white, shadows: [
                      Shadow(color: Colors.black, offset: Offset(0, 1))
                    ]),
                  ),
                  (widget.post.showPrompt)
                      ? Text(
                          widget.post.prompt!.length > 15
                              ? '"${widget.post.prompt!.substring(0, widget.post.prompt!.length > 30 ? 30 : widget.post.prompt!.length)}..."'
                              : '"${widget.post.prompt!}"',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 198, 198, 198),
                              fontSize: 10,
                              shadows: [
                                Shadow(
                                    color: Colors.black, offset: Offset(0, 1))
                              ]),
                        )
                      : Container(),
                ],
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: IconButton(
                  onPressed: () async {
                    await updatePostReacted(widget.post);
                    refreshPost();
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: widget.post.likes.contains(awID)
                        ? Colors.pink
                        : Colors.white,
                  )),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                  onPressed: () async {
                    await updateUserSaved(widget.contentID);
                    refreshSaved();
                  },
                  icon: Icon(
                    Icons.bookmark,
                    color: awSaved.contains(widget.contentID)
                        ? Colors.lightGreenAccent
                        : Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class CoinsWidget extends StatefulWidget {
  const CoinsWidget({super.key});

  @override
  State<CoinsWidget> createState() => _CoinsWidgetState();
}

class _CoinsWidgetState extends State<CoinsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 39, 39, 39),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/coin.png',
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(awCoins.toString(),
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class PostListItem extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final Function onPressed;
  const PostListItem(
      {super.key,
      required this.title,
      required this.description,
      required this.image,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 39, 39, 39),
            border: Border.all(color: Color.fromARGB(255, 207, 207, 207)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                // Use ClipRRect to clip the image
                borderRadius:
                    BorderRadius.circular(20), // Adjust the radius as needed
                child: Image.asset(
                  image,
                  height: 100,
                  fit: BoxFit.cover, // Ensure the image covers the area
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                          fontSize: 15,
                          color: const Color.fromARGB(255, 192, 192, 192)),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}

class HeaderBack extends StatelessWidget {
  final String title;
  final Function onPressed;
  const HeaderBack({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                onPressed();
              },
              icon: Icon(Icons.arrow_back, color: Colors.white)),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

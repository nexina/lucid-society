import 'package:appwrite/models.dart';
import 'package:appwrite/appwrite.dart';
import 'package:lucid_society/class.dart';

import 'dart:typed_data';
import 'data.dart';

late Account account;

String awEmail = '';
String awName = '';
String awID = '';
int awCoins = 0;
String awBio = '';
List<String> awContents = [];
List<String> awSaved = [];

RealtimeSubscription? subscription;
late Databases databases;

String databaseID = '67f6a9ee0001ca90a34f';
String usersCollectionID = '67f6aafc0013f429cf2a';
String contentsCollectionID = '67f78e5d0022dd3fd1df';
String postsCollectionID = '67f6ab06001d226bfcfc';

late Storage storage;
String filesBucketID = "67f78577000799c2ba8c";

Future<void> initAppwriteClient() async {
  final Client client = Client()
      .setEndpoint("https://fra.cloud.appwrite.io/v1")
      .setProject('67f4b8f1000fd634311d');

  account = Account(client);
  databases = Databases(client);
  storage = Storage(client);
}

Future<bool> isLoggedIn() async {
  try {
    await account.get(); // Check if the user is logged in
    return true;
  } catch (e) {
    return false;
  }
}

Future<void> setDataFromAuthtoDB() async {
  await account.get().then((user) {
    awID = user.$id.toString();
    awEmail = user.email;
    awName = user.name;
  });
}

Future<void> setValues() async {
  await account.get().then((user) {
    awID = user.$id.toString();
  });

  DocumentList userData = await getUserDatabase();
  if (userData.documents.isNotEmpty) {
    awCoins = userData.documents[0].data['coins'];
    awBio = userData.documents[0].data['bio'];
    awContents = List<String>.from(userData.documents[0].data['contents']);
    awSaved = List<String>.from(userData.documents[0].data['saved']);
  }

  closeSubscription();
}

Future<bool> signOut() async {
  try {
    await account.deleteSession(sessionId: "current");
    return true;
  } catch (error) {
    return false;
  }
}

void closeSubscription() {
  subscription?.close();
}

Future<DocumentList> getUserDatabase() async {
  try {
    final userData = await databases.listDocuments(
      databaseId: databaseID,
      collectionId: usersCollectionID,
      queries: [
        Query.equal('id', awID),
      ],
    );
    closeSubscription();

    return userData;
  } catch (error) {
    if (error == '400') {
      return DocumentList(documents: [], total: 0);
    }
  }
  return DocumentList(documents: [], total: 0);
}

Future<bool> createUserData(String email, String name, String dob) async {
  try {
    await databases.createDocument(
      databaseId: databaseID,
      collectionId: usersCollectionID,
      documentId: awID, // Use the same ID for the document
      data: {
        'id': awID,
        'email': email,
        'name': name,
        'dob': dob,
        'coins': 100,
        'contents': [],
        'saved': [],
        'bio': '',
        'created_at': DateTime.now().toIso8601String(),
      },
    );

    await setValues();
    print("User data created successfully");
    closeSubscription();
    return true; // Return true if the user is created successfully
  } catch (error) {
    print("Error creating user data: $error");
    print(awID);
    return false; // Return false if there was an error
  }
}

Future<DocumentList> getContentsFromDatabase() async {
  try {
    final contents = await databases.listDocuments(
      databaseId: databaseID,
      collectionId: contentsCollectionID,
      queries: [],
    );
    closeSubscription();

    return contents;
  } catch (error) {
    if (error == '400') {
      return DocumentList(documents: [], total: 0);
    }
  }
  return DocumentList(documents: [], total: 0);
}

Future<DocumentList> getContentsFromMyContents() async {
  try {
    final contents = await databases.listDocuments(
      databaseId: databaseID,
      collectionId: contentsCollectionID,
      queries: [
        Query.equal(r'$id', awContents),
      ],
    );
    closeSubscription();

    return contents;
  } catch (error) {
    if (error == '400') {
      return DocumentList(documents: [], total: 0);
    }
  }
  return DocumentList(documents: [], total: 0);
}

Future<DocumentList> getContentsFromMySaved() async {
  try {
    final contents = await databases.listDocuments(
      databaseId: databaseID,
      collectionId: contentsCollectionID,
      queries: [
        Query.equal(r'$id', awSaved),
      ],
    );
    closeSubscription();

    return contents;
  } catch (error) {
    if (error == '400') {
      return DocumentList(documents: [], total: 0);
    }
  }
  return DocumentList(documents: [], total: 0);
}

Future<String> uploadGeneratedImage(String filepath) async {
  try {
    final uniqueId = ID.unique(); // Generate a unique ID
    final file = await storage.createFile(
      bucketId: filesBucketID,
      fileId: uniqueId, // Use the unique ID for fileId
      file: InputFile.fromPath(
          path: filepath,
          filename: uniqueId.toString()), // Use the same unique ID for filename
    );
    closeSubscription();
    return file.$id;
  } catch (error) {
    print("Error uploading image: $error");
    throw error;
  }
}

Future<bool> addPosts(String prompt, String desc, String fileID,
    String userName, bool showPrompt) async {
  try {
    String timestamp = DateTime.now().toIso8601String();
    final document = await databases.createDocument(
      databaseId: databaseID,
      collectionId: postsCollectionID,
      documentId: ID.unique(),
      data: {
        "showPrompt": showPrompt,
        "prompt": prompt,
        "description": desc,
        "imageID": fileID,
        "userID": awID,
        "userName": userName,
        "likes": [],
        "timestamp": timestamp,
      },
    );

    final contentID = await addContent(document.$id, "post", timestamp);
    updateUserContent(contentID);
    closeSubscription();
    return true;
  } catch (error) {
    print("Error creating post: $error");
    return false;
  }
}

Future<String> addContent(
    String documentID, String type, String timestamp) async {
  try {
    final content = await databases.createDocument(
      databaseId: databaseID,
      collectionId: contentsCollectionID,
      documentId: ID.unique(),
      data: {
        "documentID": documentID,
        "type": type,
        "timestamp": timestamp,
      },
    );
    closeSubscription();
    return content.$id;
  } catch (error) {
    print("Error creating content: $error");
    return "";
  }
}

Future<Post> getPostContentData(String contentDocumentID) async {
  List result = [];

  DocumentList postDocument = await databases.listDocuments(
    databaseId: databaseID,
    collectionId: postsCollectionID,
    queries: [
      Query.equal(
          r'$id', contentDocumentID), // Adjust the field name as necessary
    ],
  );

  Post p = Post(
    id: postDocument.documents[0].$id,
    username: postDocument.documents[0].data['userName'],
    description: postDocument.documents[0].data['description'],
    image: await getPostImage(postDocument.documents[0].data['imageID']),
    showPrompt: postDocument.documents[0].data['showPrompt'],
    likes: postDocument.documents[0].data['likes'],
    timestamp: postDocument.documents[0].data['timestamp'],
    prompt: postDocument.documents[0].data['prompt'],
  );

  return p; // Return the list of posts
}

Future<Uint8List> getPostImage(String fileID) async {
  // Get the file view URL
  final file = await storage.getFileView(
    bucketId: filesBucketID,
    fileId: fileID,
  );

  return file;
}

void updateUserContent(String contentID) async {
  awContents.add(contentID);
  try {
    final response = await databases.updateDocument(
      databaseId: databaseID,
      collectionId: usersCollectionID,
      documentId: awID,
      data: {'contents': awContents},
    );
    print('Document updated successfully: ${response.toMap()}');
  } catch (error) {
    print('Error updating document: $error');
  }
}

Future<void> updateUserSaved(String contentID) async {
  if (awSaved.contains(contentID)) {
    awSaved.remove(contentID);
  } else {
    awSaved.add(contentID);
  }

  try {
    final response = await databases.updateDocument(
      databaseId: databaseID,
      collectionId: usersCollectionID,
      documentId: awID,
      data: {'saved': awSaved},
    );
    print('Document updated successfully: ${response.toMap()}');
  } catch (error) {
    print('Error updating document: $error');
  }
}

Future<bool> updatePostReacted(Post p) async {
  if (p.likes.contains(awID)) {
    p.likes.remove(awID);
  } else {
    p.likes.add(awID);
  }
  try {
    final response = await databases.updateDocument(
      databaseId: databaseID,
      collectionId: postsCollectionID,
      documentId: p.id,
      data: {'likes': p.likes},
    );
    print('Document updated successfully: ${response.toMap()}');
    return true;
  } catch (error) {
    print('Error updating document: $error');
    return false;
  }
}

Future<void> updateUserBio(newBio) async {
  awBio = newBio;
  try {
    final response = await databases.updateDocument(
      databaseId: databaseID,
      collectionId: usersCollectionID,
      documentId: awID,
      data: {'bio': awBio},
    );
    print('Document updated successfully: ${response.toMap()}');
  } catch (error) {
    print('Error updating document: $error');
  }
}

void reduceCoin(int amount) async {
  awCoins -= amount;
  try {
    final response = await databases.updateDocument(
      databaseId: databaseID,
      collectionId: usersCollectionID,
      documentId: awID,
      data: {'coins': awCoins},
    );
    print('Document updated successfully: ${response.toMap()}');
  } catch (error) {
    print('Error updating document: $error');
  }
}

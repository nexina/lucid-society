import 'dart:typed_data';

class Post {
  final String id;
  final String username;
  final String description;
  final Uint8List image;
  final bool showPrompt;
  final List likes;
  final String timestamp;
  String? prompt;

  Post({
    required this.id,
    required this.username,
    required this.description,
    required this.image,
    required this.showPrompt,
    required this.likes,
    required this.timestamp,
    this.prompt,
  });

  factory Post.fromMap(String id, Map<Object?, Object?> data) {
    return Post(
      id: id,
      username: data['username'] as String,
      description: data['description'] as String,
      image: data['image'] as Uint8List,
      showPrompt: data['showPrompt'] as bool,
      likes: data['likes'] as List,
      timestamp: data['timestamp'] as String,
      prompt: data['prompt'] as String?,
    );
  }
}

class Post {
  final String name;
  final String message;
  final int timestamp;
  final String key;

  Post(
    this.key,
    this.name,
    this.message,
    this.timestamp,
  );

  factory Post.fromRealTimeDatabase(
      {required Map<dynamic, dynamic> jsonPost, required String key}) {
    return Post(
        key, jsonPost['name'], jsonPost['message'], jsonPost['timestamp']);
  }
}

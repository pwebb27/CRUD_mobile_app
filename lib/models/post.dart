class Post {
  final String name;
  final String message;
  final DateTime timestamp;

  Post(this.name, this.message, this.timestamp);

  factory Post.fromRealTimeDatabase(Map<dynamic, dynamic> jsonPost) {
    return Post(jsonPost['name'], jsonPost['message'],
        DateTime.fromMillisecondsSinceEpoch(jsonPost['timestamp']));
  }
}

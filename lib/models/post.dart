class Post {
  final String name;
  final String message;
  final int timestamp;

  Post(this.name, this.message, this.timestamp);

  factory Post.fromRealTimeDatabase(Map<dynamic, dynamic> jsonPost) {
    return Post(jsonPost['name'], jsonPost['message'],
       jsonPost['timestamp']);
  }
}

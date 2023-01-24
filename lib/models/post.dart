class Post {
  final String name;
  final String message;
  final DateTime postedDateTime;

  Post(this.name, this.message, this.postedDateTime);

  factory Post.fromRealTimeDatabase(Map<dynamic, dynamic> data) {
    return Post(data['name'], data['message'], DateTime.parse(data['postedDateTime']));
  }
}

class Post {
  final String name;
  final String message;

  Post(this.name, this.message);

  factory Post.fromRealTimeDatabase(Map<dynamic, dynamic> data) {
    return Post(data['name'], data['message']);
  }
}

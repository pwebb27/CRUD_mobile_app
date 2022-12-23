class Post {
  final String name;
  final String message;

  Post.fromRealTimeDatabase(Map<dynamic, dynamic> data)
      : name = data['name'],
        message = data['message'];
}

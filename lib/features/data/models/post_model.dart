import 'package:crud_mobile_app/features/domain/entities/post.dart';

class PostModel extends Post {
  final String name;
  final String message;
  final int timestamp;
  final String key;

  const PostModel({
    required this.key,
    required this.name,
    required this.message,
    required this.timestamp,
  }) : super(key: key, name: key, message: message, timestamp: timestamp);

  factory PostModel.fromRealTimeDatabase(
      {required Map<dynamic, dynamic> jsonPost, required String key}) {
    return PostModel(
        key: key,
        name: jsonPost['name'],
        message: jsonPost['message'],
        timestamp: jsonPost['timestamp']);
  }
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'message': message,
      'timestamp': timestamp
    };
  }
}

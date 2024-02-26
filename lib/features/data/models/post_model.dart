import 'package:crud_mobile_app/features/domain/entities/post.dart';

class PostModel extends Post {
  final String name;
  final String message;
  final int timestamp;
  final String key;

  const PostModel(
    this.key,
    this.name,
    this.message,
    this.timestamp,
  ) : super(key: key, name: key, message: message, timestamp: timestamp);

  factory PostModel.fromRealTimeDatabase(
      {required Map<dynamic, dynamic> jsonPost, required String key}) {
    return PostModel(
        key, jsonPost['name'], jsonPost['message'], jsonPost['timestamp']);
  }
}

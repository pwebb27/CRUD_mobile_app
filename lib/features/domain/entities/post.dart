import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String name;
  final String message;
  final int timestamp;
  final String key;

  const Post({
    required this.key,
    required this.name,
    required this.message,
    required this.timestamp,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

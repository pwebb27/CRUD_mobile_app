import 'package:crud_mobile_app/features/domain/entities/post.dart';

abstract class PostRemoteDataSource {
  Future<List<Post>> getPosts(int? amountRequested);
}

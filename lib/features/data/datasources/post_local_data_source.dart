import 'package:crud_mobile_app/features/data/models/post_model.dart';
import 'package:crud_mobile_app/features/domain/entities/post.dart';

abstract class PostLocalDataSource {
  Future<List<Post>> getLastPosts();
  Future<void> cachePosts(List<PostModel> postsToCache);
}

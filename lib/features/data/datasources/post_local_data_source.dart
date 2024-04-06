import 'package:crud_mobile_app/features/data/models/post_model.dart';
import 'package:crud_mobile_app/features/domain/entities/post.dart';
import 'package:crud_mobile_app/test/features/posts/data/datasources/posts_local_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getLastPosts();

  Future<void> cachePosts(List<PostModel> postsToCache);
}

class PostsLocalDataSourceImp extends PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostsLocalDataSourceImp({required this.sharedPreferences});

  @override
  Future<void> cachePosts(List<PostModel> postsToCache) {
    // TODO: implement cachePosts
    throw UnimplementedError();
  }

  @override
  Future<List<PostModel>> getLastPosts() {
    // TODO: implement getLastPosts
    throw UnimplementedError();
  }
}

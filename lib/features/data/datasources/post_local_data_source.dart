import 'dart:convert';

import 'package:crud_mobile_app/features/data/models/post_model.dart';
import 'package:crud_mobile_app/features/domain/entities/post.dart';
import 'package:crud_mobile_app/test/features/posts/data/datasources/posts_local_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getLastPosts();

  Future<void> cachePosts(List<PostModel> postsToCache);
}

const CACHED_POSTS = 'CACHED_POSTS';

class PostsLocalDataSourceImp extends PostLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostsLocalDataSourceImp({required this.sharedPreferences});

  @override
  Future<void> cachePosts(List<PostModel> postsToCache) {
    throw UnimplementedError();
  }

  @override
  Future<List<PostModel>> getLastPosts() {
    final jsonString = sharedPreferences.getString(CACHED_POSTS);
    List<dynamic> jsonPosts = json.decode(jsonString as String);
    List<PostModel> postModels = [];
    for (var post in jsonPosts) {
      postModels.add((PostModel.fromRealTimeDatabase(
          jsonPost: json.decode(post), key: '12345')));
    }
    return Future.value(postModels);
  }
}

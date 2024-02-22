// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:firebase_database/firebase_database.dart';

// Project imports:
import 'package:crud_mobile_app/features/data/models/lorem_ipsum_generator.dart';
import 'package:crud_mobile_app/features/data/models/post_model.dart';

/// Provides database logic for posts from Realtime Database
class PostsStreamProvider extends ChangeNotifier {
  final _crudDatabaseReference =
      FirebaseDatabase.instance.ref().child('posts').orderByChild('timestamp');

  List<Post> _posts = [];
  static const int _postsPerRequest = 10;

  bool _isRequesting = false;

  List<Post>? get posts => _posts;
  late StreamSubscription<DatabaseEvent> _streamSubscription;
  int counter = 0;

  PostsStreamProvider() {
    _streamSubscription = _crudDatabaseReference
        .limitToLast(_postsPerRequest)
        .onChildAdded
        .listen(((databaseEvent) {
      final Map<dynamic, dynamic> postsMap =
          databaseEvent.snapshot.value as dynamic;
      final String? postKey = databaseEvent.snapshot.key;
      if (counter != _postsPerRequest) {
        _posts
            .add(Post.fromRealTimeDatabase(jsonPost: postsMap, key: postKey!));
        ++counter;
        if (counter == _postsPerRequest) {
          _posts = _posts.reversed.toList();
        }
      } else {
        _posts.insert(
            0, Post.fromRealTimeDatabase(jsonPost: postsMap, key: postKey!));
      }
      notifyListeners();
    }));
  }

  void getAdditionalPosts() async {
    if (!_isRequesting) {
      DatabaseEvent databaseEvent;
      _isRequesting = true;
      Post lastPostLoaded = _posts[posts!.length - 1];
      databaseEvent = await _crudDatabaseReference
          .endBefore(lastPostLoaded.timestamp, key: lastPostLoaded.key)
          .limitToLast(_postsPerRequest)
          .once();
      final Map<dynamic, dynamic> postsMap =
          databaseEvent.snapshot.value as dynamic;
      List<Post> newPosts = postsMap.entries
          .map((entry) =>
              Post.fromRealTimeDatabase(jsonPost: entry.value, key: entry.key))
          .toList();
      newPosts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      _posts.addAll(newPosts);
      notifyListeners();
      _isRequesting = false;
    }
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  void populateDatabaseWithPosts() {
    final DatabaseReference crudDatabaseReference =
        FirebaseDatabase.instance.ref().child('posts');
    for (int i = 0; i < 50; i++) {
      crudDatabaseReference.push().set({
        'name': LoremIpsumGenerator().generateLoremIpsumName(),
        'message': LoremIpsumGenerator().generateLoremIpsumMessage(),
        'timestamp': i
      });
    }
  }
}

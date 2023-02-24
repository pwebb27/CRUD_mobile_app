import 'dart:async';
import 'dart:math';
import 'package:crud_mobile_app/models/post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_lorem/flutter_lorem.dart';

///Provides database logic for posts from Realtime Database
class PostsStreamProvider extends ChangeNotifier {
  final _crudDatabaseReference =
      FirebaseDatabase.instance.ref().child('posts').orderByChild('timestamp');

  final List<Post> _posts = [];
  int firstPostsLimit = 25;

  bool _isRequesting = false;
  bool _isInitialDataLoaded = false;

  List<Post>? get posts => _posts;
  late StreamSubscription<DatabaseEvent> _streamSubscription;
  int counter = 0;

  PostsStreamProvider() {
    _streamSubscription = _crudDatabaseReference
        .limitToLast(firstPostsLimit)
        .onChildAdded
        .listen(((databaseEvent) {
      final Map<dynamic, dynamic> postsMap =
          databaseEvent.snapshot.value as dynamic;
      if (!_isInitialDataLoaded) {
        ++counter;
        _posts.add(Post.fromRealTimeDatabase(postsMap));
        notifyListeners();
        if (counter == firstPostsLimit) _isInitialDataLoaded = true;
      } else {
        _posts.insert(0, Post.fromRealTimeDatabase(postsMap));
      }
      ;
      notifyListeners();
    }));
  }

  void getAdditionalPosts() async {
    if (!_isRequesting) {
      DatabaseEvent databaseEvent;
      _isRequesting = true;
      if (_posts == null) {
        databaseEvent = await _crudDatabaseReference.limitToLast(25).once();
      } else {
        databaseEvent =
            await _crudDatabaseReference.endBefore(_posts[0].timestamp).limitToLast(25).once();
      }
      final Map<dynamic, dynamic> postsMap =
          databaseEvent.snapshot.value as dynamic;
      for(Map<dynamic,dynamic> jsonPost in postsMap.values){
         _posts
            .add(Post.fromRealTimeDatabase(jsonPost));
      }notifyListeners();
      _isRequesting = false;
    }
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  // void loadDataIntoDatabase() {
  //   final DatabaseReference crudDatabaseReference =
  //       FirebaseDatabase.instance.ref().child('posts');
  //   for (int i = 0; i < 500; i++) {
  //     crudDatabaseReference.push().set({
  //       'name': lorem(words: 1),
  //       'message': lorem(paragraphs: 1),
  //       'timestamp': Random().nextInt(1000000) + 100000000
  //     });
  //   }
  // }
}

import 'dart:async';
import 'package:crud_mobile_app/models/post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

///Provides database logic for posts from Realtime Database
class PostsStreamProvider extends ChangeNotifier {
  final _crudDatabaseReference = FirebaseDatabase.instance.ref().child('posts');
  List<Post>? _posts;

  List<Post>? get posts => _posts;
  late StreamSubscription<DatabaseEvent> _streamSubscription;

  PostsStreamProvider() {
    _listentoPosts();
  }

  _listentoPosts() {
    _streamSubscription = _crudDatabaseReference.onValue.listen(((databaseEvent) {
      final Map<dynamic, dynamic> postsMap = databaseEvent.snapshot.value as dynamic;
      _posts = postsMap.values.map((jsonPost) {
        return Post.fromRealTimeDatabase(jsonPost as Map<dynamic, dynamic>);
      }).toList();
      notifyListeners();
    }));
    
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}

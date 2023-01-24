import 'package:crud_mobile_app/models/post.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ViewDataScreen extends StatefulWidget {
  const ViewDataScreen({super.key});

  @override
  State<ViewDataScreen> createState() => _ViewDataScreenState();
}

class _ViewDataScreenState extends State<ViewDataScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _crudDatabaseReference =
      FirebaseDatabase.instance.ref().child('posts');
  late List<Post> _posts;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: StreamBuilder(
          stream: _crudDatabaseReference.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              final Map<dynamic, dynamic> postsMap =
                  snapshot.data!.snapshot.value as dynamic;
              _posts = [];
              if (postsMap == null) {
                return const _NoPostsWidget();
              }
              postsMap.forEach((key, value) {
                _posts.add(
                    Post.fromRealTimeDatabase(value as Map<dynamic, dynamic>));
              });
            }
            return ListView.separated(
                separatorBuilder: ((context, index) =>
                    Divider(color: Colors.grey.shade400)),
                itemCount: _posts.length,
                itemBuilder: (context, index) => _PostTile(_posts[index]));
          }),
    ));
  }

  @override
  void deactivate() {
    super.deactivate();
  }
}

class _NoPostsWidget extends StatelessWidget {
  const _NoPostsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.markunread_mailbox_outlined,
              size: 150, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Text('No posts to display',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400))
        ],
      ),
    );
  }
}

class _PostTile extends StatelessWidget {
  const _PostTile(this.post);

  final Post post;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  post.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                post.message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
}

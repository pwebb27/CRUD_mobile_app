// Flutter imports:
import 'package:crud_mobile_app/features/domain/entities/post.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:crud_mobile_app/features/data/models/post_model.dart';
import 'package:crud_mobile_app/presentation/providers/ViewDataScreenProviders/FloatingActionButtonProvider.dart';
import 'package:crud_mobile_app/presentation/providers/posts_stream_provider.dart';

class ViewDataScreen extends StatefulWidget {
  const ViewDataScreen({super.key});

  @override
  State<ViewDataScreen> createState() => _ViewDataScreenState();
}

class _ViewDataScreenState extends State<ViewDataScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        context.read<PostsStreamProvider>().getAdditionalPosts();
      }
      if (_scrollController.offset >
          MediaQuery.of(context).size.height -
              Scaffold.of(context).appBarMaxHeight!.toDouble()) {
        if (context.read<FloatingActionButtonProvider>().isVisible == false) {
          context.read<FloatingActionButtonProvider>().isVisible = true;
        }
      } else {
        if (context.read<FloatingActionButtonProvider>().isVisible == true) {
          context.read<FloatingActionButtonProvider>().isVisible = false;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        floatingActionButton: Visibility(
          visible: context.watch<FloatingActionButtonProvider>().isVisible,
          child: FloatingActionButton(
              mini: true,
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                _scrollController.jumpTo(0);
              },
              child: const Icon(
                Icons.arrow_drop_down,
                size: 35,
                color: Colors.white,
              )),
        ),
        body: context.watch<PostsStreamProvider>().posts == null
            ? const Center(child: CircularProgressIndicator())
            : context.watch<PostsStreamProvider>().posts!.isEmpty
                ? const _NoPostsWidget()
                : Scrollbar(
                    controller: _scrollController,
                    thickness: 5,
                    thumbVisibility: true,
                    child: ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        itemCount:
                            context.watch<PostsStreamProvider>().posts!.length,
                        itemBuilder: (_, index) => _PostTile(context
                            .watch<PostsStreamProvider>()
                            .posts![index])),
                  ));
  }
}

class _NoPostsWidget extends StatelessWidget {
  const _NoPostsWidget();

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
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    post.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: .1, color: Colors.grey.shade500),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 1,
                        blurRadius: 15,
                        offset: const Offset(3, 2))
                  ],
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  post.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4),
              child: Text(
                DateFormat('MM/dd/yy').add_jm().format(
                    DateTime.fromMillisecondsSinceEpoch(post.timestamp)),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 9.5),
              ),
            )
          ],
        ),
      );
}

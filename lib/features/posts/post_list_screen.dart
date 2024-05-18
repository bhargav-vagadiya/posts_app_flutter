import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:posts_app/features/posts/models/post.dart';
import 'package:posts_app/features/posts/post_screen.dart';
import 'package:posts_app/features/posts/provider/post_provider.dart';
import 'package:posts_app/features/posts/widgets/post_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  List<PostModel> mTimerPostList = [];
  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        // here timer countdown will be started for each added post.
        // post will be added in mTimerPostList when user taps on timer icon.
        for (var element in mTimerPostList) {
          if (element.timer > 0) {
            element
              ..timer = element.timer - 1
              ..save();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PostAppBar(title: "Posts"),
      body: FutureBuilder<void>(
          future: context.read<PostProvider>().fetchAllPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ValueListenableBuilder(
                  valueListenable: Hive.box<PostModel>('posts').listenable(),
                  builder: (context, box, snapshot) {
                    return box.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: VisibilityDetector(
                                key: ValueKey(box.values.elementAt(index).id),
                                onVisibilityChanged: (visibilityInfo) {
                                  pausePlayTimerOnWidgetHideShow(
                                      visibilityInfo, box, index);
                                },
                                child: ListTile(
                                  title: Text(
                                    box.values.elementAt(index).title ?? "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      box.values.elementAt(index).body ?? ""),
                                  tileColor: box.values.elementAt(index).isRead
                                      ? Colors.white
                                      : Colors.yellow.withOpacity(0.3),
                                  onTap: () async {
                                    await markAsReadAndPausePlayTimer(
                                        box, index, context);
                                  },
                                  trailing: IconButton(
                                      onPressed: () {
                                        startTimer(box, index);
                                      },
                                      icon: box.values.elementAt(index).timer >
                                              0
                                          ? Text(box.values
                                              .elementAt(index)
                                              .timer
                                              .toString())
                                          : const Icon(Icons.timer_outlined)),
                                ),
                              ),
                            ),
                            itemCount: box.values.length,
                          )
                        : const Center(child: Text("No Posts"));
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  void startTimer(Box<PostModel> box, int index) {
    // set 30 seconds for timer
    box.values.elementAt(index)
      ..timer = 30
      ..save();

    // starts the timer  
    var result = mTimerPostList.firstWhereOrNull(
        (element) => element.id == box.values.elementAt(index).id);
    if (result == null) {
      mTimerPostList.add(box.values.elementAt(index));
    }
  }

  Future<void> markAsReadAndPausePlayTimer(
      Box<PostModel> box, int index, BuildContext context) async {
    // mark as read
    box.values.elementAt(index)
      ..isRead = true
      ..save();

    // pause timer
    var result = mTimerPostList.firstWhereOrNull(
        (element) => element.id == box.values.elementAt(index).id);
    if (result != null) {
      mTimerPostList.removeWhere(
        (element) => element.id == box.values.elementAt(index).id,
      );
    }

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PostScreen(mPostId: box.values.elementAt(index).id!)));

    //resume timer
    mTimerPostList.add(box.values.elementAt(index));
  }

  void pausePlayTimerOnWidgetHideShow(
      VisibilityInfo visibilityInfo, Box<PostModel> box, int index) {
    // post is visible or not?
    var isVisible = visibilityInfo.visibleFraction > 0;

    var result = mTimerPostList.firstWhereOrNull(
        (element) => element.id == box.values.elementAt(index).id);
    // post is post is not visible so pause the timer
    if (result != null && isVisible == false) {
      mTimerPostList.removeWhere(
        (element) => element.id == box.values.elementAt(index).id,
      );
    }
    // post is visible so resume the timer
    else if (result == null && isVisible) {
      mTimerPostList.add(box.values.elementAt(index));
    }
  }
}

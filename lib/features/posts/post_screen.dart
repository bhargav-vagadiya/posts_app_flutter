import 'package:flutter/material.dart';
import 'package:posts_app/features/posts/models/post.dart';
import 'package:posts_app/features/posts/provider/post_provider.dart';
import 'package:posts_app/features/posts/widgets/post_app_bar.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key, required this.mPostId});

  /// specific post id
  final int mPostId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PostAppBar(title: "Post Data"),
      body: FutureBuilder<PostModel?>(
          future: context.read<PostProvider>().fetchPost(mPostId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Text(
                        snapshot.data?.title ?? "",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Text(
                        snapshot.data?.body ?? "",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return const Center(
                child: Text("Sorry, Something went wrong while fetching post"),
              );
            }
          }),
    );
  }
}

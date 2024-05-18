import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:posts_app/features/posts/models/post.dart';

class PostProvider extends ChangeNotifier {
  Future<void> fetchAllPosts() async {
    try {
      Box<PostModel> postBox = await Hive.openBox<PostModel>("posts");
      if (postBox.isEmpty) {
        var response =
            await Dio().get("https://jsonplaceholder.typicode.com/posts");
        if (response.statusCode == 200) {
          for (var element in postModelFromJson(jsonEncode(response.data))) {
            await postBox.put(element.id, element);
          }
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<PostModel?> fetchPost(int pId) async {
    try {
      var response =
          await Dio().get("https://jsonplaceholder.typicode.com/posts/$pId");
      if (response.statusCode == 200) {
        return PostModel.fromJson(response.data);
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}

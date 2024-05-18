import 'dart:convert';

import 'package:hive/hive.dart';
part 'post.g.dart';

List<PostModel> postModelFromJson(String str) =>
    List<PostModel>.from(json.decode(str).map((x) => PostModel.fromJson(x)));

String postModelToJson(List<PostModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: 0)
class PostModel extends HiveObject {
  @HiveField(0)
  final int? userId;
  @HiveField(1)
  final int? id;
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final String? body;
  @HiveField(4)
  bool isRead;
  @HiveField(5)
  int timer;

  PostModel(
      {this.userId,
      this.id,
      this.title,
      this.body,
      this.isRead = false,
      this.timer = 0});

  PostModel copyWith({
    int? userId,
    int? id,
    String? title,
    String? body,
  }) =>
      PostModel(
        userId: userId ?? this.userId,
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
      );

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}

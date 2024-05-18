import 'package:hive_flutter/hive_flutter.dart';
import 'package:posts_app/features/posts/models/post.dart';
import 'package:posts_app/features/posts/post_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:posts_app/features/posts/provider/post_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PostModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => PostProvider())],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        home: const PostListScreen(),
      ),
    );
  }
}

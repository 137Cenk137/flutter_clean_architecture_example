import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/blog/domain/entities/blog.dart';

class BlogViewerPage extends StatefulWidget {
  static MaterialPageRoute route({required Blog blog}) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));
  final Blog blog;
  const BlogViewerPage({super.key, required this.blog});

  @override
  State<BlogViewerPage> createState() => _BlogViewerPageState();
}

class _BlogViewerPageState extends State<BlogViewerPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

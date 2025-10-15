import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/pages/create_blog_page.dart';

class BlogPage extends StatelessWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, CreateBlogPage.route());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const Center(child: Text('Blog Page')),
    );
  }
}

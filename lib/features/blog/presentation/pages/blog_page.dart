import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/common/widgets/loader.dart';
import 'package:flutter_clean_architecture/core/utils/show_snackbar.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/bloc/blog_event.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/bloc/blog_state.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/pages/create_blog_page.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/widgets/blog_cart.dart';
import 'package:flutter_clean_architecture/core/theme/app_pallete.dart';

class BlogPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const BlogPage());
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(FetchAllBlogsEvent());
  }

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
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
            return;
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogDisplaySuccess) {
            return ListView.builder(
              itemBuilder: (context, index) => BlogCart(
                blog: state.blogs[index],
                color: index % 2 == 0
                    ? AppPallete.gradient2
                    : AppPallete.gradient1,
                onTap: () {
                  Navigator.push(
                    context,
                    BlogViewerPage.route(state.blogs[index]),
                  );
                },
              ),
              itemCount: state.blogs.length,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

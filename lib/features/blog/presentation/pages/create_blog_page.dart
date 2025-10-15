import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/core/common/app_user/appuser_cubit.dart';
import 'package:flutter_clean_architecture/core/common/app_user/appuser_state.dart';
import 'package:flutter_clean_architecture/core/common/widgets/loader.dart';
import 'package:flutter_clean_architecture/core/theme/app_pallete.dart';
import 'package:flutter_clean_architecture/core/utils/pick_image.dart';
import 'package:flutter_clean_architecture/core/utils/show_snackbar.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/bloc/blog_event.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/bloc/blog_state.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/widgets/blog_editor.dart';

class CreateBlogPage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const CreateBlogPage());
  const CreateBlogPage({super.key});

  @override
  State<CreateBlogPage> createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late List<String> selectedTags = [];
  File? _image;

  void _pickImage() async {
    final image = await pickImage();
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _uploadBlog() {
    if (_formKey.currentState!.validate() &&
        selectedTags.isNotEmpty &&
        _image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
        BlogUploadEvent(
          image: _image!,
          title: _titleController.text.trim(),
          content: _descriptionController.text.trim(),
          posterId: posterId,
          topics: selectedTags,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Blog'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(onPressed: _uploadBlog, icon: const Icon(Icons.check)),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
            return;
          } else if (state is BlogSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
            return;
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _image != null
                        ? GestureDetector(
                            onTap: _pickImage,
                            child: SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(_image!, fit: BoxFit.cover),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: _pickImage,
                            child: DottedBorder(
                              dashPattern: [10, 10],
                              strokeWidth: 1,
                              radius: Radius.circular(10),
                              borderType: BorderType.RRect,
                              padding: EdgeInsets.all(16),
                              strokeCap: StrokeCap.round,
                              color: Colors.grey,
                              child: SizedBox(
                                width: double.infinity,
                                height: 100,
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.file_open,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Add Image',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Or Drag and Drop your image here',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            [
                                  'technology',
                                  'science',
                                  'engineering',
                                  'business',
                                  'marketing',
                                  'finance',
                                  'education',
                                  'sports',
                                  'entertainment',
                                  'other',
                                ]
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (selectedTags.contains(e)) {
                                            selectedTags.remove(e);
                                          } else {
                                            selectedTags.add(e);
                                          }
                                        });
                                      },
                                      child: Chip(
                                        label: Text(e),
                                        side: BorderSide(
                                          color: selectedTags.contains(e)
                                              ? AppPallete.gradient2
                                              : AppPallete.transparentColor,
                                        ),
                                        backgroundColor:
                                            selectedTags.contains(e)
                                            ? AppPallete.gradient2
                                            : AppPallete.backgroundColor,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                    SizedBox(height: 16),
                    BlogEditor(controller: _titleController, hintText: 'Title'),
                    SizedBox(height: 16),
                    BlogEditor(
                      controller: _descriptionController,
                      hintText: 'Description',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_clean_architecture/core/theme/app_pallete.dart';
import 'package:flutter_clean_architecture/core/utils/pick_image.dart';
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
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                                  backgroundColor: selectedTags.contains(e)
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
  }
}

import 'dart:io';

import 'package:flutter_clean_architecture/core/utils/handle_remote_call.dart';
import 'package:flutter_clean_architecture/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> createBlog(BlogModel blog);
  Future<String> uploadImage({required File image, required String blogId});
  Future<List<BlogModel>> getByUserIDblogs();
  Future<BlogModel> getBlogById(String id);
  Future<BlogModel> updateBlog(String id, BlogModel blog);
  Future<void> deleteBlog(String id);
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabase;
  BlogRemoteDataSourceImpl({required this.supabase});

  @override
  Future<BlogModel> createBlog(BlogModel blog) async {
    return await handleRemoteCallException(() async {
      final response = await supabase
          .from('blogs')
          .insert(blog.toJson())
          .single();
      return BlogModel.fromJson(response);
    });
  }

  @override
  Future<String> uploadImage({
    required File image,
    required String blogId,
  }) async {
    return await handleRemoteCallException(() async {
      await supabase.storage.from('blog_images').upload(blogId, image);

      return supabase.storage
          .from('blog_images')
          .getPublicUrl(blogId)
          .toString();
    });
  }

  @override
  Future<List<BlogModel>> getByUserIDblogs() async {
    return await handleRemoteCallException(() async {
      final response = await supabase
          .from('blogs')
          .select('*')
          .eq('user_id', _userID);
      return response.map((e) => BlogModel.fromJson(e)).toList();
    });
  }

  @override
  Future<BlogModel> getBlogById(String id) async {
    return await handleRemoteCallException(() async {
      final response = await supabase
          .from('blogs')
          .select('*')
          .eq('id', id)
          .single();
      return BlogModel.fromJson(response);
    });
  }

  @override
  Future<BlogModel> updateBlog(String id, BlogModel blog) async {
    return await handleRemoteCallException(() async {
      final response = await supabase
          .from('blogs')
          .update(blog.toJson())
          .eq('id', id)
          .single();
      return BlogModel.fromJson(response);
    });
  }

  @override
  Future<void> deleteBlog(String id) async {
    await handleRemoteCallException(() async {
      await supabase.from('blogs').delete().eq('isd', id);
    });
  }

  String get _userID => supabase.auth.currentSession?.user.id ?? '';
}

import 'dart:io';

import 'package:flutter_clean_architecture/core/errors/failures.dart';
import 'package:flutter_clean_architecture/core/network/connection_checker.dart';
import 'package:flutter_clean_architecture/core/utils/handle_repository_call_failure.dart';
import 'package:flutter_clean_architecture/features/blog/data/data_sources/blog_local_data_source.dart';
import 'package:flutter_clean_architecture/features/blog/data/models/blog_model.dart';
import 'package:flutter_clean_architecture/features/blog/data/data_sources/blog_remote_datasources.dart';
import 'package:flutter_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:flutter_clean_architecture/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuidv7/uuidv7.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl({
    required this.blogRemoteDataSource,
    required this.blogLocalDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async => await handleRepositoryCallFailure(
    function: () async {
      final blogId = generateUuidV7String();
      final imageUrl = await blogRemoteDataSource.uploadImage(
        image: image,
        blogId: blogId,
      );
      BlogModel blogModel = BlogModel(
        id: blogId,
        poster_id: posterId,
        title: title,
        content: content,
        image_url: imageUrl,
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final blog = await blogRemoteDataSource.createBlog(blogModel);
      return blog;
    },

    noInternetConnectionFailureMapper: () async {
      if (!await connectionChecker.isConnected) {
        return Failure('No internet connection');
      }
      return Failure('An error occurred');
    },
  );

  @override
  Future<Either<Failure, Blog>> updateBlog(Blog blog) {
    // TODO: implement updateBlog
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Blog>> deleteBlog(Blog blog) {
    // TODO: implement deleteBlog
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Blog>>> getByUserIDblogs() async {
    return await handleRepositoryCallFailure(
      function: () async {
        if (!await connectionChecker.isConnected) {
          return blogLocalDataSource.loadBlogs();
        }
        final blogs = await blogRemoteDataSource.getByUserIDblogs();
        blogLocalDataSource.uploadLocalBlogs(blogs: blogs);
        return blogs;
      },
      noInternetConnectionFailureMapper: () async {
        if (!await connectionChecker.isConnected) {
          return Failure('No internet connection');
        }
        return Failure('An error occurred');
      },
    );
  }
}

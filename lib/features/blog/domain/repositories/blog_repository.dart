import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_clean_architecture/core/errors/failures.dart';
import 'package:flutter_clean_architecture/features/blog/domain/entities/blog.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<Failure, Blog>> updateBlog(Blog blog);
  Future<Either<Failure, Blog>> deleteBlog(Blog blog);
  Future<Either<Failure, List<Blog>>> getByUserIDblogs();
}

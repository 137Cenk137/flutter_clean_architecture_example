import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_clean_architecture/features/blog/domain/entities/blog.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogDisplaySuccess extends BlogState {
  final List<Blog> blogs;
  BlogDisplaySuccess({required this.blogs});
}

final class BlogUploadSuccess extends BlogState {
  final Blog blog;
  BlogUploadSuccess({required this.blog});
}

final class BlogFailure extends BlogState {
  final String error;
  BlogFailure({required this.error});
}

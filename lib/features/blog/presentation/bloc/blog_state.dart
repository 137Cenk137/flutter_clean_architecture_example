import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture/features/blog/domain/entities/blog.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogSuccess extends BlogState {
  final List<Blog> blogs;
  BlogSuccess({required this.blogs});
}

final class BlogFailure extends BlogState {
  final String error;
  BlogFailure({required this.error});
}

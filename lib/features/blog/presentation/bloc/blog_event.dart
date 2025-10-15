import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_clean_architecture/features/blog/domain/entities/blog.dart';

@immutable
sealed class BlogEvent {}

final class BlogUploadEvent extends BlogEvent {
  final File image;
  final String title;
  final String content;
  final String posterId;
  final List<String> topics;
  BlogUploadEvent({
    required this.image,
    required this.title,
    required this.content,
    required this.posterId,
    required this.topics,
  });
}

final class BlogUpdateEvent extends BlogEvent {
  final Blog blog;
  BlogUpdateEvent({required this.blog});
}

final class BlogDeleteEvent extends BlogEvent {
  final Blog blog;
  BlogDeleteEvent({required this.blog});
}

final class GetAllBlogsEvent extends BlogEvent {
  GetAllBlogsEvent();
}

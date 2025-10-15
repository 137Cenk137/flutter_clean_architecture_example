import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:flutter_clean_architecture/features/blog/domain/repositories/blog_repository.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/bloc/blog_event.dart';
import 'package:flutter_clean_architecture/features/blog/presentation/bloc/blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogRepository _blogRepository;
  BlogBloc({required BlogRepository blogRepository})
    : _blogRepository = blogRepository,
      super(BlogInitial()) {
    on<BlogEvent>((evet, emit) => emit(BlogLoading()));
    on<BlogUploadEvent>(_onBlogUploadEvent);
    on<BlogUpdateEvent>(_onBlogUpdateEvent);
    on<BlogDeleteEvent>(_onBlogDeleteEvent);
    on<GetAllBlogsEvent>(_onGetAllBlogsEvent);
  }

  void _onBlogUploadEvent(
    BlogUploadEvent event,
    Emitter<BlogState> emit,
  ) async {
    final response = await _blogRepository.uploadBlog(
      image: event.image,
      title: event.title,
      content: event.content,
      posterId: event.posterId,
      topics: event.topics,
    );
    response.fold(
      (l) => emit(BlogFailure(error: l.message.toString())),
      (r) => emit(BlogSuccess(blogs: [r])),
    );
  }

  void _onBlogUpdateEvent(
    BlogUpdateEvent event,
    Emitter<BlogState> emit,
  ) async {
    final response = await _blogRepository.updateBlog(event.blog);
    response.fold(
      (l) => emit(BlogFailure(error: l.message.toString())),
      (r) => emit(BlogSuccess(blogs: [r])),
    );
  }

  void _onBlogDeleteEvent(
    BlogDeleteEvent event,
    Emitter<BlogState> emit,
  ) async {
    final response = await _blogRepository.deleteBlog(event.blog);
    response.fold(
      (l) => emit(BlogFailure(error: l.message.toString())),
      (r) => emit(BlogSuccess(blogs: [r])),
    );
  }

  void _onGetAllBlogsEvent(
    GetAllBlogsEvent event,
    Emitter<BlogState> emit,
  ) async {
    final response = await _blogRepository.getByUserIDblogs();
    response.fold(
      (l) => emit(BlogFailure(error: l.message.toString())),
      (r) => emit(BlogSuccess(blogs: r.map((e) => e).toList())),
    );
  }
}

import 'package:flutter_clean_architecture/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.title,
    required super.content,
    required super.image_url,
    required super.poster_id,
    required super.topics,
    required super.updatedAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      image_url: json['image_url'] as String,
      poster_id: json['poster_id'] as String,
      topics: List<String>.from(json['topics'] ?? [] as List<String>),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': image_url,
      'poster_id': poster_id,
      'topics': topics,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

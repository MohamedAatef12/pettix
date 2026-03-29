import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

import '../../domain/entities/post_entity.dart';
import 'author_model.dart';
import 'comments_model.dart';
import 'likes_model.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.author,
    required super.comments,
    required super.likes,
    required super.content,
    required super.creationDate,
    super.modifyDate,
    required super.images,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: (json['id'] ?? 0) is int ? json['id'] ?? 0 : int.tryParse(json['id'].toString()) ?? 0,
      author: json['author'] != null
          ? AuthorModel.fromJson(json['author'] as Map<String, dynamic>)
          : const AuthorModel(
        id: 0,
        nameAr: '',
        nameEn: '',
        avatar: '',
        email: null,
        phone: null,
        genderId: null,
        genderName: null,
        contactTypeId: 4,
        statusId: 1,
        age: null,
      ),
      content: json['content']?.toString() ?? '',
      creationDate: json['creationDate']?.toString() ?? '',
      modifyDate: json['modifyDate']?.toString(),
      comments: (json['comments'] as List<dynamic>?)
          ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      likes: (json['likes'] as List<dynamic>?)
          ?.map((e) => LikesModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      images: (json['images'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }



  Future<Map<String, dynamic>> toJson() async {
    List<String> encodedImages = [];

    for (final image in images) {
      // لو الصورة عبارة عن Base64 بالفعل (مثلاً جاية من API)، سيبها زي ما هي
      if (image.startsWith('data:image') || image.length > 50000) {
        encodedImages.add(image);
      } else {
        final file = File(image);
        if (await file.exists()) {
          try {
            // Compress the image
            final result = await FlutterImageCompress.compressWithFile(
              file.absolute.path,
              minWidth: 1024,
              minHeight: 1024,
              quality: 70, // 70% quality reduces size significantly
            );

            if (result != null) {
              encodedImages.add('data:image/jpeg;base64,${base64Encode(result)}');
            } else {
              // Fallback if compression returns null
              final bytes = await file.readAsBytes();
              encodedImages.add('data:image/jpeg;base64,${base64Encode(bytes)}');
            }
          } catch (e) {
             // Fallback if compression throws error
            final bytes = await file.readAsBytes();
            encodedImages.add('data:image/jpeg;base64,${base64Encode(bytes)}');
          }
        }
      }
    }

    return {
      'id': id,
      'authorId': author.id,
      'content': content,
      'creationDate': creationDate,
      'modifyDate': modifyDate,
      'images': encodedImages,
    };
  }
  PostModel.fromEntity(PostEntity postEntity)
      : super(
    id: postEntity.id,
    author: postEntity.author,
    comments: postEntity.comments,
    likes: postEntity.likes,
    content: postEntity.content,
    creationDate: postEntity.creationDate,
    modifyDate: postEntity.modifyDate,
    images: postEntity.images,
  );

  PostEntity toEntity(PostModel postModel) => PostEntity(
    id: postModel.id,
    author: postModel.author,
    comments: postModel.comments,
    likes: postModel.likes,
    content: postModel.content,
    creationDate: postModel.creationDate,
    modifyDate: postModel.modifyDate,
    images: postModel.images,
  );
}

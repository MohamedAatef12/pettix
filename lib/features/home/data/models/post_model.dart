import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
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
    required super.statusId,
    required super.isSaved
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
        statusId: 3,
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
      statusId: json['statusId'],
      isSaved: json['isSaved'] ?? false,
    );
  }


  Future<Map<String, dynamic>> toJson() async {
    List<Map<String, dynamic>> encodedImages = [];

    for (final image in images) {
      String base64Image = '';

      if (image.startsWith('data:image') || image.length > 50000) {
        base64Image = image;
      } else {
        final file = File(image);
        if (await file.exists()) {
          try {
            final result = await FlutterImageCompress.compressWithFile(
              file.absolute.path,
              minWidth: 1024,
              minHeight: 1024,
              quality: 70,
            );

            if (result != null) {
              base64Image = base64Encode(result);
            } else {
              final bytes = await file.readAsBytes();
              base64Image = base64Encode(bytes);
            }
          } catch (e) {
            final bytes = await file.readAsBytes();
            base64Image = base64Encode(bytes);
          }
        }
      }

      final String extension = p.extension(image).replaceFirst('.', '') ?? 'jpg';

      encodedImages.add({
        "filename": "image_${DateTime.now().millisecondsSinceEpoch}.$extension",
        "base64": base64Image,
        "state": 1,
      });
    }

    return {
      "content": content,
      "images": encodedImages,
      "statusId":statusId, // أو حسب الحالة عندك
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
    statusId: postEntity.statusId,
    isSaved:  postEntity.isSaved
  );

  PostEntity toEntity() => PostEntity(
    id: id,
    author: author,
    comments: comments,
    likes: likes,
    content: content,
    creationDate: creationDate,
    modifyDate: modifyDate,
    images: images,
    statusId: statusId,
    isSaved: isSaved
  );
}

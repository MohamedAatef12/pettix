import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:pettix/data/network/constants.dart';
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
    required super.isSaved,
    required super.isLiked,
    required super.totalComments,
    required super.totalLikes,
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
      images: _parseImages(json['images'] as List<dynamic>?),
      statusId: json['statusId'],
      isSaved: json['isSaved'],
      isLiked: json['isLiked'] ?? false,
      totalComments: json['totalComments'] is int ? json['totalComments'] : int.tryParse(json['totalComments']?.toString() ?? '0') ?? 0,
      totalLikes: json['totalLikes'] is int ? json['totalLikes'] : int.tryParse(json['totalLikes']?.toString() ?? '0') ?? 0,
    );
  }

  /// Normalizes the raw image list from the API into usable URLs.
  ///
  /// The backend can return three different formats:
  ///  1. A proper `https://` URL  → kept as-is.
  ///  2. A malformed data-URL like `data:image/png;base64,Resources/PostsUploads/file.jpg`
  ///     → extracted path is appended to [Constants.baseUrl].
  ///  3. A real base64 data-URL  → kept as-is.
  static List<String> _parseImages(List<dynamic>? rawList) {
    if (rawList == null) return [];

    final result = <String>[];
    for (final item in rawList) {
      final raw = item.toString().trim();
      if (raw.isEmpty) continue;

      if (raw.startsWith('http')) {
        // ✅ Already a proper URL
        // Workaround: Backend sometimes returns ContactsUploads instead of PostsUploads for post images.
        final correctedUrl = raw.replaceAll('ContactsUploads', 'PostsUploads');
        result.add(correctedUrl);
      } else if (raw.startsWith('data:image') && raw.contains('Resources/')) {
        // ⚠️ Malformed: "data:image/png;base64,Resources/PostsUploads/xyz.jpg"
        // Extract the relative path and build a real URL.
        final pathPart = raw.split(',').last.trim();
        final cleanPath = pathPart.startsWith('/') ? pathPart.substring(1) : pathPart;
        final properUrl = '${Constants.baseUrl}/$cleanPath';
        final correctedUrl = properUrl.replaceAll('ContactsUploads', 'PostsUploads');
        debugPrint('🔧 [PostModel] Fixed malformed image URL → $correctedUrl');
        result.add(correctedUrl);
      } else if (raw.startsWith('data:image')) {
        // ✅ Real base64 image data
        result.add(raw);
      } else {
        // Unknown format – log and skip
        debugPrint('⚠️ [PostModel] Unknown image format, skipping: ${raw.length > 80 ? raw.substring(0, 80) : raw}');
      }
    }
    return result;
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

      final String extension = p.extension(image).replaceFirst('.', '') ;

      encodedImages.add({
        "filename": "image_${DateTime.now().millisecondsSinceEpoch}.$extension",
        "base64": base64Image,
        "state": 1,
      });
    }

    return {
      "content": content,
      "images": encodedImages,
      "statusId":statusId,
      "isSaved": isSaved,
      "isLiked": isLiked,
      "totalComments": totalComments,
      "totalLikes": totalLikes,
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
    isSaved:  postEntity.isSaved,
    isLiked: postEntity.isLiked,
    totalComments: postEntity.totalComments,
    totalLikes: postEntity.totalLikes,
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
    isSaved: isSaved,
    isLiked: isLiked,
    totalComments: totalComments,
    totalLikes: totalLikes,
  );
}

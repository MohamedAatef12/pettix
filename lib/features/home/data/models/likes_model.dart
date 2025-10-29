import 'package:pettix/features/home/data/models/author_model.dart';
import '../../domain/entities/likes_entity.dart';

class LikesModel extends LikesEntity {
  const LikesModel({
    required super.id,
    required super.author,
    required super.creationDate,
    super.postId,
  });

  factory LikesModel.fromJson(Map<String, dynamic> json) {
    return LikesModel(
      id: (json['id'] ?? 0) is int
          ? json['id'] ?? 0
          : int.tryParse(json['id'].toString()) ?? 0,
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
      creationDate: json['creationDate']?.toString() ?? '',
      postId: (json['postId'] == null)
          ? null
          : (json['postId'] is int
          ? json['postId']
          : int.tryParse(json['postId'].toString())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': (author as AuthorModel).toJson(),
      'creationDate': creationDate,
      'postId': postId,
    };
  }

  LikesModel.fromEntity(LikesEntity entity)
      : super(
    id: entity.id,
    author: entity.author,
    creationDate: entity.creationDate,
    postId: entity.postId,
  );

  LikesEntity toEntity(LikesModel model) => LikesEntity(
    id: model.id,
    author: model.author,
    creationDate: model.creationDate,
    postId: model.postId,
  );
}

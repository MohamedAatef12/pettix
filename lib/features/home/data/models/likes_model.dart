import '../../domain/entities/likes_entity.dart';

class LikesModel extends LikesEntity {
  const LikesModel({
    required super.id,
    required super.userID,
    required super.postID,
    required super.date,
  });

  factory LikesModel.fromJson(Map<String, dynamic> json) {
    return LikesModel(
      id: json['id'],
      userID: json['userID'],
      postID: json['postID'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'postID': postID,
      'date': date,
    };
  }

  LikesModel.fromEntity(LikesEntity likesModel)
      : super(
          id: likesModel.id,
          userID: likesModel.userID,
          postID: likesModel.postID,
          date: likesModel.date,
        );

  LikesEntity toEntity(LikesModel likesModel) => LikesEntity(
        id: likesModel.id,
        userID: likesModel.userID,
        postID: likesModel.postID,
        date: likesModel.date,
      );
}

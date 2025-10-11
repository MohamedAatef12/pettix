import '../../domain/entities/post_entity.dart';
import 'author_model.dart';

class PostModel extends PostEntity {
  const PostModel({
    required super.id,
    required super.authorID,
    required super.text,
    required super.username,
    required super.date,
    required super.imageUrl,
    required super.author,
    required super.commentsCount,
    required super.likesCount,
    required super.liked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      authorID: json['authorID'] as int,
      username: json['username'] as String,
      text: json['text'] as String,
      date: json['date'] as String,
      imageUrl: json['image'] as String,
      author: json['author'] != null
          ? AuthorModel.fromJson(json['author'] as Map<String, dynamic>)
          : AuthorModel(
              id: 0,
              email: '',
              phone: '',
              password: '',
              city: '',
              country: '',
              imageUrl: '',
              userName: '',
              gender: '',
              address: '',
              age: 0,
            ),
      commentsCount: json['commentsCount'] as int? ?? 0,
      likesCount: json['likesCount'] as int? ?? 0,
      liked: json['liked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorID': authorID,
      'username': username,
      'text': text,
      'date': date,
      'image': imageUrl,
      'author': author,
      'commentsCount': commentsCount,
      'likesCount': likesCount,
      'liked': liked,
    };
  }

  PostModel.fromEntity(PostEntity postEntity)
      : super(
          id: postEntity.id,
          authorID: postEntity.authorID,
          username: postEntity.username,
          text: postEntity.text,
          date: postEntity.date,
          imageUrl: postEntity.imageUrl,
          author: postEntity.author,
          commentsCount: postEntity.commentsCount,
          likesCount: postEntity.likesCount,
          liked: postEntity.liked,
        );

  PostEntity toEntity(PostModel postModel) => PostEntity(
        id: postModel.id,
        authorID: postModel.authorID,
        username: postModel.username,
        text: postModel.text,
        date: postModel.date,
        imageUrl: postModel.imageUrl,
        author: postModel.author,
        commentsCount: postModel.commentsCount,
        likesCount: postModel.likesCount,
        liked: postModel.liked,
      );
}

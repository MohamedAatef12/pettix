import 'package:equatable/equatable.dart';

class CommentEntity extends Equatable {
  final int id;
  final String text;
  final int postID;
  // final String userName;
  // final String userImage;
  final int userID;
  final String date;
  const CommentEntity({
    required this.id,
    required this.text,
    required this.postID,
    required this.userID,
    required this.date,
    // required this.userName,
    // required this.userImage,
  });
  @override
  List<Object?> get props => [id, text, postID, userID, date];
}

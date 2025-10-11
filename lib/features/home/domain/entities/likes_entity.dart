import 'package:equatable/equatable.dart';

class LikesEntity extends Equatable {
  final int id;
  final int userID;
  final int postID;
  final String date;

  const LikesEntity({
    required this.id,
    required this.userID,
    required this.postID,
    required this.date,
  });

  @override
  List<Object?> get props => [id, userID, postID, date];
}

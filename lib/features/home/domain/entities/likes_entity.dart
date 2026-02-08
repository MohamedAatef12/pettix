import 'package:equatable/equatable.dart';
import 'package:pettix/features/home/domain/entities/author_entity.dart';

class LikesEntity extends Equatable {
  final int id;
  final AuthorEntity author;
  final String creationDate;
  final int? postId ;

  const LikesEntity({
    required this.id,
   required this.author,
    required this.creationDate,
     this.postId,
  });

  @override
  List<Object?> get props => [id, author, creationDate, postId];
}

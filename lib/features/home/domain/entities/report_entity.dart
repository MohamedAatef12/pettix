import 'package:equatable/equatable.dart';
import 'package:pettix/features/home/domain/entities/author_entity.dart';

class ReportEntity extends Equatable {
  final int id;
  final int postId;
  final AuthorEntity author;
  final String reasonName;
  final String customReason;
  final DateTime creationDate;

  const ReportEntity({
    required this.id,
    required this.postId,
    required this.author,
    required this.reasonName,
    required this.customReason,
    required this.creationDate,
  });

  @override
  List<Object?> get props => [
    id,
    postId,
    author,
    reasonName,
    customReason,
    creationDate,
  ];
}

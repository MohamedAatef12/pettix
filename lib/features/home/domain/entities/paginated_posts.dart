import 'package:equatable/equatable.dart';
import 'package:pettix/features/home/domain/entities/post_entity.dart';

class PaginatedPosts extends Equatable {
  final List<PostEntity> posts;
  final int pageIndex;
  final int pageSize;
  final int totalCount;

  const PaginatedPosts({
    required this.posts,
    required this.pageIndex,
    required this.pageSize,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [posts, pageIndex, pageSize, totalCount];
}

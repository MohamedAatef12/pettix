import 'package:pettix/features/home/data/models/post_model.dart';
import 'package:pettix/features/home/domain/entities/paginated_posts.dart';

class PaginatedPostsModel extends PaginatedPosts {
  final List<PostModel> postsModels;

  const PaginatedPostsModel({
    required this.postsModels,
    required super.pageIndex,
    required super.pageSize,
    required super.totalCount,
  }) : super(posts: postsModels);

  factory PaginatedPostsModel.fromJson(Map<String, dynamic> json) {
    final postsData = json['data'] as List? ?? [];
    final posts = postsData.map((e) => PostModel.fromJson(e as Map<String, dynamic>)).toList();
    
    return PaginatedPostsModel(
      postsModels: posts,
      pageIndex: json['pageIndex'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      totalCount: json['count'] as int? ?? posts.length,
    );
  }
}

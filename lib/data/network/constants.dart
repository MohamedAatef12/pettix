class ApiEndpoints {
  static const String baseUrl = 'https://pettix-production.up.railway.app';

  static const String commentsEndpoint = 'Comments/post';
  static const String commentLikesEndpoint = 'CommentLikes';
  static const String usersEndpoint = 'Users';
  static const String postsEndpoint = 'Posts';
  static const String likesEndpoint = 'Likes';
  static const String postLikesEndpoint = 'PostLikes';
  static const String getPostLikes = 'PostLikes/post';
  static const String loginEndpoint = 'Authentication/login';
  static const String googleLoginEndpoint = 'Authentication/google-login';
  static const String reportPostEndpoint = 'PostReport';
  static const String reportReasonsEndpoint = 'PostReport/reasons';
  static const String reportedPostsEndpoint = 'PostReport/post';

  // Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String applicationJson = 'application/json';
}

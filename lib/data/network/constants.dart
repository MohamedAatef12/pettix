class Constants {
  // static const String baseUrl = 'https://pettix-production.up.railway.app';
  static const String baseUrl = 'https://b104-81-10-3-82.ngrok-free.app';
  static const commentsEndpoint = '/api/Timeline/Comments/param';
  static const addCommentEndpoint = '/api/Timeline/Comments/post';
  static const commentLikesEndpoint = '/api/Timeline/CommentLikes/comment';
  static const addCommentLikesEndpoint = '/api/Timeline/CommentLikes';
  static const commentLikesCountEndpoint = '/api/Timeline/CommentLikes/comment';
  static const postCommentsCount = '/api/Timeline/Comments/post';
  static const postsEndpoint = '/api/Timeline/Posts/paged';
  static const addPostsEndpoint = '/api/Timeline/Posts';
  static const postLikesEndpoint = '/api/Timeline/PostLikes';
  static const postUnLikesEndpoint = '/api/Timeline/PostLikes';
  static const likeCommentEndpoint = '/api/Timeline/CommentLikes';
  static const unlikeCommentEndpoint = '/api/Timeline/CommentLikes';
  static const savePostEndpoint = '/api/Timeline/PostSave';
  static const unSavePostEndpoint = '/api/Timeline/PostSave';
  static const String getPostLikes = '/api/Timeline/PostLikes/post';
  static const String loginEndpoint = '/api/Security/Authentication/login';
  static const String registerEndpoint =
      '/api/Security/Authentication/register';
  static const String googleLoginEndpoint =
      '/api/Security/Authentication/google-login';
  static const String addReportPostEndpoint = '/api/Timeline/PostReport';
  static const String reportReasonsEndpoint =
      '/api/Timeline/PostReport/reasons';
  static const String reportedPostsEndpoint = '/api/Timeline/PostReport/post';
  static const String verifyOtpEndpoint =
      '/api/Security/Authentication/verify-otp';
  static const String resendOtpEndpoint =
      '/api/Security/Authentication/resend-otp';
  static const String forgotPasswordEndpoint =
      '/api/Security/Authentication/forgot-password';
  static const String resetPasswordEndpoint =
      '/api/Security/Authentication/reset-password-otp';
  static const String notificationSearchEndpoint = '/api/Notifications/Search';
  static const String readAllNotificationsEndpoint =
      '/api/Notifications/ReadAll';
  static const String readSingleNotificationEndpoint =
      '/api/Notifications/Read/param';
  static const String sendNotificationEndpoint = '/api/Notifications/Send';
  // Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String applicationJson = 'application/json';
}

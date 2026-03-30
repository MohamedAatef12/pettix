class Constants {
  // static const String baseUrl = 'https://pettix-production.up.railway.app';
  static const String baseUrl = 'https://2b14-81-10-3-82.ngrok-free.app';

  static const commentsEndpoint = '/api/Comments/post';
  static const commentLikesEndpoint = '/api/CommentLikes';
  static const usersEndpoint = '/api/Users';
  static const postsEndpoint = '/api/Posts';
  static const likesEndpoint = '/api/Likes';
  static const postLikesEndpoint = '/api/PostLikes';
  static const String getPostLikes = '/api/PostLikes/post';
  static const String loginEndpoint = '/api/Security/Authentication/login';
  static const String registerEndpoint = '/api/Security/Authentication/register';
  static const String googleLoginEndpoint = '/api/Security/Authentication/google-login';
  static const String reportPostEndpoint = '/api/PostReport';
  static const String reportReasonsEndpoint = '/api/PostReport/reasons';
  static const String reportedPostsEndpoint = '/api/PostReport/post';
  static const String verifyOtpEndpoint = '/api/Security/Authentication/verify-otp';
  static const String resendOtpEndpoint = '/api/Security/Authentication/resend-otp';
  static const String forgotPasswordEndpoint = '/api/Security/Authentication/forgot-password';
  static const String resetPasswordEndpoint = '/api/Security/Authentication/reset-password-otp';
  static const String adoptionOptionsEndpoint = '/api/Adoption/AdoptionForms/options';
  static const String adoptionFormsEndpoint = '/api/Adoption/AdoptionForms';
  // Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String applicationJson = 'application/json';
}

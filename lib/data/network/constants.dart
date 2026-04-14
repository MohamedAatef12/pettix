class Constants {
  // ── Base URL ──────────────────────────────────────────────────────────────
  // static const String baseUrl = 'https://pettix-production.up.railway.app';
  static const String baseUrl = 'https://9816-81-10-3-82.ngrok-free.app';

  // ── Authentication ────────────────────────────────────────────────────────
  static const String loginEndpoint = '/api/Security/Authentication/login';
  static const String registerEndpoint = '/api/Security/Authentication/register';
  static const String googleLoginEndpoint = '/api/Security/Authentication/google-login';
  static const String appleLoginEndpoint = '/api/Security/Authentication/apple-login';
  static const String verifyOtpEndpoint = '/api/Security/Authentication/verify-otp';
  static const String resendOtpEndpoint = '/api/Security/Authentication/resend-otp';
  static const String forgotPasswordEndpoint = '/api/Security/Authentication/forgot-password';
  static const String resetPasswordEndpoint = '/api/Security/Authentication/reset-password-otp';

  // ── Timeline / Community ──────────────────────────────────────────────────

  //// Posts 
  static const String getPostByIdEndpoint = '/api/Timeline/Posts';
  static const String postsEndpoint = '/api/Timeline/Posts/paged';
  static const String addPostsEndpoint = '/api/Timeline/Posts';
  static const String postLikesEndpoint = '/api/Timeline/PostLikes';
  static const String postUnLikesEndpoint = '/api/Timeline/PostLikes';
  static const String getPostLikes = '/api/Timeline/PostLikes/post';
  static const String savePostEndpoint = '/api/Timeline/PostSave';
  static const String unSavePostEndpoint = '/api/Timeline/PostSave';

  //// Comments
  static const String commentsEndpoint = '/api/Timeline/Comments/param';
  static const String addCommentEndpoint = '/api/Timeline/Comments/post';
  static const String postCommentsCount = '/api/Timeline/Comments/post';
  static const String commentLikesEndpoint = '/api/Timeline/CommentLikes/comment';
  static const String addCommentLikesEndpoint = '/api/Timeline/CommentLikes';
  static const String commentLikesCountEndpoint = '/api/Timeline/CommentLikes/comment';
  static const String likeCommentEndpoint = '/api/Timeline/CommentLikes';
  static const String unlikeCommentEndpoint = '/api/Timeline/CommentLikes';

  //// Reports
  static const String addReportPostEndpoint = '/api/Timeline/PostReport';
  static const String reportReasonsEndpoint = '/api/Timeline/PostReport/reasons';
  static const String reportedPostsEndpoint = '/api/Timeline/PostReport/post';

  // ── Adoption & Pets ───────────────────────────────────────────────────────
  
  //// Pets
  static const String pagedPetsEndpoint = '/api/Adoption/Pets/paged';
  static const String petsEndpoint = '/api/Adoption/Pets';
  static const String userPetsEndpoint = '/api/Adoption/Pets/admin/user';
  static const String petCategoryEndpoint = '/api/Adoption/PetCategory';
  static const String petColorsEndpoint = '/api/Adoption/PetColors';
  static const String petMedicalsEndpoint = '/api/Adoption/PetMedicals';

  //// Adoption Forms
  static const String adoptionFormsEndpoint = '/api/Adoption/AdoptionForms';
  static const String adoptionOptionsEndpoint = '/api/Adoption/AdoptionForms/options';
  static const String clientFormsEndpoint = '/api/Adoption/AdoptionForms/clients-forms';
  static const String ownerFormsEndpoint = '/api/Adoption/AdoptionForms/owner-forms';

  // ── Notifications ─────────────────────────────────────────────────────────
  static const String notificationSearchEndpoint = '/api/Notifications/Search';
  static const String readAllNotificationsEndpoint = '/api/Notifications/ReadAll';
  static const String readSingleNotificationEndpoint = '/api/Notifications/Read/param';
  static const String sendNotificationEndpoint = '/api/Notifications/Send';

  // ── Support ───────────────────────────────────────────────────────────────
  static const String contactEndpoint = '/api/Security/Contact';

  // ── Headers ───────────────────────────────────────────────────────────────
  static const String contentTypeHeader = 'Content-Type';
  static const String applicationJson = 'application/json';
}


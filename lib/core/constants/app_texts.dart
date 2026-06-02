import 'package:easy_localization/easy_localization.dart';

abstract class AppText {
  static String get connectWithPetLovers => 'Connect with Pet Lovers'.tr();
  static String get shareDailyAdventures =>
      'Share your pet’s daily adventures, post cute pictures, and engage with a loving pet community \u2028just like you!'
          .tr();
  static String get careSafetySecondChances =>
      'Care. Safety. Second Chances.'.tr();
  static String get findLovingHomes =>
      'Find loving homes for pets, access trusted clinics, or get urgent help in emergencies — all in one\u2028 convenient place.'
          .tr();
  static String get everythingYourPetNeeds => 'Everything Your Pet Needs.'.tr();
  static String get discoverFoodToys =>
      'Discover food, toys, and grooming essentials. \u2028Shop easily for your furry friend from \u2028trusted pet brands.'
          .tr();
  static String get loginTitle => 'Sign in to your account'.tr();
  static String get loginSubtitle =>
      'Enter your email and password to log in'.tr();
  static String get emailOrPhone => 'Email'.tr();
  static String get enterYourEmail => 'Enter your email'.tr();
  static String get required => 'Required'.tr();
  static String get validEmail => 'Please enter a valid email address'.tr();
  static String get password => 'Password'.tr();
  static String get password8Chars =>
      'Password must be at least 8 characters'.tr();
  static String get passwordUppercase =>
      'Must contain at least one uppercase letter'.tr();
  static String get passwordLowercase =>
      'Must contain at least one lowercase letter'.tr();
  static String get passwordNumber => 'Must contain at least one number'.tr();
  static String get passwordRequired => 'Password is required'.tr();

  static String get rememberMe => 'Remember Me'.tr();
  static String get forgetPassword => 'Forget Password?'.tr();
  static String get signIn => 'Sign In'.tr();
  static String get or => 'OR'.tr();
  static String get continueWithGoogle => 'Continue with Google'.tr();
  static String get continueWithApple => 'Continue with Apple'.tr();
  static String get dontHaveAccount => "Don't have an account? ".tr();
  static String get signUp => 'Sign Up'.tr();

  static String get newPassword => 'New Password'.tr();
  static String get enterNewPassword => 'Please enter your new password.'.tr();
  static String get enterPassword => 'Enter your password'.tr();

  static String get otpVerification => 'OTP Verification'.tr();
  static String get didntReceiveCode => 'Didn’t receive code? '.tr();
  static String get resend => 'Resend'.tr();
  static String get verify => 'Verify'.tr();

  static String get createAccountToContinue =>
      'Create an account to continue! '.tr();
  static String get fullName => 'Full Name'.tr();
  static String get name => 'Name'.tr();
  static String get enterName => 'Enter your name'.tr();
  static String get email => 'Email'.tr();
  static String get phoneNumber => 'Phone Number'.tr();
  static String get enterPhoneNumber => 'Enter your phone number'.tr();
  static String get continue_ => 'Continue'.tr();
  static String get alreadyHaveAccount => 'Already have account? '.tr();

  static String get setPassword => 'Set Password'.tr();
  static String get confirmPassword => 'Confirm Password'.tr();
  static String get resetPassword => 'Reset Password'.tr();
  static String get verified => 'verified!'.tr();
  static String get identityVerified =>
      'Your identity has been successfully verified.'.tr();
  static String get done => 'Done'.tr();

  static String get checkYourEmail => 'Check Your Email'.tr();
  static String get enterOtpSent => 'Enter the OTP we sent to '.tr();
  static String get didntReceiveLink => 'Didn’t receive link? '.tr();
  static String get passwordReset => 'Password Reset'.tr();
  static String get resetCompleteWelcomeBack =>
      'Reset complete. Welcome back!'.tr();

  static String get home => 'Home'.tr();
  static String get adoption => 'Adoption'.tr();
  static String get store => 'Store'.tr();
  static String get clinics => 'Clinics'.tr();
  static String get settings => 'Settings'.tr();
  static String get language => 'Language'.tr();
  static String get en => 'EN'.tr();
  static String get ar => 'ع'.tr();

  static String get privacyPolicy => 'privacy policy'.tr();
  static String get refundPolicy => 'Refund Policy'.tr();
  static String get termsConditions => 'Terms & Conditions'.tr();
  static String get logOut => 'Log out'.tr();
  static String get switchToClinic => 'Switch to clinic'.tr();
  static String get selectYourLanguage => 'Select Your Language'.tr();
  static String get arabic => 'Arabic'.tr();
  static String get english => 'English'.tr();

  static String get noNotifications => 'No Notifications'.tr();
  static String get noNotificationsYet =>
      "You have no notifications yet,\n please Come back later.".tr();
  static String get notificationTitle => 'Notification Title'.tr();
  static String get notificationDesc =>
      'This is a brief description of the notification. It provides more details about the notification content.'
          .tr();
  static String get markAsRead => 'Mark as read'.tr();
  static String get all => 'All'.tr();
  static String get unread => 'Unread'.tr();
  static String get notificationsText => 'Notifications'.tr();

  static String get comments => 'Comments'.tr();
  static String get addComment => 'Add a comment...'.tr();
  static String get share => 'Share'.tr();
  static String get writeCaption => 'Write a caption...'.tr();
  static String get somethingWentWrong =>
      "Something went wrong ..!\n   Please try again later.".tr();
  static String get noCommentsYet => 'No comments yet.'.tr();
  static String get reply => 'Reply'.tr();
  static String get hideReplies => 'Hide replies'.tr();
  static String get viewReplies => 'View replies'.tr();

  static String get justNow => 'Just now'.tr();
  static String get mAgo => 'm ago'.tr();
  static String get hAgo => 'h ago'.tr();
  static String get dAgo => 'd ago'.tr();
  static String get notificationText => 'notification'.tr();
  static String get noContentPhoto => 'no_content_photo'.tr();
  static String get addPost => 'add_post'.tr();
  static String get add => 'Add'.tr();

  static String get search => 'Search'.tr();
  static String get reportPost => 'Report Post'.tr();
  static String get specifyReason => 'Please specify the reason'.tr();
  static String get typeReasonHere => 'Type your reason here...'.tr();
  static String get cancel => 'Cancel'.tr();
  static String get submit => 'Submit'.tr();
  static String get reportSentSuccessfully => 'Report sent successfully'.tr();
  static String get replyingTo => 'Replying to'.tr();
  static String get whatsOnYourMind => "What's on your mind?".tr();
  static String get post => 'Post'.tr();
  static String get publicLabel => 'Public'.tr();
  static String get camera => 'Camera'.tr();
  static String get uploadingPost => 'Uploading your post...'.tr();
  static String get userFallback => 'User'.tr();
  static String replyCount(int n) =>
      'Reply ({count})'.tr(namedArgs: {'count': '$n'});
  static String likesCount(int n) =>
      'Likes {count}'.tr(namedArgs: {'count': '$n'});
  static String viewRepliesCount(int n) =>
      'View replies ({count})'.tr(namedArgs: {'count': '$n'});
  static String minutesAgo(int n) =>
      '{count}m ago'.tr(namedArgs: {'count': '$n'});
  static String hoursAgo(int n) =>
      '{count}h ago'.tr(namedArgs: {'count': '$n'});
  static String daysAgo(int n) =>
      '{count}d ago'.tr(namedArgs: {'count': '$n'});

  // ── Chat ────────────────────────────────────────────────────────────────────
  static String get messagesTitle => 'Messages'.tr();
  static String get chatTitle => 'Chat'.tr();
  static String get loadingText => 'Loading...'.tr();
  static String get searchConversations => 'Search conversations...'.tr();
  static String get updating => 'Updating'.tr();
  static String get gallery => 'Gallery'.tr();
  static String get writeYourMessage => 'write your message here'.tr();
  static String get noConversationsFound => 'No conversations found'.tr();
  static String get noMessagesYet => 'No messages yet...'.tr();
  static String noResultsFor(String q) =>
      'No results for "{query}"'.tr(namedArgs: {'query': q});
  static String conversationFallback(int id) =>
      'Conversation {id}'.tr(namedArgs: {'id': '$id'});
  static String userIndex(int i) =>
      'User {index}'.tr(namedArgs: {'index': '$i'});
  static String weekdayAbbr(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(weekday - 1).clamp(0, 6)].tr();
  }

  static String get messages => 'messages'.tr();
  static String get writeMessage => 'write_message'.tr();
  static String get viewProfile => 'View Profile'.tr();
  static String get available => 'Available'.tr();
  static String get archived => 'Archived'.tr();
  static String get latestMessage => 'Latest message...'.tr();
  static String get skip => 'Skip'.tr();
  static String get emailNotVerified => 'Your email not verified? '.tr();
  static String get resendActivationEmail => 'Resend activation email'.tr();
  static String get activateEmail => 'Activate your email'.tr();
  static String get activateEmailDesc =>
      'Please check your email and click on the activation link to verify your account.'
          .tr();
  static String get verificationEmailSent =>
      'Account created! Check your email for the OTP.'.tr();
  static String get send => 'Send'.tr();
  static String get sendOtp => "Send OTP".tr();
  static String get markAllAsReadNotify => "Mark all as read".tr();
  static String get timeline => "Timeline".tr();
  static String get emergency => "Emergency".tr();
  static String get readMore => "Read More".tr();
  static String get new_ => "New".tr();
  static String get newLikeTitle => "New Like".tr();
  static String get newLikeBody => "Someone liked your post".tr();
  static String get newCommentTitle => "New Comment".tr();
  static String get newCommentBody => "Someone commented on your post".tr();
  static String get newReplyTitle => "New Reply".tr();
  static String get repliedToYourComment => "replied to your comment".tr();

  // ── Drawer ──────────────────────────────────────────────────────────────────
  static String get myProfile => 'My Profile'.tr();
  static String get editProfile => 'Edit Profile'.tr();
  static String get activity => 'Activity'.tr();
  static String get myPosts => 'My Posts'.tr();
  static String get savedPosts => 'Saved Posts'.tr();
  static String get adoptionPets => 'Adoption & Pets'.tr();
  static String get adoptionHistory => 'Adoption History'.tr();
  static String get storeOrders => 'Store & Orders'.tr();
  static String get myOrders => 'My Orders'.tr();
  static String get myAddresses => 'My Addresses'.tr();
  static String get paymentMethods => 'Payment Methods'.tr();
  static String get refundsReturns => 'Refunds & Returns'.tr();
  static String get emergencyReports => 'My Emergency Reports'.tr();
  static String get helpSupport => 'Help & Support'.tr();
  static String get legal => 'Legal'.tr();
  static String get logout => 'Logout'.tr();
  static String get logoutDesc => 'Are you sure you want to logout?'.tr();
  static String get switchRole => 'Switch Role'.tr();
  static String get petLover => 'Pet Lover'.tr();
  static String get userName => 'User Name'.tr();

  // ── Profile ─────────────────────────────────────────────────────────────────
  static String get personalInfo => 'Personal Info'.tr();
  static String get details => 'Details'.tr();
  static String get nameAr => 'Name (Arabic)'.tr();
  static String get age => 'Age'.tr();
  static String get gender => 'Gender'.tr();
  static String get address => 'Address'.tr();
  static String get phone => 'Phone'.tr();
  static String get male => 'Male'.tr();
  static String get female => 'Female'.tr();
  static String get error => 'Something went wrong'.tr();
  static String get profileUpdated => 'Profile updated successfully'.tr();
  static String get saveChanges => 'Save Changes'.tr();
  static String get save => 'Save'.tr();
  static String get accountSettings => 'Account Settings'.tr();
  static String get notificationSettings => 'Notification Settings'.tr();
  static String get appSettings => 'App Settings'.tr();
  static String get themes => 'Themes'.tr();
  static String get light => 'Light'.tr();
  static String get pets => 'Pets'.tr();
  static String get unknownLocation => 'Unknown location'.tr();
  static String get locationServicesDisabled =>
      'Location services are disabled.'.tr();
  static String get locationPermissionDenied =>
      'Location permission denied.'.tr();
  static String get enableLocationSettings =>
      'Enable location in device settings.'.tr();
  static String get realLocationUnavailable =>
      'Real location unavailable on this device.'.tr();
  static String get locationRequestTimedOut =>
      'Location request timed out. Try again.'.tr();
  static String get selectedLocationUpper => 'SELECTED LOCATION'.tr();
  static String get moveMapSelectLocation =>
      'Move the map to select a location'.tr();
  static String get confirmLocation => 'Confirm Location'.tr();

  static String locationError(String errorType) =>
      'Location error: {errorType}'.tr(namedArgs: {'errorType': errorType});

  // Adoption browse
  static String get findYourPetPartner => 'Find Your Pet Partner'.tr();
  static String get searchByName => 'Search by name...'.tr();
  static String get searchForPets => 'Search for pets ...'.tr();
  static String get allPets => 'All Pets'.tr();
  static String get petsAvailable => 'pets available'.tr();
  static String get clearFilters => 'Clear filters'.tr();
  static String get noPetsFound => 'No pets found'.tr();
  static String get retry => 'Retry'.tr();
  static String get unknown => 'Unknown'.tr();
  static String get unknownPet => 'Unknown Pet'.tr();
  static String get ageUnknown => 'Age unknown'.tr();
  static String get yearsShort => 'yrs'.tr();
  static String get yearShort => 'yr'.tr();
  static String get filterSort => 'Filter & Sort'.tr();
  static String get resetAll => 'Reset All'.tr();
  static String get genderUpper => 'GENDER'.tr();
  static String get sortByUpper => 'SORT BY'.tr();
  static String get defaultSort => 'Default'.tr();
  static String get order => 'Order:'.tr();
  static String get ascending => 'Ascending'.tr();
  static String get descending => 'Descending'.tr();
  static String get applyFilters => 'Apply Filters'.tr();
  static String get dogs => 'Dogs'.tr();
  static String get cats => 'Cats'.tr();
  static String get birds => 'Birds'.tr();
  static String get rabbits => 'Rabbits'.tr();
  static String get fish => 'Fish'.tr();
  static String get demoPetName => 'Charlie'.tr();
  static String get demoPetDescription =>
      'Subbran animal leagueEnergtic and loves walks'.tr();

  // Adoption pet profile
  static String get reportPet => 'Report Pet'.tr();
  static String get reportPetDescription =>
      'Help us keep the community safe. Please select a reason why you are reporting this pet.'
          .tr();
  static String get specifyReasonPetDescription =>
      'Please provide details about why you want to report this pet listing.'
          .tr();
  static String get applyToAdopt => 'Apply to Adopt'.tr();
  static String get medicalHistory => 'Medical History'.tr();
  static String get about => 'About'.tr();

  // Adoption application
  static String get setUpYourInformation => 'Set up your information'.tr();
  static String get petExperience => 'Pet Experience'.tr();
  static String get understandingAgreements =>
      'Understanding & Agreements'.tr();
  static String get adoptAPet => 'Adopt a Pet'.tr();
  static String get step => 'Step'.tr();
  static String get of => 'of'.tr();
  static String get reviewYourApplication => 'Review Your Application'.tr();
  static String get next => 'Next'.tr();
  static String get adoptionApplication => 'Adoption Application'.tr();
  static String get pleaseSelectAllOptions => 'Please select all options'.tr();
  static String get pleaseAgreeToTerms => 'Please agree to terms'.tr();
  static String get pleaseSelectDateOfBirth =>
      'Please select Date of Birth'.tr();
  static String get applicationSubmittedSuccessfully =>
      'Application Submitted Successfully!'.tr();
  static String get submissionFailed => 'Submission Failed'.tr();
  static String get errorLoadingOptions => 'Error Loading Options'.tr();
  static String get dateOfBirth => 'Date of Birth'.tr();
  static String get petType => 'Pet Type'.tr();
  static String get livingSituation => 'Living Situation'.tr();
  static String get residenceType => 'Residence Type'.tr();
  static String get hasOwnedOrCaredForPetBefore =>
      'Has owned or cared for pet before?'.tr();
  static String get haveReadAndUnderstoodEverything =>
      'I have read and understood everything'.tr();
  static String get agreeToTerms => 'I agree to the terms'.tr();
  static String get submitApplication => 'Submit Application'.tr();
  static String get readyToWelcomePet =>
      'Ready to welcome a pet at your home?'.tr();
  static String get adoptionIntro =>
      'To ensure the right choice, we\'ll ask you a few questions about your living situation and experience.'
          .tr();
  static String get whatToExpect => 'What to Expect'.tr();
  static String get fillPersonalInformation =>
      'Fill in your personal information'.tr();
  static String get describeLivingSituation =>
      'Describe your living situation'.tr();
  static String get sharePetExperience => 'Share your pet experience'.tr();
  static String get reviewAndSubmitApplication =>
      'Review and submit your application'.tr();
  static String get startApplication => 'Start Application'.tr();
  static String get fullNameRequired => 'Full name is required'.tr();
  static String get nameMinLength => 'Name must be at least 3 characters'.tr();
  static String get firstAndLastName =>
      'Please enter your first and last name'.tr();
  static String get emailAddressRequired => 'Email address is required'.tr();
  static String get enterValidEmail => 'Enter a valid email address'.tr();
  static String get phoneNumberRequired => 'Phone number is required'.tr();
  static String get phoneNumberElevenDigits =>
      'Phone number must be exactly 11 digits'.tr();
  static String get dateOfBirthRequired => 'Date of birth is required'.tr();
  static String get mustBeAdultToAdopt =>
      'You must be at least 18 years old to adopt'.tr();
  static String get invalidDateFormat => 'Invalid date format'.tr();
  static String get emailAddress => 'Email Address'.tr();
  static String get yourFullName => 'Your full name'.tr();
  static String get tapToSelect => 'Tap to select'.tr();
  static String get selectDateOfBirth => 'Select Date of Birth'.tr();
  static String get confirm => 'Confirm'.tr();
  static String get typeOfResidence => 'Type of Residence'.tr();
  static String get loadingOptions => 'Loading options...'.tr();
  static String get haveOwnedPetBefore =>
      'Have you owned or cared for a pet before?'.tr();
  static String get yes => 'Yes'.tr();
  static String get no => 'No'.tr();
  static String get ifYesWhatType => 'If yes, what type?'.tr();
  static String get petTypeHint => 'Dog, Cat, etc.'.tr();
  static String get understandThat => 'I Understand that:'.tr();
  static String get pettixDisclaimer =>
      'Pettix connects pet lovers, adopters, clinics and stores - it does not replace professional veterinary advice.'
          .tr();
  static String get communityResponsibility =>
      'Any content shared in the community is the responsibility of the user who posts it.'
          .tr();
  static String get agreeTo => 'I Agree to:'.tr();
  static String get usePettixResponsibly =>
      'Use Pettix responsibly and respectfully, without harmful or inappropriate behaviour.'
          .tr();
  static String get provideAccurateInformation =>
      'Provide accurate and truthful information when creating my profile or posting.'
          .tr();
  static String get readAndUnderstoodAbove =>
      'I have read and understood everything above.'.tr();
  static String get agreeToTermsConditions =>
      'I agree to the terms and conditions.'.tr();
  static String get reviewBeforeSubmitting =>
      'Almost there! Review your information before submitting.'.tr();
  static String get personalInformation => 'Personal Information'.tr();
  static String get typeOfPet => 'Type of pet'.tr();
  static String get ownedPetBefore => 'Owned a pet before?'.tr();
  static String get petTypeRequired => 'Pet type is required'.tr();
  static String get edit => 'Edit'.tr();
  static String get applicationSubmitted => 'Application Submitted!'.tr();
  static String get submittedThanks =>
      'Thank you! The owner will review your application and may contact you via chat.'
          .tr();
  static String get whatHappensNext => 'What happens next?'.tr();
  static String get ownerReviewNext =>
      'The pet owner will review your application. If they\'re interested, they\'ll reach out to you through the chat feature.'
          .tr();
  static String get viewMyApplication => 'View My Application'.tr();
  static String get browseMorePets => 'Browse More Pets'.tr();

  // Adoption history
  static String get myApplications => 'My Applications'.tr();
  static String get onMyPets => 'On My Pets'.tr();
  static String get pending => 'Pending'.tr();
  static String get approved => 'Approved'.tr();
  static String get rejected => 'Rejected'.tr();
  static String get cancelled => 'Cancelled'.tr();
  static String get noOwnerApplications =>
      'No one has applied to\nyour pets yet'.tr();
  static String get noClientApplications =>
      'You haven\'t applied\nfor any pets yet'.tr();
  static String get anErrorOccurred => 'An error occurred'.tr();
  static String get statusUpdatedSuccessfully =>
      'Status updated successfully'.tr();
  static String get applicant => 'Applicant'.tr();
  static String get housing => 'Housing'.tr();
  static String get residence => 'Residence'.tr();
  static String get ownedAPetBefore => 'Owned a pet before'.tr();
  static String get agreesToTerms => 'Agrees to terms'.tr();
  static String get reviewApplication => 'Review Application'.tr();
  static String get accept => 'Accept'.tr();
  static String get reject => 'Reject'.tr();
  static String get acceptApplication => 'Accept Application'.tr();
  static String get rejectApplication => 'Reject Application'.tr();
  static String get messageApplicant => 'Message Applicant'.tr();
  static String get messageOwner => 'Message Owner'.tr();
  static String get by => 'By:'.tr();
  static String get petNumber => 'Pet #'.tr();

  static String acceptApplicationFor(String petName) =>
      'Are you sure you want to accept the application for {petName}?'.tr(
        namedArgs: {'petName': petName},
      );

  static String rejectApplicationFor(String petName) =>
      'Are you sure you want to reject the application for {petName}?'.tr(
        namedArgs: {'petName': petName},
      );

  // My pets
  static String get myPets => 'My Pets'.tr();
  static String get addNewPet => 'Add New Pet'.tr();
  static String get doneBang => 'Done!'.tr();
  static String get deletePetQuestion => 'Delete Pet?'.tr();
  static String get delete => 'Delete'.tr();
  static String get private => 'Private'.tr();
  static String get noPetsRegisteredYet => 'No Pets Registered Yet'.tr();
  static String get myPetsEmptyDescription =>
      'Tap the button below to register your first pet and make it available for adoption.'
          .tr();
  static String get petsSectionEmptyDescription =>
      'Add your pets from the side menu to keep track of their details and vaccinations.'
          .tr();
  static String get editPetInfo => 'Edit Pet Info'.tr();
  static String get petName => 'Pet Name'.tr();
  static String get description => 'Description'.tr();
  static String get healthDetails => 'Health & Details'.tr();
  static String get healthPersonalityDetails =>
      'Health & Personality Details'.tr();
  static String get ageYears => 'Age (years)'.tr();
  static String get category => 'Category'.tr();
  static String get color => 'Color'.tr();
  static String get basicInfo => 'Basic Info'.tr();
  static String get detailsSection => 'Details'.tr();
  static String get medicalRecords => 'Medical Records'.tr();
  static String get petAddedSuccessfully => 'Pet added successfully!'.tr();
  static String get addPet => 'Add Pet'.tr();
  static String get photo => 'Photo'.tr();
  static String get pettixBrand => 'PETTIX'.tr();
  static String get pettixPetId => 'PETTIX PET ID'.tr();
  static String get petPassport => 'Pet Passport'.tr();
  static String get petPassportUpper => 'PET PASSPORT'.tr();
  static String get tapFullDetails => 'Tap to see full details'.tr();
  static String get code => 'Code'.tr();
  static String get years => 'years'.tr();
  static String get dateUnknown => 'Date unknown'.tr();
  static String get makePrivate => 'Make Private'.tr();
  static String get makeAvailableForAdoption =>
      'Make Available for Adoption'.tr();
  static String get addVaccination => 'Add Vaccination'.tr();
  static String get addVaccinationUpper => 'ADD VACCINATION'.tr();
  static String get customVaccinationName => 'Or type a custom name'.tr();
  static String get selectVaccinationDate => 'Select vaccination date'.tr();
  static String get userNotFound => 'User not found'.tr();

  static String deletePetConfirmation(String petName) =>
      'Are you sure you want to permanently delete {petName}?'.tr(
        namedArgs: {'petName': petName},
      );

  // Help support
  static String get howCanWeHelpYou => 'How can we help you?'.tr();
  static String get chooseSupportCategory =>
      'Choose a category below to get the support you need.'.tr();
  static String get faq => 'FAQ'.tr();
  static String get faqSubtitle => 'Answers to the most common questions'.tr();
  static String get contactSupport => 'Contact Support'.tr();
  static String get contactSupportSubtitle =>
      'Chat, email, or call our team'.tr();
  static String get reportProblem => 'Report a Problem'.tr();
  static String get reportProblemSubtitle =>
      'Tell us what\'s broken or not working'.tr();
  static String get sendFeedback => 'Send Feedback'.tr();
  static String get sendFeedbackSubtitle =>
      'Share ideas to help us improve'.tr();
  static String get needImmediateHelp => 'Need immediate help?'.tr();
  static String get supportTeamResponse =>
      'Our support team typically responds within a few hours.'.tr();
  static String get frequentlyAskedQuestions =>
      'Frequently Asked Questions'.tr();
  static String get searchQuestions => 'Search questions...'.tr();
  static String get general => 'General'.tr();
  static String get accountProfile => 'Account & Profile'.tr();
  static String get faqWhatIsPettix => 'What is Pettix?'.tr();
  static String get faqWhatIsPettixAnswer =>
      'Pettix is a comprehensive pet care platform that connects pet lovers, facilitates adoption, provides access to veterinary clinics, and offers an online store for pet supplies.'
          .tr();
  static String get faqAvailableAndroidIos =>
      'Is Pettix available on Android and iOS?'.tr();
  static String get faqAvailableAndroidIosAnswer =>
      'Yes! Pettix is available on both Android and iOS devices. Download it for free from the Google Play Store or the Apple App Store.'
          .tr();
  static String get faqFreeToUse => 'Is Pettix free to use?'.tr();
  static String get faqFreeToUseAnswer =>
      'Creating an account and browsing the platform is completely free. Some premium features and store purchases may require payment.'
          .tr();
  static String get faqCreateAccount => 'How do I create an account?'.tr();
  static String get faqCreateAccountAnswer =>
      'Tap "Sign Up" on the login screen, enter your email address, set a password, and verify your email with the OTP we send you.'
          .tr();
  static String get faqResetPassword => 'How do I reset my password?'.tr();
  static String get faqResetPasswordAnswer =>
      'Tap "Forgot Password?" on the login screen, enter your email, and follow the instructions in the email we send you.'
          .tr();
  static String get faqUpdateProfile =>
      'How do I update my profile information?'.tr();
  static String get faqUpdateProfileAnswer =>
      'Go to your Profile from the menu, tap the pen icon on your avatar or open the drawer and select "Edit Profile".'
          .tr();
  static String get faqDeleteAccount => 'Can I delete my account?'.tr();
  static String get faqDeleteAccountAnswer =>
      'Yes. Go to Settings > Account > Delete Account. Note that this action is permanent and all your data will be removed.'
          .tr();
  static String get faqAdoptPet => 'How do I adopt a pet?'.tr();
  static String get faqAdoptPetAnswer =>
      'Browse the Adoption section, find a pet you like, and tap "Apply". Fill in the adoption form and wait for approval from the owner.'
          .tr();
  static String get faqTrackAdoption =>
      'How can I track my adoption application?'.tr();
  static String get faqTrackAdoptionAnswer =>
      'Go to Adoption > My Applications to see the status of all your submitted adoption requests.'
          .tr();
  static String get faqListPetForAdoption =>
      'Can I list my pet for adoption?'.tr();
  static String get faqListPetForAdoptionAnswer =>
      'Yes. In the Adoption section, tap the "+" button and fill in your pet\'s details, photos, and requirements for potential adopters.'
          .tr();
  static String get faqPlaceOrder => 'How do I place an order?'.tr();
  static String get faqPlaceOrderAnswer =>
      'Browse the Store, add items to your cart, select your delivery address, and confirm your payment.'
          .tr();
  static String get faqPaymentMethods =>
      'What payment methods are accepted?'.tr();
  static String get faqPaymentMethodsAnswer =>
      'We accept credit/debit cards, mobile wallets, and cash on delivery (where available).'
          .tr();
  static String get faqReturnProduct => 'How do I return a product?'.tr();
  static String get faqReturnProductAnswer =>
      'You can return most products within 14 days of delivery. Go to My Orders, select the item, and tap "Request Return".'
          .tr();
  static String get noResultsFound => 'No results found'.tr();
  static String get tryDifferentSearchTerm =>
      'Try a different search term'.tr();
  static String get messageSentSupport =>
      'Message sent! We\'ll get back to you shortly.'.tr();
  static String get reachUsDirectly => 'Reach us directly'.tr();
  static String get liveChat => 'Live Chat'.tr();
  static String get liveChatSubtitle =>
      'Available 9 AM - 6 PM - Typically replies in minutes'.tr();
  static String get chatNow => 'Chat Now'.tr();
  static String get emailSupport => 'Email Support'.tr();
  static String get emailSupportSubtitle =>
      'support@pettix.com - Response within 24 hours'.tr();
  static String get sendEmail => 'Send Email'.tr();
  static String get phoneSupport => 'Phone Support'.tr();
  static String get phoneSupportSubtitle =>
      '+20 100 000 0000 - Sun - Thu, 10 AM - 5 PM'.tr();
  static String get call => 'Call'.tr();
  static String get sendUsMessage => 'Send us a message'.tr();
  static String get subject => 'Subject'.tr();
  static String get message => 'Message'.tr();
  static String get briefIssueSummary => 'Brief summary of your issue'.tr();
  static String get describeIssueQuestion =>
      'Describe your issue or question...'.tr();
  static String get sendMessage => 'Send Message'.tr();
  static String get appCrash => 'App Crash'.tr();
  static String get featureIssue => 'Feature Issue'.tr();
  static String get performance => 'Performance'.tr();
  static String get uiDisplay => 'UI / Display'.tr();
  static String get accountLogin => 'Account / Login'.tr();
  static String get payments => 'Payments'.tr();
  static String get other => 'Other'.tr();
  static String get fillTitleDescription =>
      'Please fill in the title and description.'.tr();
  static String get reportSubmittedThanks =>
      'Report submitted! Thank you for helping us improve.'.tr();
  static String get problemCategory => 'Problem Category'.tr();
  static String get problemTitle => 'Problem Title'.tr();
  static String get describeProblem => 'Describe the Problem'.tr();
  static String get whatHappenedHint =>
      'What happened? What were you trying to do?'.tr();
  static String get stepsToReproduceOptional =>
      'Steps to Reproduce (optional)'.tr();
  static String get stepsToReproduceHint =>
      '1. Open the app\n2. Tap on...\n3. The error appears...'.tr();
  static String get submitReport => 'Submit Report'.tr();
  static String get appVersion => 'App Version'.tr();
  static String get platform => 'Platform'.tr();
  static String get osBuild => 'OS Build'.tr();
  static String get android => 'Android'.tr();
  static String get ios => 'iOS'.tr();
  static String get deviceInfoAutoDetected =>
      'DEVICE INFO (auto-detected)'.tr();
  static String get featureRequest => 'Feature Request'.tr();
  static String get bugReport => 'Bug Report'.tr();
  static String get uxDesign => 'UX / Design'.tr();
  static String get improvement => 'Improvement'.tr();
  static String get selectArea => 'Select an area'.tr();
  static String get homeFeed => 'Home Feed'.tr();
  static String get chat => 'Chat'.tr();
  static String get profile => 'Profile'.tr();
  static String get writeFeedbackBeforeSubmitting =>
      'Please write your feedback before submitting.'.tr();
  static String get thankYouForFeedback => 'Thank you for your feedback!'.tr();
  static String get poor => 'Poor'.tr();
  static String get fair => 'Fair'.tr();
  static String get good => 'Good'.tr();
  static String get veryGood => 'Very Good'.tr();
  static String get excellent => 'Excellent'.tr();
  static String get whatTypeFeedback => 'What type of feedback?'.tr();
  static String get rateExperience =>
      'How would you rate your experience?'.tr();
  static String get tapStarRate => 'Tap a star to rate'.tr();
  static String get whichAreaOfApp => 'Which area of the app?'.tr();
  static String get yourFeedback => 'Your Feedback'.tr();
  static String get feedbackHint =>
      'Tell us what you think, what you\'d like to see, or how we can improve...'
          .tr();
  static String get followUpWithMe => 'Follow up with me'.tr();
  static String get followUpDescription =>
      'We\'ll reach out if we have questions about your feedback'.tr();

  // Legal
  static String get appName => 'Pettix'.tr();
  static String get aboutPettix => 'About Pettix'.tr();
  static String get aboutPettixSubtitle =>
      'Our mission, features, and contact info'.tr();
  static String get privacyPolicyTitle => 'Privacy Policy'.tr();
  static String get privacyPolicySubtitle =>
      'How we collect and protect your data'.tr();
  static String get termsConditionsSubtitle =>
      'Rules and guidelines for using Pettix'.tr();
  static String get refundPolicySubtitle =>
      'Returns, refunds, and shipping costs'.tr();
  static String get legalLastUpdatedDate => 'January 30, 2024'.tr();
  static String get ourMission => 'Our Mission'.tr();
  static String get ourMissionBody =>
      'Pettix is dedicated to connecting pet lovers, facilitating pet adoption, providing access to veterinary services, and offering a comprehensive marketplace for all your pet needs. We believe every pet deserves a loving home and proper care.'
          .tr();
  static String get features => 'Features'.tr();
  static String get shareMomentsCommunity =>
      'Share moments with the community'.tr();
  static String get findPetsForAdoption => 'Find pets for adoption'.tr();
  static String get accessEmergencyVetServices =>
      'Access emergency veterinary services'.tr();
  static String get shopVerifiedPetStores =>
      'Shop from verified pet stores'.tr();
  static String get connectOtherPetOwners =>
      'Connect with other pet owners'.tr();
  static String get contactUs => 'Contact Us'.tr();
  static String get supportEmail => 'support@pettix.com'.tr();
  static String get websiteUrl => 'www.pettix.com'.tr();
  static String get informationWeCollect => 'Information We Collect'.tr();
  static String get informationWeCollectBody =>
      'We collect information you provide directly, such as your name, email address, phone number, and profile photo when you create an account. We also collect usage data, device information, and location data (when you grant permission) to improve our services and personalize your experience.'
          .tr();
  static String get howWeUseInformation => 'How We Use Your Information'.tr();
  static String get howWeUseInformationBody =>
      'We use the information we collect to provide, maintain, and improve our services, process transactions, send notifications, personalize your experience, and communicate with you about updates, promotions, and support.'
          .tr();
  static String get informationSharing => 'Information Sharing'.tr();
  static String get informationSharingBody =>
      'We do not sell your personal information. We may share your information with service providers who assist us in operating our platform, complying with legal obligations, or protecting our rights. We ensure all third parties adhere to appropriate data protection standards.'
          .tr();
  static String get dataSecurity => 'Data Security'.tr();
  static String get dataSecurityBody =>
      'We implement industry-standard security measures including encryption, secure servers, and regular audits to protect your personal information from unauthorized access, alteration, disclosure, or destruction.'
          .tr();
  static String get yourRights => 'Your Rights'.tr();
  static String get yourRightsBody =>
      'You have the right to access, update or delete your personal information at any time through your account settings. You may also request a copy of your data or withdraw consent for certain data processing activities.'
          .tr();
  static String get cookiesTracking => 'Cookies & Tracking'.tr();
  static String get cookiesTrackingBody =>
      'We use cookies and similar tracking technologies to enhance your experience on our platform. You can control cookie preferences through your browser settings. Some features may not function properly if you disable cookies.'
          .tr();
  static String get changesToPolicy => 'Changes to This Policy'.tr();
  static String get changesToPolicyBody =>
      'We may update this Privacy Policy from time to time. We will notify you of any significant changes via email or a prominent notice in the app. Continued use of Pettix after changes constitutes your acceptance of the updated policy.'
          .tr();
  static String get acceptanceOfTerms => 'Acceptance of Terms'.tr();
  static String get acceptanceOfTermsBody =>
      'By accessing and using Pettix, you accept and agree to be bound by these Terms and Conditions. If you do not agree to these terms, please do not use our platform.'
          .tr();
  static String get userAccounts => 'User Accounts'.tr();
  static String get userAccountsBody =>
      'You are responsible for maintaining the confidentiality of your account credentials. You agree to accept responsibility for all activities that occur under your account and to notify us immediately of any unauthorized use.'
          .tr();
  static String get prohibitedActivities => 'Prohibited Activities'.tr();
  static String get prohibitedActivitiesBody =>
      'You may not use Pettix for any illegal or unauthorized purpose. Prohibited activities include posting false information, impersonating others, spreading harmful content, attempting to breach security, or engaging in any activity that violates applicable laws.'
          .tr();
  static String get intellectualProperty => 'Intellectual Property'.tr();
  static String get intellectualPropertyBody =>
      'All content, trademarks, and software on Pettix are the property of Pettix or its content suppliers and are protected by copyright and intellectual property laws. Unauthorized use is strictly prohibited.'
          .tr();
  static String get limitationOfLiability => 'Limitation of Liability'.tr();
  static String get limitationOfLiabilityBody =>
      'Pettix shall not be liable for any indirect, incidental, special, or consequential damages arising out of or in connection with your use of our services. Our liability is limited to the maximum extent permitted by law.'
          .tr();
  static String get termination => 'Termination'.tr();
  static String get terminationBody =>
      'We reserve the right to suspend or terminate your account at any time for violations of these terms or for any other reason at our sole discretion. You may also delete your account at any time through the app settings.'
          .tr();
  static String get governingLaw => 'Governing Law'.tr();
  static String get governingLawBody =>
      'These Terms shall be governed by and construed in accordance with applicable laws. Any disputes arising under these terms shall be subject to the exclusive jurisdiction of competent courts.'
          .tr();
  static String get returnWindow => 'Return Window'.tr();
  static String get returnWindowBody =>
      'You may return most items within 14 days of delivery for a full refund. Items must be unused, in the same condition you received them, and in their original packaging to qualify for a return.'
          .tr();
  static String get refundProcess => 'Refund Process'.tr();
  static String get refundProcessBody =>
      'Once we receive your returned item, we will inspect it and process your refund within 5-7 business days. Refunds are issued to the original payment method used at the time of purchase.'
          .tr();
  static String get nonRefundableItems => 'Non-Refundable Items'.tr();
  static String get nonRefundableItemsBody =>
      'Certain items are non-refundable, including perishable goods (food, treats), hygiene products, custom-made items, and digital products once downloaded or activated.'
          .tr();
  static String get shippingCosts => 'Shipping Costs'.tr();
  static String get shippingCostsBody =>
      'Original shipping costs are non-refundable. Return shipping costs are the responsibility of the customer unless the item is defective, damaged, or was sent incorrectly.'
          .tr();
  static String get damagedDefectiveItems => 'Damaged or Defective Items'.tr();
  static String get damagedDefectiveItemsBody =>
      'If you receive a damaged or defective item, please contact us immediately with photos. We will provide a free replacement or a full refund including shipping costs at no additional charge to you.'
          .tr();
  static String get orderCancellations => 'Order Cancellations'.tr();
  static String get orderCancellationsBody =>
      'Orders can be cancelled within 2 hours of placement for a full refund. Once the order has been processed and shipped, cancellations are no longer possible and the standard return process applies.'
          .tr();

  static String versionNumber(String version) =>
      'Version {version}'.tr(namedArgs: {'version': version});

  static String copyright(String year) =>
      '(c) {year} Pettix. All rights reserved.'.tr(namedArgs: {'year': year});

  static String lastUpdated(String date) =>
      'Last updated: {date}'.tr(namedArgs: {'date': date});
}

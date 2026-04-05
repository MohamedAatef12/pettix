enum UserRole {
  admin(1),
  seller(2),
  clinic(3),
  user(4);

  const UserRole(this.value);
  final int value;

  static UserRole? fromValue(int? v) =>
      v == null ? null : UserRole.values.firstWhere((e) => e.value == v, orElse: () => UserRole.user);
}

enum UserStatus {
  active(1),
  inactive(2),
  frozen(3),
  deleted(4);

  const UserStatus(this.value);
  final int value;

  static UserStatus? fromValue(int? v) =>
      v == null ? null : UserStatus.values.firstWhere((e) => e.value == v, orElse: () => UserStatus.active);
}

enum PostsStatus {
  draft(1),
  scheduled(2),
  published(3),
  blocked(4),
  deleted(5),
  private(6),
  promoted(7),
  processing(8),
  failed(9);

  const PostsStatus(this.value);
  final int value;

  static PostsStatus? fromValue(int? v) =>
      v == null ? null : PostsStatus.values.firstWhere((e) => e.value == v, orElse: () => PostsStatus.draft);
}

enum ReportReasonEnum {
  spamOrScam(1),
  fakeNewsOrMisinformation(2),
  hateSpeech(3),
  harassmentOrBullying(4),
  violenceOrThreats(5),
  sexualContent(6),
  childExploitation(7),
  selfHarmOrSuicide(8),
  illegalProductsOrDrugs(9),
  copyrightViolation(10),
  impersonationOrFakeAccount(11),
  fraudOrFinancialScam(12),
  animalAbuse(13),
  offensiveContent(14),
  other(15);

  const ReportReasonEnum(this.value);
  final int value;

  static ReportReasonEnum? fromValue(int? v) =>
      v == null ? null : ReportReasonEnum.values.firstWhere((e) => e.value == v, orElse: () => ReportReasonEnum.other);
}

enum CommentStatus {
  published(1),
  edited(2),
  deleted(3),
  blocked(4);

  const CommentStatus(this.value);
  final int value;

  static CommentStatus? fromValue(int? v) =>
      v == null ? null : CommentStatus.values.firstWhere((e) => e.value == v, orElse: () => CommentStatus.published);
}

enum ImageFileState {
  none(0),
  newFile(1),
  modified(2),
  deleted(3);

  const ImageFileState(this.value);
  final int value;

  static ImageFileState fromValue(int v) =>
      ImageFileState.values.firstWhere((e) => e.value == v, orElse: () => ImageFileState.none);
}

enum NotificationType {
  timeline(1),
  store(2),
  clinic(3),
  emergency(4),
  adoption(5);

  const NotificationType(this.value);
  final int value;

  static NotificationType? fromValue(int? v) =>
      v == null ? null : NotificationType.values.firstWhere((e) => e.value == v, orElse: () => NotificationType.timeline);
}

enum AdoptionFormStatus {
  pending(1),
  approved(2),
  rejected(3),
  cancelled(4);

  const AdoptionFormStatus(this.value);
  final int value;

  static AdoptionFormStatus? fromValue(int? v) =>
      v == null ? null : AdoptionFormStatus.values.firstWhere((e) => e.value == v, orElse: () => AdoptionFormStatus.pending);
}

enum PetAdoptionStatus {
  private(0),
  available(1);

  const PetAdoptionStatus(this.value);
  final int value;

  static PetAdoptionStatus? fromValue(int? v) =>
      v == null ? null : PetAdoptionStatus.values.firstWhere((e) => e.value == v, orElse: () => PetAdoptionStatus.private);
}

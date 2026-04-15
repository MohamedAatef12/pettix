import 'package:equatable/equatable.dart';

class ChatUserEntity extends Equatable {
  final int id;
  final String nameAr;
  final String nameEn;
  final String avatar;
  final String email;

  const ChatUserEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.avatar,
    required this.email,
  });

  String get displayName => nameEn.isNotEmpty ? nameEn : nameAr;

  @override
  List<Object?> get props => [id, nameAr, nameEn, avatar, email];
}

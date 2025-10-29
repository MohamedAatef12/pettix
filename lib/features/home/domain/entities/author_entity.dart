import 'package:equatable/equatable.dart';

class AuthorEntity extends Equatable {
  final int id;
  final String? nameAr;
  final String? nameEn;
  final String? avatar;
  final String? email;
  final String? phone;
  final int? genderId;
  final String? genderName;
  final int? contactTypeId;
  final int? statusId;
  final int? age;

  const AuthorEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.avatar,
    required this.email,
    required this.phone,
    required this.genderId,
    required this.genderName,
    required this.contactTypeId,

    required this.statusId,

    required this.age,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    phone,
    nameAr,
    nameEn,
    avatar,
    genderId,
    genderName,
    contactTypeId,
    statusId,
    age,
  ];
}

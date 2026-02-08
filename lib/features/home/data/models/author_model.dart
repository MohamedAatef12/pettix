import 'package:pettix/features/home/domain/entities/author_entity.dart';

class AuthorModel extends AuthorEntity {
  const AuthorModel({
    required super.id,
    required super.email,
    required super.nameAr,
    required super.nameEn,
    required super.phone,
    required super.genderId,
    required super.genderName,
    required super.contactTypeId,
    required super.statusId,
    required super.avatar,
    required super.age,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'] as int,
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      avatar: json['avatar'] ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      genderId: json['genderId'] as int?,
      genderName: json['genderName'] as String?,
      contactTypeId: json['contactTypeId'] as int?,
      statusId: json['statusId'] as int?,
      age: json['age'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'genderId': genderId,
      'genderName': genderName,
      'contactTypeId': contactTypeId,
      'statusId': statusId,
      'avatar': avatar,
      'age': age,
    };
  }

  AuthorModel.fromEntity(AuthorEntity author)
    : super(
        id: author.id,
        email: author.email,
        phone: author.phone,
        nameAr: author.nameAr,
        nameEn: author.nameEn,
        statusId: author.statusId,
        contactTypeId: author.contactTypeId,
        avatar: author.avatar,
        age: author.age,
        genderId: author.genderId,
        genderName: author.genderName,
      );

  AuthorEntity toEntity(AuthorModel model) => AuthorEntity(
    id: id,
    email: email,
    phone: phone,
    nameAr: nameAr,
    nameEn: nameEn,
    statusId: statusId,
    contactTypeId: contactTypeId,
    avatar: avatar,
    age: age,
    genderId: genderId,
    genderName: genderName,
  );
}

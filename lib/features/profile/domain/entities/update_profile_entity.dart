import 'package:equatable/equatable.dart';

class AvatarEntity extends Equatable {
  final String filename;
  final String base64;
  final int state; // 0=unchanged, 1=new, 2=deleted

  const AvatarEntity({
    required this.filename,
    required this.base64,
    required this.state,
  });

  @override
  List<Object?> get props => [filename, base64, state];
}

class UpdateProfileEntity extends Equatable {
  final int id;
  final String? nameAr;
  final String? nameEn;
  final AvatarEntity? avatar;
  final int? genderId;
  final int? contactTypeId;
  final int? statusId;
  final int? age;
  final String? address;

  const UpdateProfileEntity({
    required this.id,
    this.nameAr,
    this.nameEn,
    this.avatar,
    this.genderId,
    this.contactTypeId,
    this.statusId,
    this.age,
    this.address,
  });

  @override
  List<Object?> get props => [
    id,
    nameAr,
    nameEn,
    avatar,
    genderId,
    contactTypeId,
    statusId,
    age,
    address,
  ];
}

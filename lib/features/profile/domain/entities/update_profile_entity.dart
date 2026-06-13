import 'package:equatable/equatable.dart';
import 'package:pettix/core/enums/app_enums.dart';

class AvatarEntity extends Equatable {
  final String filename;
  final String base64;
  final ImageFileState state;

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
  final String? phone;

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
    this.phone,
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
    phone,
  ];
}

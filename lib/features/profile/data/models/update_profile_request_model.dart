import 'package:pettix/features/profile/domain/entities/update_profile_entity.dart';

class AvatarModel extends AvatarEntity {
  const AvatarModel({
    required super.filename,
    required super.base64,
    required super.state,
  });

  Map<String, dynamic> toJson() => {
    'filename': filename,
    'base64': base64,
    'state': state.value,
  };

  factory AvatarModel.fromEntity(AvatarEntity entity) => AvatarModel(
    filename: entity.filename,
    base64: entity.base64,
    state: entity.state,
  );
}

class UpdateProfileRequestModel extends UpdateProfileEntity {
  const UpdateProfileRequestModel({
    required super.id,
    super.nameAr,
    super.nameEn,
    super.avatar,
    super.genderId,
    super.contactTypeId,
    super.statusId,
    super.age,
    super.address,
    super.phone,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'genderId': genderId,
      'contactTypeId': contactTypeId,
      'statusId': statusId,
      'age': age,
      'address': address,
      'phone': phone,
    };
    if (avatar != null) {
      map['avatar'] = (avatar as AvatarModel).toJson();
    }
    return map;
  }

  factory UpdateProfileRequestModel.fromEntity(UpdateProfileEntity entity) {
    return UpdateProfileRequestModel(
      id: entity.id,
      nameAr: entity.nameAr,
      nameEn: entity.nameEn,
      avatar: entity.avatar != null
          ? AvatarModel(
              filename: entity.avatar!.filename,
              base64: entity.avatar!.base64,
              state: entity.avatar!.state,
            )
          : null,
      genderId: entity.genderId,
      contactTypeId: entity.contactTypeId,
      statusId: entity.statusId,
      age: entity.age,
      address: entity.address,
      phone: entity.phone,
    );
  }
}

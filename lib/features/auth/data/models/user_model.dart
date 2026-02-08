import 'package:pettix/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.userName,
    super.nameAr,
    super.nameEn,
    super.avatar,
    super.image,
    super.phone,
    super.country,
    super.city,
    super.age,
    super.gender,
    super.address,
    super.idImage,
    super.prefixID,
    super.googleId,
    super.password,
    super.genderId,
    super.contactTypeId,
    super.statusId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['contact'] is Map<String, dynamic>
        ? json['contact'] as Map<String, dynamic>
        : json;

    return UserModel(
      id: data['id'] is int
          ? data['id']
          : int.tryParse(data['id']?.toString() ?? '') ?? 0,
      email: data['email'] ?? '',
      userName: data['userName'] ?? data['nameEn'] ?? '',
      nameAr: data['nameAr'],
      nameEn: data['nameEn'],
      avatar: data['avatar'],
      image: data['image'],
      phone: data['phone'],
      country: data['country'],
      city: data['city'],
      age: data['age'] != null
          ? (data['age'] is int
          ? data['age']
          : int.tryParse(data['age'].toString()))
          : null,
      gender: data['gender'],
      address: data['address'],
      idImage: data['idImage'],
      prefixID: data['prefixID'],
      googleId: data['googleId'],
      password: data['password'],
      genderId: data['genderId'],
      contactTypeId: data['contactTypeId'],
      statusId: data['statusId'],
    );
  }
  factory UserModel.merge({
    required UserModel oldUser,
    required Map<String, dynamic> newJson,
  }) {
    return UserModel(
      id: newJson['id'] != null
          ? (newJson['id'] is int
          ? newJson['id']
          : int.tryParse(newJson['id'].toString()) ?? oldUser.id)
          : oldUser.id,
      email: newJson['email'] ?? oldUser.email,
      userName: newJson['userName'] ?? oldUser.userName,
      image: newJson['image'] ?? oldUser.image,
      phone: newJson['phone'] ?? oldUser.phone,
      country: newJson['country'] ?? oldUser.country,
      city: newJson['city'] ?? oldUser.city,
      age: newJson['age'] != null
          ? (newJson['age'] is int
          ? newJson['age']
          : int.tryParse(newJson['age'].toString()) ?? oldUser.age)
          : oldUser.age,
      gender: newJson['gender'] ?? oldUser.gender,
      address: newJson['address'] ?? oldUser.address,
      idImage: newJson['idImage'] ?? oldUser.idImage,
      prefixID: newJson['prefixID'] ?? oldUser.prefixID,
      googleId: newJson['googleId'] ?? oldUser.googleId,
      password: newJson['password'] ?? oldUser.password,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'userName': userName,
    'nameAr': nameAr,
    'nameEn': nameEn,
    'avatar': avatar,
    'image': image,
    'phone': phone,
    'country': country,
    'city': city,
    'age': age,
    'gender': gender,
    'address': address,
    'idImage': idImage,
    'prefixID': prefixID,
    'googleId': googleId,
    'password': password,
    'genderId': genderId,
    'contactTypeId': contactTypeId,
    'statusId': statusId,
  };

  UserModel.fromEntity(UserEntity entity)
      : super(
    id: entity.id,
    email: entity.email,
    userName: entity.userName,
    nameAr: entity.nameAr,
    nameEn: entity.nameEn,
    avatar: entity.avatar,
    image: entity.image,
    phone: entity.phone,
    country: entity.country,
    city: entity.city,
    age: entity.age,
    gender: entity.gender,
    address: entity.address,
    idImage: entity.idImage,
    prefixID: entity.prefixID,
    googleId: entity.googleId,
    password: entity.password,
    genderId: entity.genderId,
    contactTypeId: entity.contactTypeId,
    statusId: entity.statusId,
  );

  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    userName: userName,
    nameAr: nameAr,
    nameEn: nameEn,
    avatar: avatar,
    image: image,
    phone: phone,
    country: country,
    city: city,
    age: age,
    gender: gender,
    address: address,
    idImage: idImage,
    prefixID: prefixID,
    googleId: googleId,
    password: password,
    genderId: genderId,
    contactTypeId: contactTypeId,
    statusId: statusId,
  );
}

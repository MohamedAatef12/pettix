import 'package:pettix/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.userName,
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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {

    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      email: json['email'] ?? '',
      userName: json['userName'] ?? '',
      image: json['image'],
      phone: json['phone'],
      country: json['country'],
      city: json['city'],
      age: json['age'] != null
          ? (json['age'] is int
          ? json['age']
          : int.tryParse(json['age'].toString()))
          : null,
      gender: json['gender'],
      address: json['address'],
      idImage: json['idImage'],
      prefixID: json['prefixID'],
      googleId: json['googleId'],
      password: json['password'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userName': userName,
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
    };
  }

  UserModel.fromEntity(UserEntity entity)
      : super(
    id: entity.id,
    email: entity.email,
    userName: entity.userName,
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
  );

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      userName: userName,
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
    );
  }
}

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String userName;
  final String? image;
  final String? phone;
  final String? country;
  final String? city;
  final int? age;
  final String? gender;
  final String? address;
  final String? idImage;
  final String? prefixID;
  final String? googleId;
  final String? password;

  const UserEntity({
    required this.id,
    required this.email,
    required this.userName,
    this.image,
    this.phone,
    this.country,
    this.city,
    this.age,
    this.gender,
    this.address,
    this.idImage,
    this.prefixID,
    this.googleId,
    this.password,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    userName,
    image,
    phone,
    country,
    city,
    age,
    gender,
    address,
    idImage,
    prefixID,
    googleId,
    password
  ];
}

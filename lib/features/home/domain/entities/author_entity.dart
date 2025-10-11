import 'package:equatable/equatable.dart';

class AuthorEntity extends Equatable {
  final int id;
  final String email;
  final String password;
  final String phone;
  final String? country;
  final String? city;
  final String userName;
  final String? imageUrl;
  final int? age;
  final String? gender;
  final String? address;
  final String? idImage;

  const AuthorEntity({
    required this.id,
    required this.email,
    required this.password,
    required this.phone,
    this.country,
    this.city,
    required this.userName,
    this.imageUrl,
    this.age,
    this.gender,
    this.address,
    this.idImage,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        password,
        phone,
        country,
        city,
        userName,
        imageUrl,
        age,
        gender,
        address,
        idImage,
      ];
}

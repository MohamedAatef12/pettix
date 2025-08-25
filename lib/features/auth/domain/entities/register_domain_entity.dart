import 'package:equatable/equatable.dart';

class RegisterEntity extends Equatable {
  final int id;
  final String email;
  final String password;
  final String userName;
  final String phone;
  final String country;
  final String city;
  final String image;
  final String gender;
  final int age;
  final String address;
  final String idImage;
  final String? confirmPassword;
  final String? otp;

  const RegisterEntity({
    required this.id,
    required this.email,
    required this.password,
    required this.userName,
    required this.phone,
    required this.country,
    required this.city,
    required this.image,
    required this.gender,
    required this.age,
    required this.address,
    required this.idImage,
    this.confirmPassword,
    this.otp,
  });

  RegisterEntity copyWith({
    int? id,
    String? email,
    String? password,
    String? userName,
    String? phone,
    String? country,
    String? city,
    String? image,
    String? gender,
    int? age,
    String? address,
    String? idImage,
    String? confirmPassword,
    String? otp,
  }) {
    return RegisterEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      city: city ?? this.city,
      image: image ?? this.image,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      address: address ?? this.address,
      idImage: idImage ?? this.idImage,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      otp: otp ?? this.otp,
    );
  }

  @override
  List<Object?> get props => [
    id, email, password, userName, phone, country, city, image,
    gender, age, address, idImage, confirmPassword, otp
  ];
}

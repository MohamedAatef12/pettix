import 'package:pettix/features/auth/domain/entities/register_domain_entity.dart';

class RegisterModel extends RegisterEntity {
  const RegisterModel({
    required super.id,
    required super.email,
    required super.password,
    required super.userName,
    required super.phone,
    required super.country,
    required super.city,
    required super.image,
    required super.age,
    required super.address,
    required super.idImage,
    required super.gender,
    required super.confirmPassword,
    required super.otp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'password': password,
    'userName': userName,
    'phone': phone,
    'country': country,
    'city': city,
    'image': image,
    'age': age,
    'address': address,
    'idImage': idImage,
    'gender': gender,
    'confirmPassword': null,
    'otp': null,
  };
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      userName: json['userName'] ?? '',
      phone: json['phone'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      image: json['image'] ?? '',
      age: json['age'] ?? 0,
      address: json['address'] ?? '',
      idImage: json['idImage'] ?? '',
      gender: json['gender'] ?? '',
      confirmPassword: json['confirmPassword'],
      otp: json['otp'],
    );
  }
  RegisterModel.fromEntity(RegisterEntity entity)
    : super(
        id: entity.id,
        email: entity.email,
        password: entity.password,
        userName: entity.userName,
        phone: entity.phone,
        country: entity.country,
        city: entity.city,
        image: entity.image,
        age: entity.age,
        address: entity.address,
        idImage: entity.idImage,
        gender: entity.gender,
        confirmPassword: entity.confirmPassword,
        otp: entity.otp,
      );
  RegisterEntity toEntity(RegisterModel model) {
    return RegisterEntity(
      id: model.id,
      email: model.email,
      password: model.password,
      userName: model.userName,
      phone: model.phone,
      country: model.country,
      city: model.city,
      image: model.image,
      age: model.age,
      address: model.address,
      idImage: model.idImage,
      gender: model.gender,
      confirmPassword: model.confirmPassword,
      otp: model.otp,
    );
  }

  RegisterModel copyWith({
    int? id,
    String? email,
    String? password,
    String? userName,
    String? phone,
    String? country,
    String? city,
    String? image,
    int? age,
    String? address,
    String? idImage,
    String? gender,
    String? confirmPassword,
    String? otp,
  }) {
    return RegisterModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      userName: userName ?? this.userName,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      city: city ?? this.city,
      image: image ?? this.image,
      age: age ?? this.age,
      address: address ?? this.address,
      idImage: idImage ?? this.idImage,
      gender: gender ?? this.gender,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      otp: otp ?? this.otp,
    );
  }
}

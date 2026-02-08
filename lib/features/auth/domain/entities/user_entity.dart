import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String email;
  final String? nameAr;
  final String? nameEn;
  final String userName;
  final String? avatar;
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
  final int? genderId;
  final int? contactTypeId;
  final int? statusId;

  const UserEntity({
    required this.id,
    required this.email,
    required this.userName,
    this.nameAr,
    this.nameEn,
    this.avatar,
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
    this.genderId,
    this.contactTypeId,
    this.statusId,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    userName,
    nameAr,
    nameEn,
    avatar,
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
    password,
    genderId,
    contactTypeId,
    statusId,
  ];

  /// ✅ Handles both cases: JSON containing `contact` object or not.
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    final data = json['contact'] is Map<String, dynamic>
        ? json['contact'] as Map<String, dynamic>
        : json;

    return UserEntity(
      id: data['id'] ?? 0,
      email: data['email'] ?? '',
      userName: data['nameEn'] ?? data['userName'] ?? '',
      nameAr: data['nameAr'],
      nameEn: data['nameEn'],
      avatar: data['avatar'],
      image: data['image'],
      phone: data['phone'],
      country: data['country'],
      city: data['city'],
      age: data['age'],
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

  Map<String, dynamic> toJson() {
    return {
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
  }
}

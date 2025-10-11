
import 'package:pettix/features/home/domain/entities/author_entity.dart';

class AuthorModel extends AuthorEntity {
  const AuthorModel({
    required super.id,
    required super.email,
    required super.password,
    required super.phone,
    required super.country,
    required super.city,
    required super.userName,
    required super.imageUrl,
    super.age,
    super.address,
    super.gender,
    super.idImage,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'] as int,
      email: json['email'] as String,
      password: json['password'] as String,
      phone: json['phone'] as String,
      country: json['country'] as String,
      city: json['city'] as String,
      userName: json['userName'] as String,
      imageUrl: json['image'] as String? ?? '',
      age: json['age'] as int?,
      address: json['address'] as String,
      gender: json['gender'] as String?,
      idImage: json['idImage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'phone': phone,
      'country': country,
      'city': city,
      'userName': userName,
      'image': imageUrl,
      'age': age,
      'address': address,
      'gender': gender,
      'idImage': idImage,
    };
  }

  AuthorModel.fromEntity(AuthorEntity author)
      : super(
          id: author.id,
          email: author.email,
          password: author.password,
          phone: author.phone,
          country: author.country,
          city: author.city,
          userName: author.userName,
          imageUrl: author.imageUrl,
          age: author.age,
          address: author.address,
          gender: author.gender,
          idImage: author.idImage,
        );

  AuthorEntity toEntity(AuthorModel model) => AuthorEntity(
        id: id,
        email: email,
        password: password,
        phone: phone,
        country: country,
        city: city,
        userName: userName,
        imageUrl: imageUrl,
        age: age,
        address: address,
        gender: gender,
        idImage: idImage,
      );
}

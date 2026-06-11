import 'package:pettix/features/help_support/domain/entities/contact_support_entity.dart';

class ContactSupportRequestModel extends ContactSupportEntity {
  const ContactSupportRequestModel({
    required super.subject,
    required super.message,
  });

  Map<String, dynamic> toJson() => {'subject': subject, 'message': message};

  factory ContactSupportRequestModel.fromEntity(ContactSupportEntity entity) {
    return ContactSupportRequestModel(
      subject: entity.subject,
      message: entity.message,
    );
  }
}

import 'package:equatable/equatable.dart';

class ContactSupportEntity extends Equatable {
  final String subject;
  final String message;

  const ContactSupportEntity({required this.subject, required this.message});

  @override
  List<Object?> get props => [subject, message];
}

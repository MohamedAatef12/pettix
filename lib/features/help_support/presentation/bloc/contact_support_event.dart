import 'package:equatable/equatable.dart';
import 'package:pettix/features/help_support/domain/entities/contact_support_entity.dart';

abstract class ContactSupportEvent extends Equatable {
  const ContactSupportEvent();

  @override
  List<Object?> get props => [];
}

class SubmitContactSupportEvent extends ContactSupportEvent {
  final ContactSupportEntity contactSupport;

  const SubmitContactSupportEvent(this.contactSupport);

  @override
  List<Object?> get props => [contactSupport];
}

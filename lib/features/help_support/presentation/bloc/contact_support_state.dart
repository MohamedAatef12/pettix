import 'package:equatable/equatable.dart';

enum ContactSupportStatus { initial, loading, success, error }

class ContactSupportState extends Equatable {
  final ContactSupportStatus status;
  final String? errorMessage;

  const ContactSupportState({
    this.status = ContactSupportStatus.initial,
    this.errorMessage,
  });

  ContactSupportState copyWith({
    ContactSupportStatus? status,
    String? errorMessage,
  }) {
    return ContactSupportState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

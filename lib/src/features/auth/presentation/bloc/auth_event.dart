import 'package:equatable/equatable.dart';
import '../../data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

class AuthStatusChanged extends AuthEvent {
  final UserModel? user;
  const AuthStatusChanged(this.user);
  @override
  List<Object?> get props => [user];
}

class UpdateUserProfile extends AuthEvent {
  final String? displayName;
  final String? phoneNumber;
  final String? dateOfBirth;

  const UpdateUserProfile({
    this.displayName,
    this.phoneNumber,
    this.dateOfBirth,
  });

  @override
  List<Object?> get props => [displayName, phoneNumber, dateOfBirth];
}

part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested({required this.email, required this.password});
}

class RegisterRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String? phone;
  final String? position;
  final String country;

  RegisterRequested({
    required this.username,
    required this.email,
    required this.password,
    this.phone,
    this.position,
    required this.country,
  });
}

class CheckAuthStatus extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

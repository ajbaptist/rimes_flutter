part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String? token;
  final Map user;
  AuthSuccess({this.token, required this.user});

  @override
  List<Object?> get props => [token, user];
}

class AuthFailed extends AuthState {
  final String error;
  AuthFailed({required this.error});

  @override
  List<Object?> get props => [error];
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rimes_flutter/services/notification_service.dart';
import '../../services/api_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthBloc({required this.apiService}) : super(AuthInitial()) {
    on<LoginRequested>(_onLogin);

    on<RegisterRequested>(_onRegister);

    on<CheckAuthStatus>(_onCheckAuthStatus);

    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onLogin(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final String token = await NotificationService.getToken() ?? "";
      final res = await apiService.post('/auth/login',
          {'email': event.email, 'password': event.password, 'token': token});

      if (res['token'] != null) {
        await _secureStorage.write(key: "token", value: res['token']);
        emit(AuthSuccess(token: res['token'], user: res['user']));
      } else {
        emit(AuthFailed(error: res['error'] ?? 'Unknown error'));
      }
    } catch (e) {
      emit(AuthFailed(error: e.toString()));
    }
  }

  Future<void> _onRegister(
      RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final res = await apiService.post('/auth/register', {
        'username': event.username,
        'email': event.email,
        'phone': event.phone,
        'position': event.position,
        'country': event.country,
        'password': event.password,
      });

      if (res['success'] == true) {
        add(LoginRequested(email: event.email, password: event.password));
      } else {
        emit(AuthFailed(error: res['error'] ?? 'Registration failed'));
      }
    } catch (e) {
      emit(AuthFailed(error: e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatus event, Emitter<AuthState> emit) async {
    final token = await _secureStorage.read(key: "token");
    if (token != null) {
      emit(AuthSuccess(token: token, user: {}));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _onLogout(LogoutRequested event, Emitter<AuthState> emit) async {
    await _secureStorage.delete(key: "token");
    emit(AuthInitial());
  }
}

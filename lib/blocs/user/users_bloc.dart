import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rimes_flutter/blocs/user/users_event.dart';
import 'package:rimes_flutter/blocs/user/users_state.dart';
import 'package:rimes_flutter/repositories/user_repository.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final UserRepository repository;

  UserProfileBloc(this.repository) : super(UserProfileInitial()) {
    on<FetchUserProfile>((event, emit) async {
      emit(UserProfileLoading());
      try {
        final user = await repository.fetchUserProfile(event.userId);
        emit(UserProfileLoaded(user));
      } catch (e) {
        emit(UserProfileError(e.toString()));
      }
    });
  }
}

import 'package:equatable/equatable.dart';

abstract class UserProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserProfile extends UserProfileEvent {
  final String userId;
  FetchUserProfile(this.userId);

  @override
  List<Object?> get props => [userId];
}

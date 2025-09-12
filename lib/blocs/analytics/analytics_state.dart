import 'package:equatable/equatable.dart';
import '../../models/analytics_model.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final AnayticsModel analyticsData;

  const AnalyticsLoaded({required this.analyticsData});

  @override
  List<Object?> get props => [analyticsData];
}

class AnalyticsError extends AnalyticsState {
  final String error;

  const AnalyticsError(this.error);

  @override
  List<Object?> get props => [error];
}

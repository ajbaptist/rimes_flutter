import 'package:equatable/equatable.dart';
import 'package:rimes_flutter/models/article_model.dart';

abstract class ArticleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ArticleInitial extends ArticleState {}

class ArticleLoading extends ArticleState {}

class ArticleLoaded extends ArticleState {
  final List<Article> articles;
  ArticleLoaded({required this.articles});

  @override
  List<Object?> get props => [articles];
}

class ArticleError extends ArticleState {
  final String error;
  ArticleError({required this.error});

  @override
  List<Object?> get props => [error];
}

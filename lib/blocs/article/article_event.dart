import 'package:equatable/equatable.dart';

abstract class ArticleEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadArticles extends ArticleEvent {}

class CreateArticle extends ArticleEvent {
  final String title;
  final String body;
  CreateArticle({required this.title, required this.body});
}

class UpdateArticle extends ArticleEvent {
  final String id;
  final String title;
  final String body;
  UpdateArticle({required this.id, required this.title, required this.body});
}

class DeleteArticle extends ArticleEvent {
  final String id;
  DeleteArticle({required this.id});
}

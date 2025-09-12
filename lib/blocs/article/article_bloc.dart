import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rimes_flutter/models/article_model.dart';
import 'article_event.dart';
import 'article_state.dart';
import '../../repositories/article_repository.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final ArticleRepository repo;

  ArticleBloc({required this.repo}) : super(ArticleInitial()) {
    on<LoadArticles>(_onLoadArticles);
    on<CreateArticle>(_onCreateArticle);
    on<UpdateArticle>(_onUpdateArticle);
    on<DeleteArticle>(_onDeleteArticle);
  }

  Future<void> _onLoadArticles(
      LoadArticles event, Emitter<ArticleState> emit) async {
    emit(ArticleLoading());
    try {
      final List<Article> articles = await repo.fetchArticles();
      emit(ArticleLoaded(articles: articles));
    } catch (e) {
      emit(ArticleError(error: e.toString()));
    }
  }

  Future<void> _onCreateArticle(
      CreateArticle event, Emitter<ArticleState> emit) async {
    await repo.createArticle(title: event.title, body: event.body);
    add(LoadArticles());
  }

  Future<void> _onUpdateArticle(
      UpdateArticle event, Emitter<ArticleState> emit) async {
    await repo.updateArticle(
        id: event.id, title: event.title, body: event.body);
    add(LoadArticles());
  }

  Future<void> _onDeleteArticle(
      DeleteArticle event, Emitter<ArticleState> emit) async {
    add(LoadArticles());
  }
}

import 'package:rimes_flutter/db/database_helper.dart';
import 'package:rimes_flutter/models/article_model.dart';
import '../services/api_service.dart';

class ArticleRepository {
  final ApiService api;
  ArticleRepository({required this.api});

  Future<List<Article>> fetchArticles() async {
    try {
      final res = await api.get("/api/articles");
      final articles = (res as List).map((e) => Article.fromJson(e)).toList();

      for (final a in articles) {
        DatabaseHelper.instance.insertArticle(a);
      }

      return articles;
    } catch (_) {
      final rows = await DatabaseHelper.instance.getArticles();
      return rows;
    }
  }

  Future<void> createArticle(
      {required String title, required String body}) async {
    try {
      await api.post("/api/articles", {"title": title, "body": body});
    } catch (e) {}
  }

  Future<void> updateArticle(
      {required String id,
      required String title,
      required String body}) async {}
}

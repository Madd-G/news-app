import 'package:news_app/core/errors/errors.dart';
import 'package:news_app/src/data/datasources/db/database_helper.dart';
import 'package:news_app/src/data/models/article_table.dart';

abstract class ArticleLocalDataSource {
  Future<String> insertBookmarkArticle(ArticleTable article);

  Future<String> removeBookmarkArticle(ArticleTable article);

  Future<ArticleTable?> getArticleByUrl(String url);

  Future<List<ArticleTable>> getBookmarkArticles();

  Future<void> cacheArticles(List<ArticleTable> articles);

  Future<List<ArticleTable>> getCachedArticles();

  Future<List<ArticleTable>> searchLocalArticles(String query);
}

class ArticleLocalDataSourceImpl implements ArticleLocalDataSource {
  final DatabaseHelper databaseHelper;

  ArticleLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertBookmarkArticle(ArticleTable article) async {
    try {
      await databaseHelper.insertBookmarkArticle(article);
      return 'Added to Bookmark';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeBookmarkArticle(ArticleTable article) async {
    try {
      await databaseHelper.removeBookmarkArticle(article);
      return 'Removed from Bookmark';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<ArticleTable?> getArticleByUrl(String url) async {
    final result = await databaseHelper.getArticleByUrl(url);
    if (result != null) {
      return ArticleTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<ArticleTable>> getBookmarkArticles() async {
    final result = await databaseHelper.getBookmarkArticles();
    return result.map((data) => ArticleTable.fromMap(data)).toList();
  }

  @override
  Future<void> cacheArticles(List<ArticleTable> articles) async {
    await databaseHelper.clearCacheArticles('articles');
    await databaseHelper.insertCacheTransactionArticles(articles, 'articles');
  }

  @override
  Future<List<ArticleTable>> getCachedArticles() async {
    final result = await databaseHelper.getCacheArticles('articles');
    if (result.isNotEmpty) {
      return result.map((data) => ArticleTable.fromMap(data)).toList();
    } else {
      throw CacheException("Can't get the data");
    }
  }

  @override
  Future<List<ArticleTable>> searchLocalArticles(String query) async {
    final result = await databaseHelper.getCacheArticles('articles');

    if (result.isNotEmpty) {
      final filteredResults = result
          .map((data) => ArticleTable.fromMap(data))
          .where((article) => article.title!.toLowerCase().contains(query))
          .toList();

      if (filteredResults.isNotEmpty) {
        return filteredResults;
      } else {
        throw CacheException("No articles found with the specified criteria");
      }
    } else {
      throw CacheException("Can't get the data");
    }
  }
}

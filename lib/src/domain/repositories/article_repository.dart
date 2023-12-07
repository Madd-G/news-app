import 'package:dartz/dartz.dart';
import 'package:news_app/core/errors/failure.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/domain/entities/articles_entity.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<ArticleEntity>>> getArticles();

  Future<Either<Failure, List<ArticleEntity>>> getArticleByCategory(String category);

  Future<Either<Failure, ArticlesEntity>> searchArticles(String query,
      {int page = 1});

  Future<Either<Failure, String>> saveBookmarkArticle(ArticleEntity article);

  Future<Either<Failure, String>> removeBookmarkArticle(ArticleEntity article);

  Future<bool> isAddedToBookmarkArticle(String url);

  Future<Either<Failure, List<ArticleEntity>>> getBookmarkArticles();
}

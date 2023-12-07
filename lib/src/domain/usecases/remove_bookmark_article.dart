import 'package:dartz/dartz.dart';
import 'package:news_app/core/errors/failure.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/domain/repositories/article_repository.dart';

class RemoveBookmarkArticle {
  final ArticleRepository repository;

  RemoveBookmarkArticle(this.repository);

  Future<Either<Failure, String>> execute(ArticleEntity article) =>
      repository.removeBookmarkArticle(article);
}

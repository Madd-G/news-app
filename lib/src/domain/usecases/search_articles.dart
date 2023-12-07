import 'package:dartz/dartz.dart';
import 'package:news_app/core/errors/failure.dart';
import 'package:news_app/src/domain/entities/articles_entity.dart';
import 'package:news_app/src/domain/repositories/article_repository.dart';

class SearchArticles {
  final ArticleRepository repository;

  SearchArticles(this.repository);

  Future<Either<Failure, ArticlesEntity>> execute(String query, {int page = 1}) =>
      repository.searchArticles(query, page: page);
}

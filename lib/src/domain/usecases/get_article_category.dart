import 'package:dartz/dartz.dart';
import 'package:news_app/core/errors/failure.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/domain/repositories/article_repository.dart';

class GetArticleCategory {
  final ArticleRepository repository;

  GetArticleCategory(this.repository);

  Future<Either<Failure, List<ArticleEntity>>> execute(String category) =>
      repository.getArticleByCategory(category);
}

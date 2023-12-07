import 'package:dartz/dartz.dart';
import 'package:news_app/core/errors/failure.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/domain/repositories/article_repository.dart';

class GetArticles {
  final ArticleRepository repository;

  GetArticles(this.repository);

  Future<Either<Failure, List<ArticleEntity>>> execute() => repository.getArticles();
}

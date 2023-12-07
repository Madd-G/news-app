import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:news_app/core/errors/exception.dart';
import 'package:news_app/core/errors/failure.dart';
import 'package:news_app/core/common/network_info.dart';
import 'package:news_app/src/data/datasources/article_local_data_source.dart';
import 'package:news_app/src/data/datasources/article_remote_data_source.dart';
import 'package:news_app/src/data/models/article_response.dart';
import 'package:news_app/src/data/models/article_table.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/domain/entities/articles_entity.dart';
import 'package:news_app/src/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource remoteDataSource;
  final ArticleLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ArticleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ArticleEntity>>> getArticles() async {
    if (await networkInfo.isConnected) {
      try {
        ArticleResponse result = await remoteDataSource.getArticles();
        localDataSource.cacheArticles(
          result.articles
                  ?.map((article) => ArticleTable.fromDTO(article))
                  .toList() ??
              [],
        );
        return Right(
            result.articles?.map((model) => model.toEntity()).toList() ?? []);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final result = await localDataSource.getCachedArticles();
        return Right(result.map((model) => model.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, ArticlesEntity>> searchArticles(String query,
      {int page = 1}) async {
    if (await networkInfo.isConnected) {
      try {
        ArticleResponse result =
            await remoteDataSource.searchArticles(query, page);
        return Right(result.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on SocketException {
        return const Left(
            ConnectionFailure('Failed to connect to the network'));
      }
    } else {
      try {
        var result = await localDataSource.searchLocalArticles(query);
        var articles = ArticlesEntity(
          status: 'local',
          totalResults: result.length,
          articles:
              result.map((articleTable) => articleTable.toEntity()).toList(),
        );
        return Right(articles);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getArticleByCategory(
    String category,
  ) async {
    try {
      final result = await remoteDataSource.getArticleByCategory(category);
      return Right(
        result.articles?.map((model) => model.toEntity()).toList() ?? [],
      );
    } on ServerException {
      return const Left(ServerFailure('Failed to connect to the server'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> saveBookmarkArticle(
      ArticleEntity article) async {
    try {
      final result = await localDataSource
          .insertBookmarkArticle(ArticleTable.fromEntity(article));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, String>> removeBookmarkArticle(
      ArticleEntity article) async {
    try {
      final result = await localDataSource
          .removeBookmarkArticle(ArticleTable.fromEntity(article));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToBookmarkArticle(String url) async {
    final result = await localDataSource.getArticleByUrl(url);
    return result != null;
  }

  @override
  Future<Either<Failure, List<ArticleEntity>>> getBookmarkArticles() async {
    final result = await localDataSource.getBookmarkArticles();
    return Right(result.map((data) => data.toEntity()).toList());
  }
}

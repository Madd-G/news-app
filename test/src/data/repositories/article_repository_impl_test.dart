import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/core/errors/exception.dart';
import 'package:news_app/core/errors/failure.dart';
import 'package:news_app/src/data/models/article_model.dart';
import 'package:news_app/src/data/models/article_response.dart';
import 'package:news_app/src/data/repositories/article_repository_impl.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/domain/entities/articles_entity.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late ArticleRepositoryImpl repository;
  late MockArticleRemoteDataSource mockRemoteDataSource;
  late MockArticleLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockArticleRemoteDataSource();
    mockLocalDataSource = MockArticleLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ArticleRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  final tArticleModel = ArticleModel(
    author: 'test author',
    title: 'test title',
    description: 'test description',
    url: 'test url',
    urlToImage: 'test url to image',
    publishedAt: DateTime.parse('2022-01-01T02:15:39Z'),
    content: 'test content',
  );

  final tArticleResponse = ArticleResponse(
    status: "ok",
    totalResults: 1,
    articles: [tArticleModel],
  );

  final tArticle = ArticleEntity(
    author: 'test author',
    title: 'test title',
    description: 'test description',
    url: 'test url',
    urlToImage: 'test url to image',
    publishedAt: DateTime.parse('2022-01-01T02:15:39Z'),
    content: 'test content',
  );

  // final tArticleModelList = <ArticleModel>[tArticleModel];
  final tArticleList = <ArticleEntity>[tArticle];

  group('Articles', () {
    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getArticles())
          .thenAnswer((_) async => tArticleResponse);
      //act
      await repository.getArticles();
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
          'should return remote data when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getArticles())
            .thenAnswer((_) async => tArticleResponse);
        // act
        final result = await repository.getArticles();
        // assert
        verify(mockRemoteDataSource.getArticles());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tArticleList);
      });

      test(
          'should cache data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.getArticles())
            .thenAnswer((_) async => tArticleResponse);
        // act
        await repository.getArticles();
        // assert
        verify(mockRemoteDataSource.getArticles());
        verify(mockLocalDataSource.cacheArticles([testArticleCache]));
      });

      test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.getArticles())
            .thenThrow(ServerException('Failed to connect to the server'));
        // act
        final result = await repository.getArticles();
        // assert
        verify(mockRemoteDataSource.getArticles());
        expect(
            result,
            equals(
                const Left(ServerFailure('Failed to connect to the server'))));
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return cached data when device is offline', () async {
        // arrange
        when(mockLocalDataSource.getCachedArticles())
            .thenAnswer((_) async => [testArticleCache]);
        //act
        final result = await repository.getArticles();
        //assert
        verify(mockLocalDataSource.getCachedArticles());
        final resultList = result.getOrElse(() => []);
        expect(resultList, [testArticleFromCache]);
      });

      test('should return CacheFailure when app has no cache', () async {
        // arrange
        when(mockLocalDataSource.getCachedArticles())
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.getArticles();
        // assert
        verify(mockLocalDataSource.getCachedArticles());
        expect(result, const Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Search Articles', () {
    const tQuery = 'beyond';
    const tPage = 1;

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.searchArticles(tQuery, tPage))
          .thenAnswer((_) async => tArticleResponse);
      //act
      await repository.searchArticles(tQuery);
      //assert
      verify(mockNetworkInfo.isConnected);
    });

    group('when device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      test('should return Article list when call to data source is successful',
          () async {
        // arrange
        when(mockRemoteDataSource.searchArticles(tQuery, tPage))
            .thenAnswer((_) async => tArticleResponse);
        // act
        final result = await repository.searchArticles(tQuery);
        // assert
        final resultList = result.getOrElse(
            () => const ArticlesEntity(totalResults: 1, articles: []));
        expect(resultList, tArticleResponse.toEntity());
      });

      test(
          'should return ServerFailure when call to data source is unsuccessful',
          () async {
        // arrange
        when(mockRemoteDataSource.searchArticles(tQuery, tPage))
            .thenThrow(ServerException('Failed to connect to the server'));
        // act
        final result = await repository.searchArticles(tQuery);
        // assert
        expect(result,
            const Left(ServerFailure('Failed to connect to the server')));
      });

      test(
          'should return Connection Failure when device is not connected to the internet',
          () async {
        // arrange
        when(mockRemoteDataSource.searchArticles(tQuery, tPage)).thenThrow(
            const SocketException('Failed to connect to the network'));
        // act
        final result = await repository.searchArticles(tQuery);
        // assert
        expect(
          result,
          const Left(ConnectionFailure('Failed to connect to the network')),
        );
      });
    });

    group('when device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return cache article list when call to local source is successful',
          () async {
        // arrange
        when(mockLocalDataSource.searchLocalArticles(tQuery))
            .thenAnswer((_) async => [testArticleCache]);
        // act
        final result = await repository.searchArticles(tQuery);
        // assert
        final resultList = result.getOrElse(
            () => const ArticlesEntity(totalResults: 0, articles: []));

        expect(resultList.articles, isNotEmpty);

        final firstArticle = resultList.articles?[0];

        expect(firstArticle, testArticleCache.toEntity());
      });

      test(
          'should return CacheFailure when call to data source is unsuccessful',
          () async {
        // arrange
        when(mockLocalDataSource.searchLocalArticles(tQuery))
            .thenThrow(CacheException('No Cache'));
        // act
        final result = await repository.searchArticles(tQuery);
        // assert
        verify(mockLocalDataSource.searchLocalArticles(tQuery));
        expect(result, const Left(CacheFailure('No Cache')));
      });
    });
  });

  group('Get Article by Category', () {
    final tArticle = ArticleEntity(
        author: "test author",
        title: "test title",
        description: "test description",
        url: "test url",
        urlToImage: "test url to image",
        publishedAt: DateTime.parse("2022-01-01 02:15:39.000Z"),
        content: "test content");
    final tArticleList = [tArticle];
    const tCategory = 'sport';

    test('should return data (Article list) when the call is successful',
        () async {
      // arrange
      when(mockRemoteDataSource.getArticleByCategory(tCategory))
          .thenAnswer((_) async => tArticleResponse);
      // act
      final result = await repository.getArticleByCategory(tCategory);
      // assert
      verify(mockRemoteDataSource.getArticleByCategory(tCategory));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tArticleList));
    });

    test(
        'should return server failure when call to remote data source is unsuccessful',
        () async {
      // arrange
      when(mockRemoteDataSource.getArticleByCategory(tCategory))
          .thenThrow(ServerException('Failed to connect to the server'));
      // act
      final result = await repository.getArticleByCategory(tCategory);
      // assert build runner
      verify(mockRemoteDataSource.getArticleByCategory(tCategory));
      expect(result,
          equals(const Left(ServerFailure('Failed to connect to the server'))));
    });

    test(
        'should return connection failure when the device is not connected to the internet',
        () async {
      // arrange
      when(mockRemoteDataSource.getArticleByCategory(tCategory))
          .thenThrow(const SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getArticleByCategory(tCategory);
      // assert
      verify(mockRemoteDataSource.getArticleByCategory(tCategory));
      expect(
        result,
        equals(
            const Left(ConnectionFailure('Failed to connect to the network'))),
      );
    });
  });

  group('save Bookmark', () {
    test('should return success message when saving successful', () async {
      // arrange
      when(mockLocalDataSource.insertBookmarkArticle(testArticleTable))
          .thenAnswer((_) async => 'Added to Bookmark');
      // act
      final result = await repository.saveBookmarkArticle(testArticle);
      // assert
      expect(result, const Right('Added to Bookmark'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.insertBookmarkArticle(testArticleTable))
          .thenThrow(DatabaseException('Failed to add Bookmark'));
      // act
      final result = await repository.saveBookmarkArticle(testArticle);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to add Bookmark')));
    });
  });

  group('remove Bookmark', () {
    test('should return success message when remove successful', () async {
      // arrange
      when(mockLocalDataSource.removeBookmarkArticle(testArticleTable))
          .thenAnswer((_) async => 'Removed from Bookmark');
      // act
      final result = await repository.removeBookmarkArticle(testArticle);
      // assert
      expect(result, const Right('Removed from Bookmark'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      // arrange
      when(mockLocalDataSource.removeBookmarkArticle(testArticleTable))
          .thenThrow(DatabaseException('Failed to remove Bookmark'));
      // act
      final result = await repository.removeBookmarkArticle(testArticle);
      // assert
      expect(result, const Left(DatabaseFailure('Failed to remove Bookmark')));
    });
  });

  group('get Bookmark status', () {
    test('should return watch status whether data is found', () async {
      // arrange
      const tUrl = 'url';
      when(mockLocalDataSource.getArticleByUrl(tUrl))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToBookmarkArticle(tUrl);
      // assert
      expect(result, false);
    });
  });

  group('get Bookmark Articles', () {
    test('should return list of Articles', () async {
      // arrange
      when(mockLocalDataSource.getBookmarkArticles())
          .thenAnswer((_) async => [testArticleTable]);
      // act
      final result = await repository.getBookmarkArticles();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testBookmarkArticle]);
    });
  });
}

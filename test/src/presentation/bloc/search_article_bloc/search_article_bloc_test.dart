import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/core/errors/failure.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/domain/entities/articles_entity.dart';
import 'package:news_app/src/domain/usecases/search_articles.dart';
import 'package:news_app/src/presentation/bloc/search_article_bloc/search_article_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_article_bloc_test.mocks.dart';

@GenerateMocks([SearchArticles])
void main() {
  late SearchArticleBloc searchArticleBloc;
  late MockSearchArticles mockSearchArticles;

  setUp(() {
    mockSearchArticles = MockSearchArticles();
    searchArticleBloc = SearchArticleBloc(mockSearchArticles);
  });

  final tArticleModel = ArticleEntity(
    author: 'test author',
    title: 'test title',
    description: 'test description',
    url: 'test url',
    urlToImage: 'test url to image',
    publishedAt: DateTime.parse('2022-01-01T02:15:39Z'),
    content: 'test content',
  );

  final tArticles = ArticlesEntity(
    totalResults: 1,
    articles: [tArticleModel],
  );

  final tArticleList = <ArticleEntity>[tArticleModel];
  const tQuery = 'business';
  const totalResults = 1;
  const tPage = 1;

  group('Search Articles', () {

    test('Initial state should be empty', () {
      expect(searchArticleBloc.state, SearchArticleInitial());
    });

    blocTest<SearchArticleBloc, SearchArticleState> (
      'Should emit [SearchLoading, SearchHasData] when data is gotten successfully',
      build: () {
        when(mockSearchArticles.execute(tQuery))
          .thenAnswer((_) async => Right(tArticles));
        return searchArticleBloc;
      },
      act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchArticleLoading(),
        SearchArticleHasData(tArticleList, totalResults, tPage),
      ],
      verify: (bloc) {
        verify(mockSearchArticles.execute(tQuery));
      },
    );
    
    blocTest<SearchArticleBloc, SearchArticleState> (
      'Should emit [SearchLoading, SearchHasData[], SearchEmpty] when data is empty',
      build: () {
        when(mockSearchArticles.execute(tQuery))
          .thenAnswer((_) async => const Right(ArticlesEntity(totalResults: 1, articles: [])));
        return searchArticleBloc;
      },
      act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchArticleLoading(),
        const SearchArticleHasData(<ArticleEntity>[], totalResults, tPage),
        const SearchArticleEmpty('No Article Found'),
      ],
      verify: (bloc) {
        verify(mockSearchArticles.execute(tQuery));
      },
    );

    blocTest<SearchArticleBloc, SearchArticleState> (
      'Should emit [SearchLoading, SearchError] when data is unsuccessful',
      build: () {
        when(mockSearchArticles.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return searchArticleBloc;
      },
      act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchArticleLoading(),
        const SearchArticleError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockSearchArticles.execute(tQuery));
      },
    );
  });
}

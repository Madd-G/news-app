import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/core/errors/failure.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app/src/domain/usecases/get_articles.dart';
import 'package:news_app/src/presentation/bloc/article_bloc/article_list_bloc.dart';

import 'article_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetArticles,
])
void main() {
  late ArticleListBloc articleListBloc;
  late MockGetArticles mockGetArticles;

  setUp(() {
    mockGetArticles = MockGetArticles();
    articleListBloc = ArticleListBloc(mockGetArticles);
  });

  final tArticle = ArticleEntity(
    author: 'test author',
    title: 'test title',
    description: 'test description',
    url: 'test url',
    urlToImage: 'test url to image',
    publishedAt: DateTime.parse('2022-01-01T02:15:39Z'),
    content: 'test content',
  );

  final tArticleList = <ArticleEntity>[tArticle];

  group('Article list', () {
    test('Initial state should be empty', () {
      expect(articleListBloc.state, ArticleListEmpty());
    });

    blocTest<ArticleListBloc, ArticleListState>(
      'Should emit [ArticleListLoading, ArticleListLoaded] when data is gotten successfully',
      build: () {
        when(mockGetArticles.execute())
            .thenAnswer((_) async => Right(tArticleList));
        return articleListBloc;
      },
      act: (bloc) => bloc.add(ArticleListEvent()),
      expect: () => [
        ArticleListLoading(),
        ArticleListLoaded(tArticleList),
      ],
      verify: (bloc) {
        verify(mockGetArticles.execute());
      },
    );

    blocTest<ArticleListBloc, ArticleListState>(
      'Should emit [ArticleListLoading, ArticleListLoaded[], ArticleListEmpty] when data was Empty',
      build: () {
        when(mockGetArticles.execute())
            .thenAnswer((_) async => const Right(<ArticleEntity>[]));
        return articleListBloc;
      },
      act: (bloc) => bloc.add(ArticleListEvent()),
      expect: () => [
        ArticleListLoading(),
        const ArticleListLoaded([]),
        ArticleListEmpty(),
      ],
      verify: (_) {
        verify(mockGetArticles.execute());
      },
    );

    blocTest<ArticleListBloc, ArticleListState>(
      'Should emit [ArticleListLoading, ArticleListError] when get Failure',
      build: () {
        when(mockGetArticles.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Failed')));
        return articleListBloc;
      },
      act: (bloc) => bloc.add(ArticleListEvent()),
      expect: () => [
        ArticleListLoading(),
        const ArticleListError('Failed'),
      ],
      verify: (_) {
        verify(mockGetArticles.execute());
      },
    );
  });
}

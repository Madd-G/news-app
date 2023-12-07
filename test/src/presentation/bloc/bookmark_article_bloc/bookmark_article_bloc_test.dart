import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/core/errors/failure.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/domain/usecases/get_bookmark_articles.dart';
import 'package:news_app/src/presentation/bloc/bookmark_article_bloc/bookmark_article_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'bookmark_article_bloc_test.mocks.dart';

@GenerateMocks([GetBookmarkArticles])
void main() {
  late BookmarkArticleBloc bookmarkArticleBloc;
  late MockGetBookmarkArticles mockGetBookmarkArticles;

  setUp(() {
    mockGetBookmarkArticles = MockGetBookmarkArticles();
    bookmarkArticleBloc = BookmarkArticleBloc(mockGetBookmarkArticles);
  });

  final tArticles = <ArticleEntity>[testArticle];

  group('Bookmark Articles', () {

    test('Initial state should be empty', () {
      expect(bookmarkArticleBloc.state, const BookmarkArticleEmpty(''));
    });

    blocTest<BookmarkArticleBloc, BookmarkArticleState> (
      'Should emit [BookmarkArticleLoading, BookmarkArticleHasData] when data is gotten successfully',
      build: () {
        when(mockGetBookmarkArticles.execute())
          .thenAnswer((_) async => Right(tArticles));
        return bookmarkArticleBloc;
      },
      act: (bloc) => bloc.add(BookmarkArticleEvent()),
      expect: () => [
        BookmarkArticleLoading(),
        BookmarkArticleHasData(tArticles),
      ],
      verify: (bloc) {
        verify(mockGetBookmarkArticles.execute());
      },
    );

    blocTest<BookmarkArticleBloc, BookmarkArticleState> (
      'Should emit [BookmarkArticleLoading, BookmarkArticleHasData[], BookmarkArticleEmpty] when data is empty',
      build: () {
        when(mockGetBookmarkArticles.execute())
          .thenAnswer((_) async => const Right(<ArticleEntity>[]));
        return bookmarkArticleBloc;
      },
      act: (bloc) => bloc.add(BookmarkArticleEvent()),
      expect: () => [
        BookmarkArticleLoading(),
        const BookmarkArticleHasData(<ArticleEntity>[]),
        const BookmarkArticleEmpty("You haven't added a bookmark"),
      ],
      verify: (bloc) {
        verify(mockGetBookmarkArticles.execute());
      },
    );

    blocTest<BookmarkArticleBloc, BookmarkArticleState> (
      'Should emit [BookmarkArticleLoading, BookmarkArticleError] when data is unsuccessful',
      build: () {
        when(mockGetBookmarkArticles.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return bookmarkArticleBloc;
      },
      act: (bloc) => bloc.add(BookmarkArticleEvent()),
      expect: () => [
        BookmarkArticleLoading(),
        const BookmarkArticleError('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetBookmarkArticles.execute());
      },
    );
  });
}
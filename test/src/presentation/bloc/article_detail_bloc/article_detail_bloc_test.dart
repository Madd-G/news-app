import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/core/errors/failure.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/domain/usecases/get_bookmark_status.dart';
import 'package:news_app/src/domain/usecases/remove_bookmark_article.dart';
import 'package:news_app/src/domain/usecases/save_bookmark_article.dart';
import 'package:news_app/src/presentation/bloc/article_detail_bloc/article_detail_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'article_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetBookmarkStatus,
  SaveBookmarkArticle,
  RemoveBookmarkArticle,
])
void main() {
  late ArticleDetailBloc articleDetailBloc;
  late MockGetBookmarkStatus mockGetBookmarkStatus;
  late MockSaveBookmarkArticle mockSaveBookmarkArticle;
  late MockRemoveBookmarkArticle mockRemoveBookmarkArticle;

  setUp(() {
    mockGetBookmarkStatus = MockGetBookmarkStatus();
    mockSaveBookmarkArticle = MockSaveBookmarkArticle();
    mockRemoveBookmarkArticle = MockRemoveBookmarkArticle();
    articleDetailBloc = ArticleDetailBloc(
      getBookmarkStatus: mockGetBookmarkStatus,
      saveBookmarkArticle: mockSaveBookmarkArticle,
      removeBookmarkArticle: mockRemoveBookmarkArticle,
    );
  });

  final articleDetailStateInit = ArticleDetailState.initial();
  final tArticle = ArticleEntity(
    author: 'test author',
    title: 'test title',
    description: 'test description',
    url: 'test url',
    urlToImage: 'test url to image',
    publishedAt: DateTime.parse('2022-01-01T02:15:39Z'),
    content: 'test content',
  );

  group('AddToBookmark Article', () { 

    blocTest<ArticleDetailBloc, ArticleDetailState>(
      'Shoud emit bookmarkMessage and isAddedToBookmark True when Success AddBookmark',
      build: () {
        when(mockSaveBookmarkArticle.execute(tArticle))
            .thenAnswer((_) async => const Right('Added to Bookmark'));
        when(mockGetBookmarkStatus.execute(tArticle.url))
            .thenAnswer((_) async => true);
        return articleDetailBloc;
      },
      act: (bloc) => bloc.add(AddToBookmark(tArticle)),
      expect: () => [
        articleDetailStateInit.copyWith(bookmarkMessage: 'Added to Bookmark'),
        articleDetailStateInit.copyWith(
          bookmarkMessage: 'Added to Bookmark', 
          isAddedToBookmark: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveBookmarkArticle.execute(tArticle));
        verify(mockGetBookmarkStatus.execute(tArticle.url));
      },
    );

    blocTest<ArticleDetailBloc, ArticleDetailState>(
      'Shoud emit bookmarkMessage when Failed',
      build: () {
        when(mockSaveBookmarkArticle.execute(tArticle))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetBookmarkStatus.execute(tArticle.url))
            .thenAnswer((_) async => false);
        return articleDetailBloc;
      },
      act: (bloc) => bloc.add(AddToBookmark(tArticle)),
      expect: () => [
        articleDetailStateInit.copyWith(bookmarkMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveBookmarkArticle.execute(tArticle));
        verify(mockGetBookmarkStatus.execute(tArticle.url));
      },
    );
  });

  group('Remove From Bookmark Article', () { 
    
    blocTest<ArticleDetailBloc, ArticleDetailState>(
      'Shoud emit bookmarkMessage and isAddedToBookmark False when Success RemoveFromBookmark',
      build: () {
        when(mockRemoveBookmarkArticle.execute(tArticle))
            .thenAnswer((_) async => const Right('Removed From Bookmark'));
        when(mockGetBookmarkStatus.execute(tArticle.url))
            .thenAnswer((_) async => false);
        return articleDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromBookmark(tArticle)),
      expect: () => [
        articleDetailStateInit.copyWith(
          bookmarkMessage: 'Removed From Bookmark',
          isAddedToBookmark: false,
        ),
      ],
      verify: (_) {
        verify(mockRemoveBookmarkArticle.execute(tArticle));
        verify(mockGetBookmarkStatus.execute(tArticle.url));
      },
    );

    blocTest<ArticleDetailBloc, ArticleDetailState>(
      'Shoud emit bookmarkMessage when Failed',
      build: () {
        when(mockRemoveBookmarkArticle.execute(tArticle))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetBookmarkStatus.execute(tArticle.url))
            .thenAnswer((_) async => false);
        return articleDetailBloc;
      },
      act: (bloc) => bloc.add(RemoveFromBookmark(tArticle)),
      expect: () => [
        articleDetailStateInit.copyWith(bookmarkMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockRemoveBookmarkArticle.execute(tArticle));
        verify(mockGetBookmarkStatus.execute(tArticle.url));
      },
    );
  });

  group('LoadBookmarkStatus', () {
    blocTest<ArticleDetailBloc, ArticleDetailState>(
      'Should Emit AddBookmarkStatus True',
      build: () {
        when(mockGetBookmarkStatus.execute(tArticle.url))
          .thenAnswer((_) async => true);
        return articleDetailBloc;
      },
      act: (bloc) => bloc.add(LoadBookmarkStatus(tArticle.url ?? '')),
      expect: () => [
        articleDetailStateInit.copyWith(
          isAddedToBookmark: true,
        ),
      ],
      verify: (_) {
        verify(mockGetBookmarkStatus.execute(tArticle.url));
      },
    );
  });
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/domain/entities/articles_entity.dart';
import 'package:news_app/src/domain/usecases/search_articles.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.mocks.dart';

void main() {
  late SearchArticles usecase;
  late MockArticleRepository mockArticleRepository;

  setUp(() {
    mockArticleRepository = MockArticleRepository();
    usecase = SearchArticles(mockArticleRepository);
  });

  const tArticles = ArticlesEntity(totalResults: 1, articles: <ArticleEntity>[]);
  const tQuery = 'business';

  test('should get list of Articles from the repository', () async {
    // arrange
    when(mockArticleRepository.searchArticles(tQuery))
        .thenAnswer((_) async => const Right(tArticles));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, const Right(tArticles));
  });
}
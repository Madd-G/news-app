import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app/src/domain/usecases/get_articles.dart';

import '../helpers/test_helper.mocks.dart';

void main() {
  late GetArticles usecase;
  late MockArticleRepository mockArticleRpository;

  setUp(() {
    mockArticleRpository = MockArticleRepository();
    usecase = GetArticles(mockArticleRpository);
  });

  final tArticles = <ArticleEntity>[];

  group('Get Articles Tests', () {
    group('execute', () {
      test(
          'should get list of Articles from the repository when execute function is called',
          () async {
        // arrange
        when(mockArticleRpository.getArticles())
            .thenAnswer((_) async => Right(tArticles));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(tArticles));
      });
    });
  });
}
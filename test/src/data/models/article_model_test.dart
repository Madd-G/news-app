import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/src/data/models/article_model.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('should be a subclass of ArticleEntity', () {
    final result = tArticleModel.toEntity();
    expect(result, testArticle);
  });

  test('should convert from JSON to ArticleModel', () {
    // Arrange
    var jsonMap = testArticleMap;

    // Act
    final result = ArticleModel.fromJson(jsonMap);

    // Assert
    expect(result, tArticleModel);
  });

  test('should convert from ArticleModel to JSON', () {
    // Act
    final result = tArticleModel.toJson();

    // Assert
    final expectedJson = {
      'author': 'test author',
      'title': 'test title',
      'description': 'test description',
      'url': 'test url',
      'urlToImage': 'test url to image',
      'publishedAt': '2022-01-01T02:15:39.000Z',
      'content': 'test content',
    };
    expect(result, expectedJson);
  });
}

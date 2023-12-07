import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/src/data/models/article_model.dart';
import 'package:news_app/src/data/models/article_table.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final Map<String, dynamic> articleTableJson = {
    'author': 'test author',
    'title': 'test title',
    'description': 'test description',
    'url': 'test url',
    'urlToImage': 'test url to image',
    'publishedAt': '2022-01-01T02:15:39.000Z',
    'content': 'test content',
  };

  final tArticleModel = ArticleModel(
    author: 'test author',
    title: 'test title',
    description: 'test description',
    url: 'test url',
    urlToImage: 'test url to image',
    publishedAt: DateTime.parse('2022-01-01T02:15:39Z'),
    content: 'test content',
  );

  final testArticleEntity = ArticleEntity(
    author: 'test author',
    title: 'test title',
    description: 'test description',
    url: 'test url',
    urlToImage: 'test url to image',
    publishedAt: DateTime.parse('2022-01-01T02:15:39.000Z'),
    content: 'test content',
  );

  test('should return json Article table correctly', () {
    final result = testArticleTable.toJson();
    expect(result, articleTableJson);
  });

  test('should convert from ArticleEntity to ArticleTable', () {
    final result = ArticleTable.fromEntity(testArticleEntity);
    expect(result, testArticleTable);
  });

  test('should convert from Map to ArticleTable', () {
    final result = ArticleTable.fromMap(articleTableJson);
    expect(result, testArticleTable);
  });

  test('should convert from ArticleModel to ArticleTable', () {
    final result = ArticleTable.fromDTO(tArticleModel);
    expect(result, testArticleTable);
  });

  test('should convert to ArticleEntity', () {
    final result = testArticleTable.toEntity();
    expect(result, testArticleEntity);
  });
}

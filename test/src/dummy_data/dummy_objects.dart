import 'package:news_app/src/data/models/article_model.dart';
import 'package:news_app/src/data/models/article_table.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';

final tArticleModel = ArticleModel(
  author: 'test author',
  title: 'test title',
  description: 'test description',
  url: 'test url',
  urlToImage: 'test url to image',
  publishedAt: DateTime.parse('2022-01-01T02:15:39Z'),
  content: 'test content',
);

final testArticle = ArticleEntity(
  author: 'test author',
  title: 'test title',
  description: 'test description',
  url: 'test url',
  urlToImage: 'test url to image',
  publishedAt: DateTime.parse('2022-01-01T02:15:39Z'),
  content: 'test content',
);

final testArticleList = [testArticle];

final testArticleCache = ArticleTable(
  author: 'test author',
  title: 'test title',
  description: 'test description',
  url: 'test url',
  urlToImage: 'test url to image',
  publishedAt: DateTime.parse('2022-01-01T02:15:39Z'),
  content: 'test content',
);

final testArticleMap = {
  'author': 'test author',
  'title': 'test title',
  'description': 'test description',
  'url': 'test url',
  'urlToImage': 'test url to image',
  'publishedAt': '2022-01-01T02:15:39Z',
  'content': 'test content',
};

final testArticleCacheMap = {
  'author': 'test author',
  'title': 'test title',
  'description': 'test description',
  'url': 'test url',
  'urlToImage': 'test url to image',
  'publishedAt': '2022-01-01T02:15:39Z',
  'content': 'test content',
};

final testArticleFromCache = ArticleEntity.bookmark(
  author: 'test author',
  title: 'test title',
  description: 'test description',
  url: 'test url',
  urlToImage: 'test url to image',
  publishedAt: DateTime.parse('2022-01-01T02:15:39Z'),
  content: 'test content',
);

final testBookmarkArticle = ArticleEntity.bookmark(
  author: 'test author',
  title: 'test title',
  description: 'test description',
  url: 'test url',
  urlToImage: 'test url to image',
  publishedAt: DateTime.parse('2022-01-01T02:15:39Z'),
  content: 'test content',
);

final testArticleTable = ArticleTable(
  author: 'test author',
  title: 'test title',
  description: 'test description',
  url: 'test url',
  urlToImage: 'test url to image',
  publishedAt: DateTime.parse('2022-01-01T02:15:39Z'),
  content: 'test content',
);

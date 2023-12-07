import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/src/data/models/article_model.dart';
import 'package:news_app/src/data/models/article_response.dart';
import 'package:news_app/src/domain/entities/articles_entity.dart';

import '../../../json_reader.dart';

void main() {
  final articleModel = ArticleModel(
    author: "John Doe",
    title: "Lorem ipsum",
    description: "This is lorem ipsum",
    url: "https://www.lorem-ipsum.com",
    urlToImage: "https://www.lorem-ipsum.com/article.jpg",
    publishedAt: DateTime.parse("2021-12-31T23:10:00Z"),
    content:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
  );

  final tArticleResponseModel = ArticleResponse(
    status: "ok",
    totalResults: 11,
    articles: <ArticleModel>[articleModel],
  );
  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('src/dummy_data/article.json'));
      // act
      final result = ArticleResponse.fromJson(jsonMap);
      // assert
      expect(result, tArticleResponseModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tArticleResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "status": "ok",
        "totalResults": 11,
        "articles": [
          {
            "author": "John Doe",
            "title": "Lorem ipsum",
            "description": "This is lorem ipsum",
            "url": "https://www.lorem-ipsum.com",
            "urlToImage": "https://www.lorem-ipsum.com/article.jpg",
            "publishedAt": "2021-12-31T23:10:00.000Z",
            "content":
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
          }
        ],
      };
      expect(result, expectedJsonMap);
    });
  });

  group('toEntity', () {
    test('should convert to ArticlesEntity', () {
      // act
      final result = tArticleResponseModel.toEntity();
      // assert
      final expectedEntity = ArticlesEntity(
        status: "ok",
        totalResults: 11,
        articles: [articleModel.toEntity()],
      );
      expect(result, expectedEntity);
    });
  });
}

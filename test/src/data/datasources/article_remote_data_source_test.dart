// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/core/errors/exception.dart';
import 'package:news_app/src/data/datasources/article_remote_data_source.dart';
import 'package:news_app/src/data/models/article_response.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {

  // Just an example, should be hidden
  const API_KEY = 'ca863424791a427daa1084b1521f81eb';
  // const API_KEY = '0e973f3bf60d4544a5623acf647909a3';
  const BASE_URL = 'https://newsapi.org/v2/';
  const COUNTRY = 'us';
  const pageSize = 20;
  const language = 'en';

  late ArticleRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = ArticleRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('Get Articles', () {
    final tArticleList = ArticleResponse.fromJson(
      json.decode(readJson('src/dummy_data/article.json')),
    );

    test('should return list of Articles when response is success (200)',
        () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse(
            '${BASE_URL}top-headlines?country=$COUNTRY&apiKey=$API_KEY&pageSize=20',
          ),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('src/dummy_data/article.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      // act
      final result = await dataSource.getArticles();
      // assert
      expect(result, tArticleList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse(
            '${BASE_URL}top-headlines?country=$COUNTRY&apiKey=$API_KEY&pageSize=20',
          ),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getArticles();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Get Article by Category', () {
    final tArticleList = ArticleResponse.fromJson(
      json.decode(readJson('src/dummy_data/article_category.json')),
    );
    const tCategory = 'business';

    test('should return list of Article Model when the response code is 200',
        () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse(
            '${BASE_URL}top-headlines?country=$COUNTRY&category=$tCategory&apiKey=$API_KEY&pageSize=30',
          ),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('src/dummy_data/article_category.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      // act
      final result = await dataSource.getArticleByCategory(tCategory);
      // assert
      expect(result, equals(tArticleList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse(
            '${BASE_URL}top-headlines?country=$COUNTRY&category=$tCategory&apiKey=$API_KEY&pageSize=30',
          ),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getArticleByCategory(tCategory);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('Search Articles', () {
    final tSearchResult = ArticleResponse.fromJson(
      json.decode(readJson('src/dummy_data/search_article.json')),
    );
    const tQuery = 'bitcoin';
    const tPage = 1;

    test('should return list of Articles when response code is 200', () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse(
            '${BASE_URL}everything?q=$tQuery&apiKey=$API_KEY&pageSize=$pageSize&page=$tPage&language=$language',
          ),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          readJson('src/dummy_data/search_article.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ),
      );
      // act
      final result = await dataSource.searchArticles(tQuery, tPage);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(
        mockHttpClient.get(
          Uri.parse(
            '${BASE_URL}everything?q=$tQuery&apiKey=$API_KEY&pageSize=$pageSize&page=$tPage&language=$language',
          ),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchArticles(tQuery, tPage);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}

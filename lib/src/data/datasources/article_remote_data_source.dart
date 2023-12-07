import 'dart:convert';

import 'package:news_app/core/constants/constants.dart';
import 'package:news_app/core/errors/errors.dart';
import 'package:news_app/src/data/models/article_response.dart';
import 'package:http/http.dart' as http;

abstract class ArticleRemoteDataSource {
  Future<ArticleResponse> getArticles();

  Future<ArticleResponse> getArticleByCategory(String category);

  Future<ArticleResponse> searchArticles(String query, int page);
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final http.Client client;

  ArticleRemoteDataSourceImpl({required this.client});

  @override
  Future<ArticleResponse> getArticles() async {
    final response = await client.get(Uri.parse(
        '${baseUrl}top-headlines?country=$country&apiKey=$apiKey&pageSize=20'));

    if (response.statusCode == 200) {
      return ArticleResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException('Failed to connect to the server');
    }
  }

  @override
  Future<ArticleResponse> getArticleByCategory(String category) async {
    final response = await client.get(
      Uri.parse(
        '${baseUrl}top-headlines?country=$country&category=$category&apiKey=$apiKey&pageSize=30',
      ),
    );

    if (response.statusCode == 200) {
      return ArticleResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException('Failed to connect to the server');
    }
  }

  @override
  Future<ArticleResponse> searchArticles(String query, int page) async {
    final response = await client.get(
      Uri.parse(
        '${baseUrl}everything?q=$query&apiKey=$apiKey&pageSize=$pageSize&page=$page&language=$language',
      ),
    );
    if (response.statusCode == 200) {
      return ArticleResponse.fromJson(json.decode(response.body));
    } else {
      throw ServerException('Failed to connect to the server');
    }
  }
}

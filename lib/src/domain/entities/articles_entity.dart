import 'package:equatable/equatable.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';

class ArticlesEntity extends Equatable {
  final String? status;
  final int? totalResults;
  final List<ArticleEntity>? articles;

  const ArticlesEntity({
    this.status,
    this.totalResults,
    this.articles,
  });

  @override
  List<Object?> get props => [
        status,
        totalResults,
        articles,
      ];

  @override
  String toString() {
    return 'Articles Entity { '
        '\n status: $status, '
        '\n totalResults: $totalResults, '
        '\n articles: $articles, '
        '\n}';
  }
}

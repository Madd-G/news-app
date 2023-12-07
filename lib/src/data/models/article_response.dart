import 'package:equatable/equatable.dart';
import 'package:news_app/src/data/models/article_model.dart';
import 'package:news_app/src/domain/entities/articles_entity.dart';

class ArticleResponse extends Equatable {
  final String? status;
  final int? totalResults;
  final List<ArticleModel>? articles;

  const ArticleResponse({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory ArticleResponse.fromJson(Map<String, dynamic> json) =>
      ArticleResponse(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: json["articles"] == null
            ? null
            : List<ArticleModel>.from(
                json["articles"].map((x) => ArticleModel.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": articles == null
            ? null
            : List<dynamic>.from(articles!.map((x) => x.toJson())),
      };

  ArticlesEntity toEntity() {
    return ArticlesEntity(
      status: status,
      totalResults: totalResults,
      articles:
          articles?.map((x) => x.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
        status,
        totalResults,
        articles,
      ];
}

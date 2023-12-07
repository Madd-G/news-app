import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  const ArticleEntity({
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  final String? author;
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;

  const ArticleEntity.bookmark({
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  @override
  List<Object?> get props => [
        author,
        title,
        description,
        url,
        urlToImage,
        publishedAt,
        content,
      ];

  @override
  String toString() {
    return 'Article Entity { '
        '\n author: $author, '
        '\n title: $title, '
        '\n description: $description, '
        '\n url: $url, '
        '\n urlToImage: $urlToImage, '
        '\n publishedAt: $publishedAt, '
        '\n content: $content, '
        '\n}';
  }
}

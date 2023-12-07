import 'package:news_app/src/domain/repositories/article_repository.dart';

class GetBookmarkStatus {
  final ArticleRepository repository;

  GetBookmarkStatus(this.repository);

  Future<bool> execute(String url) async =>
      repository.isAddedToBookmarkArticle(url);
}

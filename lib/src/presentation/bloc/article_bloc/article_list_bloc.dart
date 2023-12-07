import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/domain/usecases/get_articles.dart';

part 'article_list_event.dart';

part 'article_list_state.dart';

class ArticleListBloc extends Bloc<ArticleListEvent, ArticleListState> {
  final GetArticles getArticles;

  ArticleListBloc(this.getArticles) : super(ArticleListEmpty()) {
    on<ArticleListEvent>((event, emit) async {
      emit(ArticleListLoading());
      final result = await getArticles.execute();
      result.fold(
        (failure) => emit(ArticleListError(failure.message)),
        (articlesData) {
          emit(ArticleListLoaded(articlesData));
          if (articlesData.isEmpty) {
            emit(ArticleListEmpty());
          }
        },
      );
    });
  }
}

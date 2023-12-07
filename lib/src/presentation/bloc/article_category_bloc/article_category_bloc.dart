import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/domain/usecases/get_article_category.dart';

part 'article_category_event.dart';

part 'article_category_state.dart';

class ArticleCategoryBloc
    extends Bloc<ArticleCategoryEvent, ArticleCategoryState> {
  final GetArticleCategory getArticleCategory;

  ArticleCategoryBloc(this.getArticleCategory)
      : super(const ArticleCategoryEmpty('')) {
    on<FetchArticleCategory>((event, emit) async {
      final category = event.category;
      emit(ArticleCategoryLoading());
      final result = await getArticleCategory.execute(category);
      result.fold((failure) => emit(ArticleCategoryError(failure.message)),
          (articlesData) {
        emit(ArticleCategoryHasData(articlesData));
        if (articlesData.isEmpty) {
          emit(const ArticleCategoryEmpty('Empty Article'));
        }
      });
    });
  }
}

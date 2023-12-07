import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app/src/data/datasources/article_remote_data_source.dart';
import 'package:news_app/src/data/repositories/article_repository_impl.dart';
import 'package:news_app/src/domain/repositories/article_repository.dart';
import 'package:news_app/src/domain/usecases/get_article_category.dart';
import 'package:news_app/src/domain/usecases/get_bookmark_articles.dart';
import 'package:news_app/src/domain/usecases/get_bookmark_status.dart';
import 'package:news_app/src/domain/usecases/get_articles.dart';
import 'package:news_app/src/domain/usecases/remove_bookmark_article.dart';
import 'package:news_app/src/domain/usecases/save_bookmark_article.dart';
import 'package:news_app/src/data/datasources/article_local_data_source.dart';
import 'package:news_app/src/data/datasources/db/database_helper.dart';
import 'package:news_app/src/domain/usecases/search_articles.dart';
import 'package:news_app/src/presentation/bloc/article_category_bloc/article_category_bloc.dart';
import 'package:news_app/src/presentation/bloc/article_detail_bloc/article_detail_bloc.dart';
import 'package:news_app/src/presentation/bloc/article_bloc/article_list_bloc.dart';
import 'package:news_app/src/presentation/bloc/bookmark_article_bloc/bookmark_article_bloc.dart';
import 'package:news_app/src/presentation/bloc/search_article_bloc/search_article_bloc.dart';

import 'core/common/network_info.dart';
import 'core/common/shared.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initBloc();
  await _initUseCase();
  await _initRepository();
  await _initDataSource();
  await _initHelper();
  await _initNetworkInfo();
}

Future<void> _initBloc() async {
  sl
    ..registerFactory(
      () => ArticleListBloc(
        sl(),
      ),
    )
    ..registerFactory(
      () => ArticleCategoryBloc(
        sl(),
      ),
    )
    ..registerFactory(
      () => SearchArticleBloc(
        sl(),
      ),
    )
    ..registerFactory(
      () => BookmarkArticleBloc(
        sl(),
      ),
    )
    ..registerFactory(
      () => ArticleDetailBloc(
        getBookmarkStatus: sl(),
        saveBookmarkArticle: sl(),
        removeBookmarkArticle: sl(),
      ),
    );
}

Future<void> _initUseCase() async {
  sl
    ..registerLazySingleton(() => GetArticles(sl()))
    ..registerLazySingleton(() => GetArticleCategory(sl()))
    ..registerLazySingleton(() => SearchArticles(sl()))
    ..registerLazySingleton(() => GetBookmarkArticles(sl()))
    ..registerLazySingleton(() => GetBookmarkStatus(sl()))
    ..registerLazySingleton(() => SaveBookmarkArticle(sl()))
    ..registerLazySingleton(() => RemoveBookmarkArticle(sl()));
}

Future<void> _initRepository() async {
  sl.registerLazySingleton<ArticleRepository>(
    () => ArticleRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
}

Future<void> _initDataSource() async {
  sl
    ..registerLazySingleton<ArticleRemoteDataSource>(
      () => ArticleRemoteDataSourceImpl(client: sl()),
    )
    ..registerLazySingleton<ArticleLocalDataSource>(
      () => ArticleLocalDataSourceImpl(databaseHelper: sl()),
    );
}

Future<void> _initHelper() async {
  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
}

Future<void> _initNetworkInfo() async {
  sl
    ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()))
    ..registerLazySingleton(() => ApiService().client)
    ..registerLazySingleton(() => DataConnectionChecker());
}

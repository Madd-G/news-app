import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/src/presentation/bloc/article_bloc/article_list_bloc.dart';
import 'package:news_app/src/presentation/pages/splash_page.dart';
import 'package:news_app/injection.dart' as di;
import 'package:news_app/src/presentation/bloc/article_category_bloc/article_category_bloc.dart';
import 'package:news_app/src/presentation/bloc/article_detail_bloc/article_detail_bloc.dart';
import 'package:news_app/src/presentation/bloc/bookmark_article_bloc/bookmark_article_bloc.dart';
import 'package:news_app/src/presentation/bloc/search_article_bloc/search_article_bloc.dart';

import 'core/utils/route_util.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ArticleListBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<ArticleCategoryBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<SearchArticleBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<BookmarkArticleBloc>(),
        ),
        BlocProvider(
          create: (_) => sl<ArticleDetailBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
        navigatorObservers: [routeObserver],
      ),
    );
  }
}

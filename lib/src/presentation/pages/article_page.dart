import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/res/app_media.dart';
import 'package:news_app/core/utils/app_colors.dart';
import 'package:news_app/src/presentation/bloc/article_bloc/article_list_bloc.dart';
import 'package:news_app/src/presentation/pages/search_page.dart';
import 'package:news_app/src/presentation/widgets/widgets.dart';

import 'package:news_app/src/presentation/pages/article_category_page.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  void initState() {
    super.initState();
    getNews();
  }

  void getNews() {
    context.read<ArticleListBloc>().add(ArticleListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                );
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          getNews();
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0, top: 12.0, right: 24.0),
          child: ListView(
            children: [
              const Text('Category'),
              Container(
                height: 120,
                width: double.infinity,
                color: AppColors.whiteColor,
                child: ListView(
                  key: const Key('article_category'),
                  scrollDirection: Axis.horizontal,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ArticleCategoryPage(category: 'general'),
                        ),
                      ),
                      child: const CategoryCard(
                          'General', AppMedia.generalImage),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ArticleCategoryPage(category: 'sport'),
                        ),
                      ),
                      child: const CategoryCard(
                          'Sport', AppMedia.sportImage),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ArticleCategoryPage(category: 'technology'),
                        ),
                      ),
                      child: const CategoryCard(
                          'Technology', AppMedia.technologyImage),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ArticleCategoryPage(category: 'health'),
                        ),
                      ),
                      child: const CategoryCard(
                          'Health', AppMedia.healthImage),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ArticleCategoryPage(
                              category: 'entertainment'),
                        ),
                      ),
                      child: const CategoryCard(
                        'Entertainment',
                        AppMedia.entertainmentImage,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ArticleCategoryPage(category: 'science'),
                        ),
                      ),
                      child: const CategoryCard(
                          'Science', AppMedia.scienceImage),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ArticleCategoryPage(category: 'business'),
                        ),
                      ),
                      child: const CategoryCard(
                          'Business', AppMedia.businessImage),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              BlocBuilder<ArticleListBloc, ArticleListState>(
                builder: (context, state) {
                  if (state is ArticleListLoading) {
                    return Container(
                      color: AppColors.whiteColor,
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 8),
                      child: const LoadingArticleList(),
                    );
                  } else if (state is ArticleListLoaded) {
                    return Container(
                      color: AppColors.whiteColor,
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 8),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.articles.length,
                        itemBuilder: (context, index) {
                          var article = state.articles[index];
                          return ArticleList(article: article);
                        },
                      ),
                    );
                  } else if (state is ArticleListEmpty) {
                    return const Center(child: Text('Empty Article'));
                  } else if (state is ArticleListError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(child: Text(''));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

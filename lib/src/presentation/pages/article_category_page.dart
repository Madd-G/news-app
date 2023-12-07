import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/extensions/string_extensions.dart';
import 'package:news_app/src/presentation/bloc/article_category_bloc/article_category_bloc.dart';
import 'package:news_app/src/presentation/widgets/widgets.dart';

class ArticleCategoryPage extends StatefulWidget {
  final String category;

  const ArticleCategoryPage({super.key, required this.category});

  @override
  State<ArticleCategoryPage> createState() => _ArticleCategoryPageState();
}

class _ArticleCategoryPageState extends State<ArticleCategoryPage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    context
        .read<ArticleCategoryBloc>()
        .add(FetchArticleCategory(widget.category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          widget.category.toCapitalized(),
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
        ),
      ),
      body: BlocBuilder<ArticleCategoryBloc, ArticleCategoryState>(
        builder: (context, state) {
          if (state is ArticleCategoryLoading) {
            return const Padding(
              padding: EdgeInsets.only(top: 8),
              child: LoadingArticleList(),
            );
          } else if (state is ArticleCategoryHasData) {
            return Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 8.0, right: 24.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.articles.length,
                itemBuilder: (context, index) {
                  var article = state.articles[index];
                  return ArticleList(article: article);
                },
              ),
            );
          } else if (state is ArticleCategoryEmpty) {
            return Center(child: Text(state.message));
          } else if (state is ArticleCategoryError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text(''));
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/constants/constants.dart';
import 'package:news_app/core/utils/app_colors.dart';
import 'package:news_app/src/presentation/bloc/search_article_bloc/search_article_bloc.dart';
import 'package:news_app/src/presentation/widgets/widgets.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

String _query = '';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin {
  int currentPage = 1;
  int totalPage = 0;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            TextField(
              key: const Key('edtSearch'),
              onChanged: (query) {
                _query = query;
                context.read<SearchArticleBloc>().add(OnQueryChanged(query.toLowerCase()));
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                labelStyle: const TextStyle(
                  color: AppColors.primaryColor,
                ),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(24),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.greyColor),
                  borderRadius: BorderRadius.circular(24),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.primaryColor),
                  borderRadius: BorderRadius.circular(24),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
              textInputAction: TextInputAction.search,
            ),
            Flexible(
              child: BlocBuilder<SearchArticleBloc, SearchArticleState>(
                builder: (context, state) {
                  if (state is SearchArticleInitial) {
                    return const Center(
                      child: Initial(),
                    );
                  } else if (state is SearchArticleLoading) {
                    return const LoadingArticleList();
                  } else if (state is SearchArticleHasData) {
                    currentPage = state.currentPage;
                    final result = state.searchResult;
                    totalPage = (state.totalResult / pageSize).ceil();
                    return LazyLoadScrollView(
                      onEndOfPage: () {
                        if ((currentPage < 5) && (currentPage < totalPage)) {
                          context
                              .read<SearchArticleBloc>()
                              .add(OnNextPage(_query, currentPage));
                        }
                      },
                      scrollOffset: 150,
                      child: ListView.builder(
                        key: const Key('search_item'),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemBuilder: (context, index) {
                          final article = result[index];
                          return ArticleList(article: article);
                        },
                        itemCount: result.length,
                      ),
                    );
                  } else if (state is SearchArticleEmpty) {
                    return const Center(
                      child: NoData(),
                    );
                  } else if (state is SearchArticleError) {
                    return Center(
                      child: Error(message: state.message),
                    );
                  } else {
                    return Center(
                      child: Text(state.runtimeType.toString()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }
}

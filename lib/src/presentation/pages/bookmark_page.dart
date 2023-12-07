import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/route_util.dart';
import 'package:news_app/src/presentation/bloc/bookmark_article_bloc/bookmark_article_bloc.dart';
import 'package:news_app/src/presentation/widgets/widgets.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    context.read<BookmarkArticleBloc>().add(BookmarkArticleEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<BookmarkArticleBloc>().add(BookmarkArticleEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark'),
      ),
      body: BlocBuilder<BookmarkArticleBloc, BookmarkArticleState>(
        builder: (context, state) {
          if (state is BookmarkArticleLoading) {
            return const Padding(
              padding: EdgeInsets.only(top: 8),
              child: LoadingArticleList(),
            );
          } else if (state is BookmarkArticleHasData) {
            return Padding(
              padding:
                  const EdgeInsets.only(left: 24.0, top: 20.0, right: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  ListView.builder(
                    key: const Key('bookmark_item'),
                    shrinkWrap: true,
                    itemCount: state.bookmarkArticle.length,
                    itemBuilder: (context, index) {
                      var article = state.bookmarkArticle[index];
                      return ArticleList(article: article);
                    },
                  ),
                ],
              ),
            );
          } else if (state is BookmarkArticleEmpty) {
            return Center(
                child: Text(
              state.message,
            ));
          } else if (state is BookmarkArticleError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text(''));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

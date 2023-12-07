import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/res/app_media.dart';
import 'package:news_app/core/utils/app_colors.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/presentation/bloc/article_detail_bloc/article_detail_bloc.dart';
import 'package:intl/intl.dart';

class DetailPage extends StatefulWidget {
  final ArticleEntity article;

  const DetailPage({super.key, required this.article});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    context
        .read<ArticleDetailBloc>()
        .add(LoadBookmarkStatus(widget.article.url ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ArticleDetailBloc, ArticleDetailState>(
        listener: (context, state) async {
          if (state.bookmarkMessage ==
              ArticleDetailBloc.bookmarkAddSuccessMessage ||
              state.bookmarkMessage ==
                  ArticleDetailBloc.bookmarkRemoveSuccessMessage) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: state.bookmarkMessage ==
                    ArticleDetailBloc.bookmarkAddSuccessMessage
                    ? AppColors.greenColor
                    : AppColors.redColor,
                content: Text(state.bookmarkMessage),
              ),
            );
          } else {
            await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(state.bookmarkMessage),
                );
              },
            );
          }
        },
        listenWhen: (previousState, currentState) =>
        previousState.bookmarkMessage != currentState.bookmarkMessage &&
            currentState.bookmarkMessage != '',
        builder: (context, state) {
          return Stack(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.bottom),
                        );
                      },
                      blendMode: BlendMode.darken,
                      child: CachedNetworkImage(
                        imageUrl: widget.article.urlToImage ??
                            'https://asset.kompas.com/crops/YQrcfXdm304xoWSOn2yxjOxxFyQ=/0x168:5500x3834/750x500/data/photo/2022/01/11/61dd7a1b1e57e.jpg',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          AppMedia.errorImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            padding: const EdgeInsets.only(
                              left: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: AppColors.primaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => {
                                if (!state.isAddedToBookmark)
                                  {
                                    context
                                        .read<ArticleDetailBloc>()
                                        .add(AddToBookmark(widget.article))
                                  }
                                else
                                  {
                                    context
                                        .read<ArticleDetailBloc>()
                                        .add(RemoveFromBookmark(widget.article))
                                  },
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    state.isAddedToBookmark
                                        ? Icons.bookmark
                                        : Icons.bookmark_border,
                                    color: AppColors.primaryColor,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 20,
                        bottom: 50,
                        right: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('dd/MM/yyyy kk:mm').format(
                              widget.article.publishedAt ?? DateTime.now(),
                            ),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14.0),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.article.title ?? 'No Title',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.article.author ?? 'No Author',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.48,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(
                      20,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.article.description ?? '',
                        style:
                        const TextStyle(color: Colors.grey, fontSize: 18.0),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.article.content ?? '',
                        style:
                        const TextStyle(color: Colors.grey, fontSize: 18.0),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

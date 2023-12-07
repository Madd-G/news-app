import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/core/res/app_media.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/presentation/pages/detail_page.dart';

class ArticleList extends StatelessWidget {
  final ArticleEntity article;

  const ArticleList({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(article: article),
          ),
        ),
      },
      child: Container(
        key: const Key('article_list_item'),
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              height: 80,
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ??
                    'https://asset.kompas.com/crops/YQrcfXdm304xoWSOn2yxjOxxFyQ=/0x168:5500x3834/750x500/data/photo/2022/01/11/61dd7a1b1e57e.jpg',
                imageBuilder: (context, imageProvider) => Container(
                  width: 110,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
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
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    article.title ?? 'No Title',
                    style: const TextStyle(color: Colors.black, fontSize: 18.0),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    article.author ?? 'No Author',
                    style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

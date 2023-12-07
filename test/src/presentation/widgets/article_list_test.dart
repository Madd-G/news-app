import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/src/domain/entities/article_entity.dart';
import 'package:news_app/src/presentation/widgets/widgets.dart';

void main() {
  final article = ArticleEntity(
    author: 'test author',
    title: 'test title',
    description: 'test description',
    url: 'test url',
    urlToImage: 'test url to image',
    publishedAt: DateTime.parse('2022-01-01T02:15:39Z'),
    content: 'test content',
  );

  group(
    'List Article card Widget Test',
    () {
      Widget makeTestableWidget() {
        return MaterialApp(home: Scaffold(body: ArticleList(article: article)));
      }

      testWidgets(
        'Testing if list Article shows',
        (WidgetTester tester) async {
          await tester.pumpWidget(makeTestableWidget());
          expect(find.byType(Text), findsWidgets);
          expect(find.byType(GestureDetector), findsOneWidget);
          expect(find.byType(Container), findsWidgets);
          expect(find.byType(Expanded), findsOneWidget);
          expect(find.byType(CachedNetworkImage), findsOneWidget);
        },
      );
    },
  );
}

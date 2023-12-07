import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shimmer/shimmer.dart';
import 'package:news_app/src/presentation/widgets/loading_article_list.dart';

void main() {
  group(
    'LoadingArticleList Widget Test',
    () {
      testWidgets(
        'Renders LoadingArticleList Widget with Shimmer Animation and ListView',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: LoadingArticleList(),
              ),
            ),
          );

          expect(find.byType(Shimmer), findsOneWidget);
          expect(find.byType(ListView), findsOneWidget);
          expect(find.byKey(const Key('article_list_item')), findsNWidgets(7));
        },
      );

      testWidgets(
        'LoadingArticleList Widget should have Shimmer',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: LoadingArticleList(),
              ),
            ),
          );

          final shimmerFinder = find.byType(Shimmer);
          expect(shimmerFinder, findsOneWidget);
        },
      );
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/core/res/app_media.dart';
import 'package:news_app/src/presentation/widgets/widgets.dart';

void main() {
  const String name = 'name';
  const String image = AppMedia.generalImage;

  group(
    'Article card Widget Test',
    () {
      Widget makeTestableWidget() {
        return const MaterialApp(
            home: Scaffold(body: CategoryCard(name, image)));
      }

      testWidgets(
        'Testing if category card widget shows',
        (WidgetTester tester) async {
          await tester.pumpWidget(makeTestableWidget());
          expect(find.byKey(const Key('category-card')), findsOneWidget);
          expect(find.byType(Container), findsWidgets);
          expect(find.byKey(const Key('category-card-image')), findsWidgets);
        },
      );
    },
  );
}

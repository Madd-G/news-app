import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:news_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Integration Test: ', () {
    testWidgets('All Integration Test', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Go to article in first category
      final Finder articleCategory =
          find.byKey(const Key('article_category')).first;
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(articleCategory, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Choose first article
      final Finder firstItemCategory =
          find.byKey(const Key('article_list_item')).first;
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(firstItemCategory, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Back to list article
      final Finder btnBackDetailCategory = find.byIcon(Icons.arrow_back_ios);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(btnBackDetailCategory);
      await tester.pumpAndSettle();

      // Back to article page
      final Finder btnBackToHome = find.byIcon(Icons.arrow_back);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(btnBackToHome);
      await tester.pumpAndSettle();

      // Go to search page
      final Finder iconSearch = find.byIcon(Icons.search);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(iconSearch);
      await tester.pumpAndSettle();

      // Search article
      final Finder edtSearch = find.byKey(const Key('edtSearch'));
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.enterText(edtSearch, 'tesla');
      await tester.pumpAndSettle();

      // choose first article
      final Finder firstItemSearch =
          find.byKey(const Key('article_list_item')).first;
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(firstItemSearch, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Bookmark article
      final Finder btnBookmarkSearch = find.byIcon(Icons.bookmark_border);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(btnBookmarkSearch);
      await tester.pumpAndSettle();

      // Back to search page
      final Finder btnBackDetailSearch = find.byIcon(Icons.arrow_back_ios);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(btnBackDetailSearch);
      await tester.pumpAndSettle();

      // Back to article page
      final Finder btnBackToArticlePage = find.byIcon(Icons.arrow_back);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(btnBackToArticlePage);
      await tester.pumpAndSettle();

      // Go to bookmark page
      final Finder btnGoToBookmarkPage = find.byIcon(Icons.bookmark);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(btnGoToBookmarkPage);
      await tester.pumpAndSettle();

      // Open first article on bookmark page
      final Finder firstItemBookmark =
          find.byKey(const Key('article_list_item')).first;
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(firstItemBookmark, warnIfMissed: false);
      await tester.pumpAndSettle();

      // Unbookmark article
      final Finder btnUnBookmark = find.byIcon(Icons.bookmark);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(btnUnBookmark);
      await tester.pumpAndSettle();

      // Back to bookmark page
      final Finder btnBackFromBookmark = find.byIcon(Icons.arrow_back_ios);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(btnBackFromBookmark);
      await tester.pumpAndSettle();

      // Check if there is no bookmarked article
      expect(find.text('You haven\'t added a bookmark'), findsOneWidget);

      await tester.pumpAndSettle();
    });
  });
}

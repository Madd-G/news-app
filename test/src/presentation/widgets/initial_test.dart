import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/src/presentation/widgets/initial.dart';

void main() {
  group(
    'Initial Widget Test',
    () {
      testWidgets('Renders Initial Widget with Lottie Animation and Text',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Initial(),
            ),
          ),
        );

        expect(find.byType(Lottie), findsOneWidget);

        expect(find.text('Search the News'), findsOneWidget);
      });

      testWidgets(
          'Initial Widget should have specified width and height for Lottie animation',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Initial(),
            ),
          ),
        );

        final lottieFinder = find.byType(Lottie);
        expect(lottieFinder, findsOneWidget);
        final lottieWidget = tester.widget<Lottie>(lottieFinder);
        expect(lottieWidget.width, 200);
        expect(lottieWidget.height, 150);
      });

      testWidgets(
          'Initial Widget should have specified text style for Text widget',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Initial(),
            ),
          ),
        );

        final textFinder = find.text('Search the News');
        expect(textFinder, findsOneWidget);
        final textWidget = tester.widget<Text>(textFinder);
        expect(textWidget.style?.fontSize, 20.0);
        expect(textWidget.style?.fontWeight, FontWeight.w500);
      });

      testWidgets(
        'Initial Widget should have SizedBox with specified height after Lottie animation',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: Initial(),
              ),
            ),
          );

          final sizedBoxFinder = find.byType(SizedBox);
          expect(sizedBoxFinder, findsOneWidget);
          final sizedBoxWidget = tester.widget<SizedBox>(sizedBoxFinder);
          expect(sizedBoxWidget.height, 8);
        },
      );
    },
  );
}

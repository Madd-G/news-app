import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/src/presentation/widgets/error.dart';

void main() {
  group(
    'Error Widget Test',
    () {
      testWidgets('Renders Error Widget with Lottie Animation and Message',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Error(message: 'Test Error Message'),
            ),
          ),
        );

        expect(find.byType(Lottie), findsOneWidget);

        expect(find.text('Test Error Message'), findsOneWidget);
      });

      testWidgets(
          'Error Widget should have specified width and height for Lottie animation',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Error(message: 'Test Error Message'),
            ),
          ),
        );

        final lottieFinder = find.byType(Lottie);
        expect(lottieFinder, findsOneWidget);
        final lottieWidget = tester.widget<Lottie>(lottieFinder);
        expect(lottieWidget.width, 250);
        expect(lottieWidget.height, 200);
      });

      testWidgets(
        'Error Widget should have SizedBox with specified height after Lottie animation',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: Error(message: 'Test Error Message'),
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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/src/presentation/widgets/no_data.dart';

void main() {
  group('NoData Widget Test', () {
    testWidgets(
      'Renders NoData Widget with Lottie Animation and Text',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NoData(),
            ),
          ),
        );

        expect(find.byType(Column), findsOneWidget);
        expect(find.byType(Lottie), findsOneWidget);
        expect(find.byType(Text), findsOneWidget);
      },
    );

    testWidgets(
      'NoData Widget should have specified Lottie animation with width, height, and fit',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NoData(),
            ),
          ),
        );

        final lottieFinder = find.byType(Lottie);
        expect(lottieFinder, findsOneWidget);
        final lottieWidget = tester.widget<Lottie>(lottieFinder);
        expect(lottieWidget.width, 400);
        expect(lottieWidget.height, 300);
        expect(lottieWidget.fit, BoxFit.fill);
      },
    );

    testWidgets(
      'NoData Widget should display the specified message',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: NoData(),
            ),
          ),
        );

        expect(find.text('No data available'), findsOneWidget);
      },
    );
  });
}

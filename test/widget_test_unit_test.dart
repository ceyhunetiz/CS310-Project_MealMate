import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

/// ---------- UNIT TEST PART ----------
int calculateSum(List<int> numbers) {
  return numbers.reduce((a, b) => a + b);
}

void main() {

  // UNIT TEST

  test('calculateSum returns correct result', () {
    final numbers = [10, 20, 30];
    final result = calculateSum(numbers);

    expect(result, 60);
  });


  // WIDGET TEST

  testWidgets('Widget tree builds successfully',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Text('MealMate Test'),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.byType(MaterialApp), findsOneWidget);
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.text('MealMate Test'), findsOneWidget);
      });
}

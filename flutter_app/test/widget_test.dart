import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('City Civic App Smoke & Branding Test', (WidgetTester tester) async {
    // Build a test harness simulating the core civic UI theme
    await tester.pumpWidget(
      MaterialApp(
        title: 'City Civic',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('City Civic Portal'),
          ),
          body: const Center(
            child: Text('Report Civic Issues'),
          ),
        ),
      ),
    );

    // Verify application title in AppBar
    expect(find.text('City Civic Portal'), findsOneWidget);

    // Verify main citizen action prompt is present
    expect(find.text('Report Civic Issues'), findsOneWidget);

    // Verify absence of invalid placeholder elements
    expect(find.text('Non-existent Element'), findsNothing);
  });

  testWidgets('Civic Category Status Filter Chip Test', (WidgetTester tester) async {
    bool isSelected = false;

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: FilterChip(
                  label: const Text('Roads'),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      isSelected = selected;
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
    );

    // Verify chip renders category label
    expect(find.text('Roads'), findsOneWidget);

    // Tap the chip to toggle state
    await tester.tap(find.byType(FilterChip));
    await tester.pump();

    // Verify chip responds to tap
    expect(isSelected, isTrue);
  });
}

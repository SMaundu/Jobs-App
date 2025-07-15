import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobs_flutter_app/main.dart';

void main() {
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const JobsFlutterApp());

    // Example: Check if MaterialApp exists
    expect(find.byType(MaterialApp), findsOneWidget);

    // Optional: If LoginView or RootView show known text, test it here
    // expect(find.text('Login'), findsOneWidget); // if LoginView shows 'Login'
  });
}

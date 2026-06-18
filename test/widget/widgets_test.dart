import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_inspection/core/common/enums/inspection_status.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/widgets/inspection_checkbox_field.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/widgets/inspection_dropdown_field.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/widgets/inspection_text_field.dart';
import 'package:offline_first_inspection/init_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  ///Code to set up shared dependencies
  setUpAll(() async {
    // This tells the SharedPreferences plugin to use a
    // memory-based map instead of trying to talk to a real device.
    SharedPreferences.setMockInitialValues({});
    await initDependencies();
  });

  testWidgets('finds a InspectionCheckboxField widget', (tester) async {
    // Build an App with a Text widget that displays the letter 'H'.
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: InspectionCheckboxField(label: 'Action Required', onSaved: (bool? b) {}),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(InspectionCheckboxField).first);
    // Find a widget that displays the letter 'H'.
    expect(find.text('Action Required'), findsOneWidget);
  });

  testWidgets('finds a widget using a Key', (tester) async {
    // Define the test key.
    const testKey = Key('K');

    // Build a MaterialApp with the testKey.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: InspectionTextField(key: testKey, onSaved: (String? p1) {}, label: 'Inspection title'),
          ),
        ),
      ),
    );

    // Find the MaterialApp widget using the testKey.
    expect(find.byKey(testKey), findsOneWidget);

    await tester.enterText(find.byKey(testKey), 'my@email.com');

    expect(find.text('my@email.com'), findsOneWidget);
  });

  testWidgets('finds a specific instance', (tester) async {
    final childWidget = InspectionDropdownField(label: 'drop down field', onSaved: (InspectionStatus? p1) {});

    // Provide the childWidget to the Container.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            child: Padding(padding: EdgeInsets.zero, child: childWidget),
          ),
        ),
      ),
    );

    // Search for the childWidget in the tree and verify it exists.
    expect(find.byWidget(childWidget), findsOneWidget);
  });
}

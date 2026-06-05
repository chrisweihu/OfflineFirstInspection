import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/blocs/inspection_table/inspection_table_bloc.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/cubits/form_field/form_checkbox_cubit.dart';
import 'package:offline_first_inspection/init_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockInspectionTableBloc
    extends MockBloc<InspectionTableEvent, InspectionTableState>
    implements InspectionTableBloc {}

class MockFormCheckboxCubit extends MockCubit<FormCheckboxState>
    implements FormCheckboxCubit {}

void main() {
  ///Code to set up shared dependencies
  setUpAll(() async {
    // This tells the SharedPreferences plugin to use a
    // memory-based map instead of trying to talk to a real device.
    SharedPreferences.setMockInitialValues({});
    await initDependencies();
  });

  // Define a group of tests for the Bloc classes
  group('Inspection Form Bloc/Cubits', () {
    blocTest(
      'emits [FormCheckboxUpdatedState] when FormCheckboxCubit.toggle() is called',
      build: () => getIt<FormCheckboxCubit>(),
      act: (bloc) => bloc.toggle(value: true, fieldId: 'fieldId'),
      // wait: const Duration(milliseconds: 300),
      expect: () => [isA<FormCheckboxUpdatedState>()],
    );

    // Test case 1: whenListen creates a stub response for the listen method on a bloc or cubit. Use whenListen if you want to return a canned Stream of states. whenListen also handles stubbing the state to stay in sync with the emitted state.
    test('test mock', () async {
      // Create a mock instance
      final counterBloc = MockInspectionTableBloc();

      final initState = InspectionTableInitialState();
      final loadingState = InspectionTableLoadingState();
      final failedState = InspectionTableFailureState('');
      // Stub the state stream
      whenListen(
        counterBloc,
        Stream.fromIterable([initState, loadingState, failedState]),
        initialState: initState,
      );

      // Assert that the initial state is correct.
      expect(counterBloc.state, equals(initState));

      // Assert that the stubbed stream is emitted.
      await expectLater(
        counterBloc.stream,
        emitsInOrder(<InspectionTableState>[
          initState,
          loadingState,
          failedState,
        ]),
      );

      // Assert that the current state is in sync with the stubbed stream.
      expect(counterBloc.state, equals(failedState));
    });
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:offline_first_inspection/core/error/failtures.dart';
import 'package:offline_first_inspection/core/usecase/usecase.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/usecases/get_all_inspection_forms.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/usecases/sync_inspection_forms.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/providers/form_checkbox_provider.dart';
import 'package:offline_first_inspection/features/inspection_form/presentation/providers/inspection_table_provider.dart';
import 'package:offline_first_inspection/init_dependencies.dart';

class MockGetAllLocalInspectionForms extends Mock implements GetAllLocalInspectionForms {}
class MockSyncInspectionForms extends Mock implements SyncInspectionForms {}

void main() {
  late MockGetAllLocalInspectionForms mockGetAllLocalInspectionForms;
  late MockSyncInspectionForms mockSyncInspectionForms;

  setUpAll(() {
    registerFallbackValue(NoParams());
    getIt.allowReassignment = true;
    mockGetAllLocalInspectionForms = MockGetAllLocalInspectionForms();
    mockSyncInspectionForms = MockSyncInspectionForms();

    getIt.registerLazySingleton<GetAllLocalInspectionForms>(() => mockGetAllLocalInspectionForms);
    getIt.registerLazySingleton<SyncInspectionForms>(() => mockSyncInspectionForms);
  });

  group('FormCheckboxProvider Tests', () {
    test('initial state is FormCheckboxInitialState', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(formCheckboxProvider), isA<FormCheckboxInitialState>());
    });

    test('emits FormCheckboxUpdatedState with correct values when toggle is called', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(formCheckboxProvider.notifier).toggle(value: true, fieldId: 'field_1');

      final state = container.read(formCheckboxProvider);
      expect(state, isA<FormCheckboxUpdatedState>());
      final updatedState = state as FormCheckboxUpdatedState;
      expect(updatedState.value, isTrue);
      expect(updatedState.fieldId, 'field_1');
      expect(updatedState.allValues['field_1'], isTrue);
    });

    test('retains allValues correctly across multiple toggle calls', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(formCheckboxProvider.notifier);
      notifier.toggle(value: true, fieldId: 'field_1');
      notifier.toggle(value: false, fieldId: 'field_2');

      final state = container.read(formCheckboxProvider) as FormCheckboxUpdatedState;
      expect(state.allValues['field_1'], isTrue);
      expect(state.allValues['field_2'], isFalse);
    });
  });

  group('InspectionTableProvider Tests', () {
    test('initial state is InspectionTableInitialState', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(inspectionTableProvider), isA<InspectionTableInitialState>());
    });

    test('loads inspection forms successfully', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final mockForms = [InspectionFormDto(id: '1', date: DateTime.now())];

      when(() => mockGetAllLocalInspectionForms(any()))
          .thenAnswer((_) async => Right(mockForms));

      final notifier = container.read(inspectionTableProvider.notifier);
      await notifier.loadInspectionForms();

      final state = container.read(inspectionTableProvider);
      expect(state, isA<InspectionTableLoadedState>());
      expect((state as InspectionTableLoadedState).data, equals(mockForms));
    });

    test('syncs inspection forms successfully', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final mockForms = [InspectionFormDto(id: '2', date: DateTime.now())];

      when(() => mockSyncInspectionForms(any()))
          .thenAnswer((_) async => Right(mockForms));

      final notifier = container.read(inspectionTableProvider.notifier);
      await notifier.syncInspectionForms();

      final state = container.read(inspectionTableProvider);
      expect(state, isA<InspectionTableLoadedState>());
      expect((state as InspectionTableLoadedState).data, equals(mockForms));
    });
  });
}

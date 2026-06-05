import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_first_inspection/features/inspection_form/data/datasources/inspection_form_local_data_source.dart';
import 'package:offline_first_inspection/features/inspection_form/domain/dtos/inspection_form_dto.dart';

//see : https://pub.dev/packages/mocktail
class MockInspectionFormLocalDataSource extends Mock
    implements IInspectionFormLocalDataSource {}

Future<void> main() async {
  group('Inspection Form Local Data source', () {
    test('test mock', () async {
      // Create a mock instance
      final mock = MockInspectionFormLocalDataSource();

      when(() => mock.getAllInspections()).thenAnswer((_) async {
        return <InspectionFormDto>[];
      });

      // Verify no interactions have occurred.
      verifyNever(() => mock.getAllInspections());

      expect(await mock.getAllInspections(), <InspectionFormDto>[]);
    });
  });
}

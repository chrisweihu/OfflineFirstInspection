import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class InspectionForms extends Table {
  late final id = text()(); //uuid as string
  late final status = text()();
  late final inspector = text()();
  late final date = dateTime().nullable()();
  late final summary = text()();
  late final reviewRequired = boolean()();
  late final reviewDescription = text()();
  late final actionRequired = boolean()();
  late final actionDescription = text()();
  late final dirty = boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [InspectionForms])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'offline',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationDocumentsDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}

import 'package:drift/drift.dart';
import 'package:drift/internal/versioned_schema.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:offline_first_inspection/core/constants/constants.dart';
import 'package:offline_first_inspection/features/inspection_form/data/database.steps.dart';
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
  late final locationX = real()(); //long
  late final locationY = real()(); //lat
  late final coordSystem = text()(); //e.g Constants.coordinateSystemWGS84

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
  int get schemaVersion => 2;

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

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        // Following the advice from https://drift.simonbinder.eu/Migrations/api/#general-tips
        await customStatement('PRAGMA foreign_keys = OFF');

        await transaction(() => VersionedSchema.runMigrationSteps(migrator: m, from: from, to: to, steps: _upgrade));

        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  static final _upgrade = migrationSteps(
    from1To2: (m, schema) async {
      // Migration from 1 to 2: Add location columns in InspectionForms.
      // Use "(0,0), WGS84" as a default value.
      await m.alterTable(
        TableMigration(
          schema.inspectionForms,
          columnTransformer: {
            schema.inspectionForms.locationX: const Constant<double>(0),
            schema.inspectionForms.locationY: const Constant<double>(0),
            schema.inspectionForms.coordSystem: const Constant<String>(Constants.coordinateSystemWGS84),
          },
          newColumns: [schema.inspectionForms.locationX, schema.inspectionForms.locationY, schema.inspectionForms.coordSystem],
        ),
      );
    },
  );
}

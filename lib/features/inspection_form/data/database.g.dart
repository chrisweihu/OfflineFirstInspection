// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $InspectionFormsTable extends InspectionForms
    with TableInfo<$InspectionFormsTable, InspectionForm> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionFormsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inspectorMeta = const VerificationMeta(
    'inspector',
  );
  @override
  late final GeneratedColumn<String> inspector = GeneratedColumn<String>(
    'inspector',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reviewRequiredMeta = const VerificationMeta(
    'reviewRequired',
  );
  @override
  late final GeneratedColumn<bool> reviewRequired = GeneratedColumn<bool>(
    'review_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("review_required" IN (0, 1))',
    ),
  );
  static const VerificationMeta _reviewDescriptionMeta = const VerificationMeta(
    'reviewDescription',
  );
  @override
  late final GeneratedColumn<String> reviewDescription =
      GeneratedColumn<String>(
        'review_description',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _actionRequiredMeta = const VerificationMeta(
    'actionRequired',
  );
  @override
  late final GeneratedColumn<bool> actionRequired = GeneratedColumn<bool>(
    'action_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("action_required" IN (0, 1))',
    ),
  );
  static const VerificationMeta _actionDescriptionMeta = const VerificationMeta(
    'actionDescription',
  );
  @override
  late final GeneratedColumn<String> actionDescription =
      GeneratedColumn<String>(
        'action_description',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    status,
    inspector,
    date,
    summary,
    reviewRequired,
    reviewDescription,
    actionRequired,
    actionDescription,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspection_forms';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspectionForm> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('inspector')) {
      context.handle(
        _inspectorMeta,
        inspector.isAcceptableOrUnknown(data['inspector']!, _inspectorMeta),
      );
    } else if (isInserting) {
      context.missing(_inspectorMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('review_required')) {
      context.handle(
        _reviewRequiredMeta,
        reviewRequired.isAcceptableOrUnknown(
          data['review_required']!,
          _reviewRequiredMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reviewRequiredMeta);
    }
    if (data.containsKey('review_description')) {
      context.handle(
        _reviewDescriptionMeta,
        reviewDescription.isAcceptableOrUnknown(
          data['review_description']!,
          _reviewDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reviewDescriptionMeta);
    }
    if (data.containsKey('action_required')) {
      context.handle(
        _actionRequiredMeta,
        actionRequired.isAcceptableOrUnknown(
          data['action_required']!,
          _actionRequiredMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actionRequiredMeta);
    }
    if (data.containsKey('action_description')) {
      context.handle(
        _actionDescriptionMeta,
        actionDescription.isAcceptableOrUnknown(
          data['action_description']!,
          _actionDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actionDescriptionMeta);
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    } else if (isInserting) {
      context.missing(_dirtyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InspectionForm map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspectionForm(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      inspector: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inspector'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      ),
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      reviewRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}review_required'],
      )!,
      reviewDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_description'],
      )!,
      actionRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}action_required'],
      )!,
      actionDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_description'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $InspectionFormsTable createAlias(String alias) {
    return $InspectionFormsTable(attachedDatabase, alias);
  }
}

class InspectionForm extends DataClass implements Insertable<InspectionForm> {
  final String id;
  final String status;
  final String inspector;
  final DateTime? date;
  final String summary;
  final bool reviewRequired;
  final String reviewDescription;
  final bool actionRequired;
  final String actionDescription;
  final bool dirty;
  const InspectionForm({
    required this.id,
    required this.status,
    required this.inspector,
    this.date,
    required this.summary,
    required this.reviewRequired,
    required this.reviewDescription,
    required this.actionRequired,
    required this.actionDescription,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['status'] = Variable<String>(status);
    map['inspector'] = Variable<String>(inspector);
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<DateTime>(date);
    }
    map['summary'] = Variable<String>(summary);
    map['review_required'] = Variable<bool>(reviewRequired);
    map['review_description'] = Variable<String>(reviewDescription);
    map['action_required'] = Variable<bool>(actionRequired);
    map['action_description'] = Variable<String>(actionDescription);
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  InspectionFormsCompanion toCompanion(bool nullToAbsent) {
    return InspectionFormsCompanion(
      id: Value(id),
      status: Value(status),
      inspector: Value(inspector),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      summary: Value(summary),
      reviewRequired: Value(reviewRequired),
      reviewDescription: Value(reviewDescription),
      actionRequired: Value(actionRequired),
      actionDescription: Value(actionDescription),
      dirty: Value(dirty),
    );
  }

  factory InspectionForm.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspectionForm(
      id: serializer.fromJson<String>(json['id']),
      status: serializer.fromJson<String>(json['status']),
      inspector: serializer.fromJson<String>(json['inspector']),
      date: serializer.fromJson<DateTime?>(json['date']),
      summary: serializer.fromJson<String>(json['summary']),
      reviewRequired: serializer.fromJson<bool>(json['reviewRequired']),
      reviewDescription: serializer.fromJson<String>(json['reviewDescription']),
      actionRequired: serializer.fromJson<bool>(json['actionRequired']),
      actionDescription: serializer.fromJson<String>(json['actionDescription']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'status': serializer.toJson<String>(status),
      'inspector': serializer.toJson<String>(inspector),
      'date': serializer.toJson<DateTime?>(date),
      'summary': serializer.toJson<String>(summary),
      'reviewRequired': serializer.toJson<bool>(reviewRequired),
      'reviewDescription': serializer.toJson<String>(reviewDescription),
      'actionRequired': serializer.toJson<bool>(actionRequired),
      'actionDescription': serializer.toJson<String>(actionDescription),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  InspectionForm copyWith({
    String? id,
    String? status,
    String? inspector,
    Value<DateTime?> date = const Value.absent(),
    String? summary,
    bool? reviewRequired,
    String? reviewDescription,
    bool? actionRequired,
    String? actionDescription,
    bool? dirty,
  }) => InspectionForm(
    id: id ?? this.id,
    status: status ?? this.status,
    inspector: inspector ?? this.inspector,
    date: date.present ? date.value : this.date,
    summary: summary ?? this.summary,
    reviewRequired: reviewRequired ?? this.reviewRequired,
    reviewDescription: reviewDescription ?? this.reviewDescription,
    actionRequired: actionRequired ?? this.actionRequired,
    actionDescription: actionDescription ?? this.actionDescription,
    dirty: dirty ?? this.dirty,
  );
  InspectionForm copyWithCompanion(InspectionFormsCompanion data) {
    return InspectionForm(
      id: data.id.present ? data.id.value : this.id,
      status: data.status.present ? data.status.value : this.status,
      inspector: data.inspector.present ? data.inspector.value : this.inspector,
      date: data.date.present ? data.date.value : this.date,
      summary: data.summary.present ? data.summary.value : this.summary,
      reviewRequired: data.reviewRequired.present
          ? data.reviewRequired.value
          : this.reviewRequired,
      reviewDescription: data.reviewDescription.present
          ? data.reviewDescription.value
          : this.reviewDescription,
      actionRequired: data.actionRequired.present
          ? data.actionRequired.value
          : this.actionRequired,
      actionDescription: data.actionDescription.present
          ? data.actionDescription.value
          : this.actionDescription,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspectionForm(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('inspector: $inspector, ')
          ..write('date: $date, ')
          ..write('summary: $summary, ')
          ..write('reviewRequired: $reviewRequired, ')
          ..write('reviewDescription: $reviewDescription, ')
          ..write('actionRequired: $actionRequired, ')
          ..write('actionDescription: $actionDescription, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    status,
    inspector,
    date,
    summary,
    reviewRequired,
    reviewDescription,
    actionRequired,
    actionDescription,
    dirty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspectionForm &&
          other.id == this.id &&
          other.status == this.status &&
          other.inspector == this.inspector &&
          other.date == this.date &&
          other.summary == this.summary &&
          other.reviewRequired == this.reviewRequired &&
          other.reviewDescription == this.reviewDescription &&
          other.actionRequired == this.actionRequired &&
          other.actionDescription == this.actionDescription &&
          other.dirty == this.dirty);
}

class InspectionFormsCompanion extends UpdateCompanion<InspectionForm> {
  final Value<String> id;
  final Value<String> status;
  final Value<String> inspector;
  final Value<DateTime?> date;
  final Value<String> summary;
  final Value<bool> reviewRequired;
  final Value<String> reviewDescription;
  final Value<bool> actionRequired;
  final Value<String> actionDescription;
  final Value<bool> dirty;
  final Value<int> rowid;
  const InspectionFormsCompanion({
    this.id = const Value.absent(),
    this.status = const Value.absent(),
    this.inspector = const Value.absent(),
    this.date = const Value.absent(),
    this.summary = const Value.absent(),
    this.reviewRequired = const Value.absent(),
    this.reviewDescription = const Value.absent(),
    this.actionRequired = const Value.absent(),
    this.actionDescription = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InspectionFormsCompanion.insert({
    required String id,
    required String status,
    required String inspector,
    this.date = const Value.absent(),
    required String summary,
    required bool reviewRequired,
    required String reviewDescription,
    required bool actionRequired,
    required String actionDescription,
    required bool dirty,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       status = Value(status),
       inspector = Value(inspector),
       summary = Value(summary),
       reviewRequired = Value(reviewRequired),
       reviewDescription = Value(reviewDescription),
       actionRequired = Value(actionRequired),
       actionDescription = Value(actionDescription),
       dirty = Value(dirty);
  static Insertable<InspectionForm> custom({
    Expression<String>? id,
    Expression<String>? status,
    Expression<String>? inspector,
    Expression<DateTime>? date,
    Expression<String>? summary,
    Expression<bool>? reviewRequired,
    Expression<String>? reviewDescription,
    Expression<bool>? actionRequired,
    Expression<String>? actionDescription,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (status != null) 'status': status,
      if (inspector != null) 'inspector': inspector,
      if (date != null) 'date': date,
      if (summary != null) 'summary': summary,
      if (reviewRequired != null) 'review_required': reviewRequired,
      if (reviewDescription != null) 'review_description': reviewDescription,
      if (actionRequired != null) 'action_required': actionRequired,
      if (actionDescription != null) 'action_description': actionDescription,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InspectionFormsCompanion copyWith({
    Value<String>? id,
    Value<String>? status,
    Value<String>? inspector,
    Value<DateTime?>? date,
    Value<String>? summary,
    Value<bool>? reviewRequired,
    Value<String>? reviewDescription,
    Value<bool>? actionRequired,
    Value<String>? actionDescription,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return InspectionFormsCompanion(
      id: id ?? this.id,
      status: status ?? this.status,
      inspector: inspector ?? this.inspector,
      date: date ?? this.date,
      summary: summary ?? this.summary,
      reviewRequired: reviewRequired ?? this.reviewRequired,
      reviewDescription: reviewDescription ?? this.reviewDescription,
      actionRequired: actionRequired ?? this.actionRequired,
      actionDescription: actionDescription ?? this.actionDescription,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (inspector.present) {
      map['inspector'] = Variable<String>(inspector.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (reviewRequired.present) {
      map['review_required'] = Variable<bool>(reviewRequired.value);
    }
    if (reviewDescription.present) {
      map['review_description'] = Variable<String>(reviewDescription.value);
    }
    if (actionRequired.present) {
      map['action_required'] = Variable<bool>(actionRequired.value);
    }
    if (actionDescription.present) {
      map['action_description'] = Variable<String>(actionDescription.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionFormsCompanion(')
          ..write('id: $id, ')
          ..write('status: $status, ')
          ..write('inspector: $inspector, ')
          ..write('date: $date, ')
          ..write('summary: $summary, ')
          ..write('reviewRequired: $reviewRequired, ')
          ..write('reviewDescription: $reviewDescription, ')
          ..write('actionRequired: $actionRequired, ')
          ..write('actionDescription: $actionDescription, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $InspectionFormsTable inspectionForms = $InspectionFormsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [inspectionForms];
}

typedef $$InspectionFormsTableCreateCompanionBuilder =
    InspectionFormsCompanion Function({
      required String id,
      required String status,
      required String inspector,
      Value<DateTime?> date,
      required String summary,
      required bool reviewRequired,
      required String reviewDescription,
      required bool actionRequired,
      required String actionDescription,
      required bool dirty,
      Value<int> rowid,
    });
typedef $$InspectionFormsTableUpdateCompanionBuilder =
    InspectionFormsCompanion Function({
      Value<String> id,
      Value<String> status,
      Value<String> inspector,
      Value<DateTime?> date,
      Value<String> summary,
      Value<bool> reviewRequired,
      Value<String> reviewDescription,
      Value<bool> actionRequired,
      Value<String> actionDescription,
      Value<bool> dirty,
      Value<int> rowid,
    });

class $$InspectionFormsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionFormsTable> {
  $$InspectionFormsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inspector => $composableBuilder(
    column: $table.inspector,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reviewRequired => $composableBuilder(
    column: $table.reviewRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewDescription => $composableBuilder(
    column: $table.reviewDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get actionRequired => $composableBuilder(
    column: $table.actionRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionDescription => $composableBuilder(
    column: $table.actionDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InspectionFormsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionFormsTable> {
  $$InspectionFormsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inspector => $composableBuilder(
    column: $table.inspector,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reviewRequired => $composableBuilder(
    column: $table.reviewRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewDescription => $composableBuilder(
    column: $table.reviewDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get actionRequired => $composableBuilder(
    column: $table.actionRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionDescription => $composableBuilder(
    column: $table.actionDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InspectionFormsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionFormsTable> {
  $$InspectionFormsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get inspector =>
      $composableBuilder(column: $table.inspector, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<bool> get reviewRequired => $composableBuilder(
    column: $table.reviewRequired,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewDescription => $composableBuilder(
    column: $table.reviewDescription,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get actionRequired => $composableBuilder(
    column: $table.actionRequired,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionDescription => $composableBuilder(
    column: $table.actionDescription,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$InspectionFormsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionFormsTable,
          InspectionForm,
          $$InspectionFormsTableFilterComposer,
          $$InspectionFormsTableOrderingComposer,
          $$InspectionFormsTableAnnotationComposer,
          $$InspectionFormsTableCreateCompanionBuilder,
          $$InspectionFormsTableUpdateCompanionBuilder,
          (
            InspectionForm,
            BaseReferences<
              _$AppDatabase,
              $InspectionFormsTable,
              InspectionForm
            >,
          ),
          InspectionForm,
          PrefetchHooks Function()
        > {
  $$InspectionFormsTableTableManager(
    _$AppDatabase db,
    $InspectionFormsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionFormsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionFormsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionFormsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> inspector = const Value.absent(),
                Value<DateTime?> date = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<bool> reviewRequired = const Value.absent(),
                Value<String> reviewDescription = const Value.absent(),
                Value<bool> actionRequired = const Value.absent(),
                Value<String> actionDescription = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InspectionFormsCompanion(
                id: id,
                status: status,
                inspector: inspector,
                date: date,
                summary: summary,
                reviewRequired: reviewRequired,
                reviewDescription: reviewDescription,
                actionRequired: actionRequired,
                actionDescription: actionDescription,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String status,
                required String inspector,
                Value<DateTime?> date = const Value.absent(),
                required String summary,
                required bool reviewRequired,
                required String reviewDescription,
                required bool actionRequired,
                required String actionDescription,
                required bool dirty,
                Value<int> rowid = const Value.absent(),
              }) => InspectionFormsCompanion.insert(
                id: id,
                status: status,
                inspector: inspector,
                date: date,
                summary: summary,
                reviewRequired: reviewRequired,
                reviewDescription: reviewDescription,
                actionRequired: actionRequired,
                actionDescription: actionDescription,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InspectionFormsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionFormsTable,
      InspectionForm,
      $$InspectionFormsTableFilterComposer,
      $$InspectionFormsTableOrderingComposer,
      $$InspectionFormsTableAnnotationComposer,
      $$InspectionFormsTableCreateCompanionBuilder,
      $$InspectionFormsTableUpdateCompanionBuilder,
      (
        InspectionForm,
        BaseReferences<_$AppDatabase, $InspectionFormsTable, InspectionForm>,
      ),
      InspectionForm,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$InspectionFormsTableTableManager get inspectionForms =>
      $$InspectionFormsTableTableManager(_db, _db.inspectionForms);
}

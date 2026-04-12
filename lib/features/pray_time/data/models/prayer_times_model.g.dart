// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: experimental_member_use

part of 'prayer_times_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPrayerTimesModelCollection on Isar {
  IsarCollection<PrayerTimesModel> get prayerTimesModels => this.collection();
}

const PrayerTimesModelSchema = CollectionSchema(
  name: r'PrayerTimesModel',
  id: 5717370750754320027,
  properties: {
    r'asrMinutes': PropertySchema(
      id: 0,
      name: r'asrMinutes',
      type: IsarType.long,
    ),
    r'date': PropertySchema(id: 1, name: r'date', type: IsarType.dateTime),
    r'dhuhrMinutes': PropertySchema(
      id: 2,
      name: r'dhuhrMinutes',
      type: IsarType.long,
    ),
    r'fajrMinutes': PropertySchema(
      id: 3,
      name: r'fajrMinutes',
      type: IsarType.long,
    ),
    r'ishaMinutes': PropertySchema(
      id: 4,
      name: r'ishaMinutes',
      type: IsarType.long,
    ),
    r'maghribMinutes': PropertySchema(
      id: 5,
      name: r'maghribMinutes',
      type: IsarType.long,
    ),
    r'sunriseMinutes': PropertySchema(
      id: 6,
      name: r'sunriseMinutes',
      type: IsarType.long,
    ),
  },
  estimateSize: _prayerTimesModelEstimateSize,
  serialize: _prayerTimesModelSerialize,
  deserialize: _prayerTimesModelDeserialize,
  deserializeProp: _prayerTimesModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _prayerTimesModelGetId,
  getLinks: _prayerTimesModelGetLinks,
  attach: _prayerTimesModelAttach,
  version: '3.1.0+1',
);

int _prayerTimesModelEstimateSize(
  PrayerTimesModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _prayerTimesModelSerialize(
  PrayerTimesModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.asrMinutes);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeLong(offsets[2], object.dhuhrMinutes);
  writer.writeLong(offsets[3], object.fajrMinutes);
  writer.writeLong(offsets[4], object.ishaMinutes);
  writer.writeLong(offsets[5], object.maghribMinutes);
  writer.writeLong(offsets[6], object.sunriseMinutes);
}

PrayerTimesModel _prayerTimesModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PrayerTimesModel();
  object.asrMinutes = reader.readLong(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.dhuhrMinutes = reader.readLong(offsets[2]);
  object.fajrMinutes = reader.readLong(offsets[3]);
  object.id = id;
  object.ishaMinutes = reader.readLong(offsets[4]);
  object.maghribMinutes = reader.readLong(offsets[5]);
  object.sunriseMinutes = reader.readLong(offsets[6]);
  return object;
}

P _prayerTimesModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _prayerTimesModelGetId(PrayerTimesModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _prayerTimesModelGetLinks(PrayerTimesModel object) {
  return [];
}

void _prayerTimesModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  PrayerTimesModel object,
) {
  object.id = id;
}

extension PrayerTimesModelByIndex on IsarCollection<PrayerTimesModel> {
  Future<PrayerTimesModel?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  PrayerTimesModel? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<PrayerTimesModel?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<PrayerTimesModel?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(PrayerTimesModel object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(PrayerTimesModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<PrayerTimesModel> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(
    List<PrayerTimesModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension PrayerTimesModelQueryWhereSort
    on QueryBuilder<PrayerTimesModel, PrayerTimesModel, QWhere> {
  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension PrayerTimesModelQueryWhere
    on QueryBuilder<PrayerTimesModel, PrayerTimesModel, QWhereClause> {
  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterWhereClause>
  dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'date', value: [date]),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterWhereClause>
  dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [],
                upper: [date],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [date],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [date],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [],
                upper: [date],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterWhereClause>
  dateGreaterThan(DateTime date, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [date],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterWhereClause>
  dateLessThan(DateTime date, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [],
          upper: [date],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterWhereClause>
  dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [lowerDate],
          includeLower: includeLower,
          upper: [upperDate],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PrayerTimesModelQueryFilter
    on QueryBuilder<PrayerTimesModel, PrayerTimesModel, QFilterCondition> {
  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  asrMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'asrMinutes', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  asrMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'asrMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  asrMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'asrMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  asrMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'asrMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  dateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  dateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'date',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  dhuhrMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dhuhrMinutes', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  dhuhrMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dhuhrMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  dhuhrMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dhuhrMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  dhuhrMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dhuhrMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  fajrMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fajrMinutes', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  fajrMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fajrMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  fajrMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fajrMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  fajrMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fajrMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  ishaMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ishaMinutes', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  ishaMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ishaMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  ishaMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ishaMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  ishaMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ishaMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  maghribMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'maghribMinutes', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  maghribMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'maghribMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  maghribMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'maghribMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  maghribMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'maghribMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  sunriseMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sunriseMinutes', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  sunriseMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sunriseMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  sunriseMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sunriseMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  sunriseMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sunriseMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PrayerTimesModelQueryObject
    on QueryBuilder<PrayerTimesModel, PrayerTimesModel, QFilterCondition> {}

extension PrayerTimesModelQueryLinks
    on QueryBuilder<PrayerTimesModel, PrayerTimesModel, QFilterCondition> {}

extension PrayerTimesModelQuerySortBy
    on QueryBuilder<PrayerTimesModel, PrayerTimesModel, QSortBy> {
  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByAsrMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrMinutes', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByAsrMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrMinutes', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByDhuhrMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrMinutes', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByDhuhrMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrMinutes', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByFajrMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrMinutes', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByFajrMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrMinutes', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByIshaMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaMinutes', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByIshaMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaMinutes', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByMaghribMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribMinutes', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByMaghribMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribMinutes', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortBySunriseMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseMinutes', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortBySunriseMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseMinutes', Sort.desc);
    });
  }
}

extension PrayerTimesModelQuerySortThenBy
    on QueryBuilder<PrayerTimesModel, PrayerTimesModel, QSortThenBy> {
  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByAsrMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrMinutes', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByAsrMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrMinutes', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByDhuhrMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrMinutes', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByDhuhrMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrMinutes', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByFajrMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrMinutes', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByFajrMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrMinutes', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByIshaMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaMinutes', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByIshaMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaMinutes', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByMaghribMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribMinutes', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByMaghribMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribMinutes', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenBySunriseMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseMinutes', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenBySunriseMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseMinutes', Sort.desc);
    });
  }
}

extension PrayerTimesModelQueryWhereDistinct
    on QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct> {
  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct>
  distinctByAsrMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'asrMinutes');
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct>
  distinctByDhuhrMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dhuhrMinutes');
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct>
  distinctByFajrMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fajrMinutes');
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct>
  distinctByIshaMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ishaMinutes');
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct>
  distinctByMaghribMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maghribMinutes');
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct>
  distinctBySunriseMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sunriseMinutes');
    });
  }
}

extension PrayerTimesModelQueryProperty
    on QueryBuilder<PrayerTimesModel, PrayerTimesModel, QQueryProperty> {
  QueryBuilder<PrayerTimesModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PrayerTimesModel, int, QQueryOperations> asrMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'asrMinutes');
    });
  }

  QueryBuilder<PrayerTimesModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<PrayerTimesModel, int, QQueryOperations> dhuhrMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dhuhrMinutes');
    });
  }

  QueryBuilder<PrayerTimesModel, int, QQueryOperations> fajrMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fajrMinutes');
    });
  }

  QueryBuilder<PrayerTimesModel, int, QQueryOperations> ishaMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ishaMinutes');
    });
  }

  QueryBuilder<PrayerTimesModel, int, QQueryOperations>
  maghribMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maghribMinutes');
    });
  }

  QueryBuilder<PrayerTimesModel, int, QQueryOperations>
  sunriseMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sunriseMinutes');
    });
  }
}

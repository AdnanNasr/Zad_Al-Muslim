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
    r'asr': PropertySchema(id: 0, name: r'asr', type: IsarType.dateTime),
    r'date': PropertySchema(id: 1, name: r'date', type: IsarType.dateTime),
    r'dhuhr': PropertySchema(id: 2, name: r'dhuhr', type: IsarType.dateTime),
    r'fajr': PropertySchema(id: 3, name: r'fajr', type: IsarType.dateTime),
    r'isha': PropertySchema(id: 4, name: r'isha', type: IsarType.dateTime),
    r'maghrib': PropertySchema(
      id: 5,
      name: r'maghrib',
      type: IsarType.dateTime,
    ),
    r'sunrise': PropertySchema(
      id: 6,
      name: r'sunrise',
      type: IsarType.dateTime,
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
  writer.writeDateTime(offsets[0], object.asr);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeDateTime(offsets[2], object.dhuhr);
  writer.writeDateTime(offsets[3], object.fajr);
  writer.writeDateTime(offsets[4], object.isha);
  writer.writeDateTime(offsets[5], object.maghrib);
  writer.writeDateTime(offsets[6], object.sunrise);
}

PrayerTimesModel _prayerTimesModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PrayerTimesModel();
  object.asr = reader.readDateTime(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.dhuhr = reader.readDateTime(offsets[2]);
  object.fajr = reader.readDateTime(offsets[3]);
  object.id = id;
  object.isha = reader.readDateTime(offsets[4]);
  object.maghrib = reader.readDateTime(offsets[5]);
  object.sunrise = reader.readDateTime(offsets[6]);
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
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
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
  asrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'asr', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  asrGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'asr',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  asrLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'asr',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  asrBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'asr',
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
  dhuhrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dhuhr', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  dhuhrGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dhuhr',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  dhuhrLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dhuhr',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  dhuhrBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dhuhr',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  fajrEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fajr', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  fajrGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fajr',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  fajrLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fajr',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  fajrBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fajr',
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
  ishaEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isha', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  ishaGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'isha',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  ishaLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'isha',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  ishaBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'isha',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  maghribEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'maghrib', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  maghribGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'maghrib',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  maghribLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'maghrib',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  maghribBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'maghrib',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  sunriseEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sunrise', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  sunriseGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sunrise',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  sunriseLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sunrise',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterFilterCondition>
  sunriseBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sunrise',
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
  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy> sortByAsr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asr', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByAsrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asr', Sort.desc);
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

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy> sortByDhuhr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhr', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByDhuhrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhr', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy> sortByFajr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajr', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByFajrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajr', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy> sortByIsha() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isha', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByIshaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isha', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByMaghrib() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghrib', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortByMaghribDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghrib', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortBySunrise() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunrise', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  sortBySunriseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunrise', Sort.desc);
    });
  }
}

extension PrayerTimesModelQuerySortThenBy
    on QueryBuilder<PrayerTimesModel, PrayerTimesModel, QSortThenBy> {
  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy> thenByAsr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asr', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByAsrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asr', Sort.desc);
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

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy> thenByDhuhr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhr', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByDhuhrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhr', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy> thenByFajr() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajr', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByFajrDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajr', Sort.desc);
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

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy> thenByIsha() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isha', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByIshaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isha', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByMaghrib() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghrib', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenByMaghribDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghrib', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenBySunrise() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunrise', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QAfterSortBy>
  thenBySunriseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunrise', Sort.desc);
    });
  }
}

extension PrayerTimesModelQueryWhereDistinct
    on QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct> {
  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct> distinctByAsr() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'asr');
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct>
  distinctByDhuhr() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dhuhr');
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct> distinctByFajr() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fajr');
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct> distinctByIsha() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isha');
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct>
  distinctByMaghrib() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maghrib');
    });
  }

  QueryBuilder<PrayerTimesModel, PrayerTimesModel, QDistinct>
  distinctBySunrise() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sunrise');
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

  QueryBuilder<PrayerTimesModel, DateTime, QQueryOperations> asrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'asr');
    });
  }

  QueryBuilder<PrayerTimesModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<PrayerTimesModel, DateTime, QQueryOperations> dhuhrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dhuhr');
    });
  }

  QueryBuilder<PrayerTimesModel, DateTime, QQueryOperations> fajrProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fajr');
    });
  }

  QueryBuilder<PrayerTimesModel, DateTime, QQueryOperations> ishaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isha');
    });
  }

  QueryBuilder<PrayerTimesModel, DateTime, QQueryOperations> maghribProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maghrib');
    });
  }

  QueryBuilder<PrayerTimesModel, DateTime, QQueryOperations> sunriseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sunrise');
    });
  }
}

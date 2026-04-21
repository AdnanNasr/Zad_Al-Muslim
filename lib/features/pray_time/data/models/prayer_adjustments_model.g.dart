// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_adjustments_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPrayerAdjustmentsModelCollection on Isar {
  IsarCollection<PrayerAdjustmentsModel> get prayerAdjustmentsModels =>
      this.collection();
}

const PrayerAdjustmentsModelSchema = CollectionSchema(
  name: r'PrayerAdjustmentsModel',
  id: 1874310038821533155,
  properties: {
    r'asrOffset': PropertySchema(
      id: 0,
      name: r'asrOffset',
      type: IsarType.long,
    ),
    r'dhuhrOffset': PropertySchema(
      id: 1,
      name: r'dhuhrOffset',
      type: IsarType.long,
    ),
    r'fajrOffset': PropertySchema(
      id: 2,
      name: r'fajrOffset',
      type: IsarType.long,
    ),
    r'hasAnyAdjustment': PropertySchema(
      id: 3,
      name: r'hasAnyAdjustment',
      type: IsarType.bool,
    ),
    r'ishaOffset': PropertySchema(
      id: 4,
      name: r'ishaOffset',
      type: IsarType.long,
    ),
    r'maghribOffset': PropertySchema(
      id: 5,
      name: r'maghribOffset',
      type: IsarType.long,
    ),
    r'sunriseOffset': PropertySchema(
      id: 6,
      name: r'sunriseOffset',
      type: IsarType.long,
    )
  },
  estimateSize: _prayerAdjustmentsModelEstimateSize,
  serialize: _prayerAdjustmentsModelSerialize,
  deserialize: _prayerAdjustmentsModelDeserialize,
  deserializeProp: _prayerAdjustmentsModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _prayerAdjustmentsModelGetId,
  getLinks: _prayerAdjustmentsModelGetLinks,
  attach: _prayerAdjustmentsModelAttach,
  version: '3.1.0+1',
);

int _prayerAdjustmentsModelEstimateSize(
  PrayerAdjustmentsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _prayerAdjustmentsModelSerialize(
  PrayerAdjustmentsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.asrOffset);
  writer.writeLong(offsets[1], object.dhuhrOffset);
  writer.writeLong(offsets[2], object.fajrOffset);
  writer.writeBool(offsets[3], object.hasAnyAdjustment);
  writer.writeLong(offsets[4], object.ishaOffset);
  writer.writeLong(offsets[5], object.maghribOffset);
  writer.writeLong(offsets[6], object.sunriseOffset);
}

PrayerAdjustmentsModel _prayerAdjustmentsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PrayerAdjustmentsModel();
  object.asrOffset = reader.readLong(offsets[0]);
  object.dhuhrOffset = reader.readLong(offsets[1]);
  object.fajrOffset = reader.readLong(offsets[2]);
  object.id = id;
  object.ishaOffset = reader.readLong(offsets[4]);
  object.maghribOffset = reader.readLong(offsets[5]);
  object.sunriseOffset = reader.readLong(offsets[6]);
  return object;
}

P _prayerAdjustmentsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
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

Id _prayerAdjustmentsModelGetId(PrayerAdjustmentsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _prayerAdjustmentsModelGetLinks(
    PrayerAdjustmentsModel object) {
  return [];
}

void _prayerAdjustmentsModelAttach(
    IsarCollection<dynamic> col, Id id, PrayerAdjustmentsModel object) {
  object.id = id;
}

extension PrayerAdjustmentsModelQueryWhereSort
    on QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QWhere> {
  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PrayerAdjustmentsModelQueryWhere on QueryBuilder<
    PrayerAdjustmentsModel, PrayerAdjustmentsModel, QWhereClause> {
  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PrayerAdjustmentsModelQueryFilter on QueryBuilder<
    PrayerAdjustmentsModel, PrayerAdjustmentsModel, QFilterCondition> {
  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> asrOffsetEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'asrOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> asrOffsetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'asrOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> asrOffsetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'asrOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> asrOffsetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'asrOffset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> dhuhrOffsetEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dhuhrOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> dhuhrOffsetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dhuhrOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> dhuhrOffsetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dhuhrOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> dhuhrOffsetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dhuhrOffset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> fajrOffsetEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fajrOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> fajrOffsetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fajrOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> fajrOffsetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fajrOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> fajrOffsetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fajrOffset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> hasAnyAdjustmentEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasAnyAdjustment',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> ishaOffsetEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ishaOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> ishaOffsetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ishaOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> ishaOffsetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ishaOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> ishaOffsetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ishaOffset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> maghribOffsetEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maghribOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> maghribOffsetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maghribOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> maghribOffsetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maghribOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> maghribOffsetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maghribOffset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> sunriseOffsetEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sunriseOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> sunriseOffsetGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sunriseOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> sunriseOffsetLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sunriseOffset',
        value: value,
      ));
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel,
      QAfterFilterCondition> sunriseOffsetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sunriseOffset',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension PrayerAdjustmentsModelQueryObject on QueryBuilder<
    PrayerAdjustmentsModel, PrayerAdjustmentsModel, QFilterCondition> {}

extension PrayerAdjustmentsModelQueryLinks on QueryBuilder<
    PrayerAdjustmentsModel, PrayerAdjustmentsModel, QFilterCondition> {}

extension PrayerAdjustmentsModelQuerySortBy
    on QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QSortBy> {
  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      sortByAsrOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrOffset', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      sortByAsrOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrOffset', Sort.desc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      sortByDhuhrOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrOffset', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      sortByDhuhrOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrOffset', Sort.desc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      sortByFajrOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrOffset', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      sortByFajrOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrOffset', Sort.desc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      sortByHasAnyAdjustment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasAnyAdjustment', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      sortByHasAnyAdjustmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasAnyAdjustment', Sort.desc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      sortByIshaOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaOffset', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      sortByIshaOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaOffset', Sort.desc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      sortByMaghribOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribOffset', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      sortByMaghribOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribOffset', Sort.desc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      sortBySunriseOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseOffset', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      sortBySunriseOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseOffset', Sort.desc);
    });
  }
}

extension PrayerAdjustmentsModelQuerySortThenBy on QueryBuilder<
    PrayerAdjustmentsModel, PrayerAdjustmentsModel, QSortThenBy> {
  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenByAsrOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrOffset', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenByAsrOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'asrOffset', Sort.desc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenByDhuhrOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrOffset', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenByDhuhrOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhuhrOffset', Sort.desc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenByFajrOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrOffset', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenByFajrOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fajrOffset', Sort.desc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenByHasAnyAdjustment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasAnyAdjustment', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenByHasAnyAdjustmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasAnyAdjustment', Sort.desc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenByIshaOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaOffset', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenByIshaOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ishaOffset', Sort.desc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenByMaghribOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribOffset', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenByMaghribOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maghribOffset', Sort.desc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenBySunriseOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseOffset', Sort.asc);
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QAfterSortBy>
      thenBySunriseOffsetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sunriseOffset', Sort.desc);
    });
  }
}

extension PrayerAdjustmentsModelQueryWhereDistinct
    on QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QDistinct> {
  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QDistinct>
      distinctByAsrOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'asrOffset');
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QDistinct>
      distinctByDhuhrOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dhuhrOffset');
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QDistinct>
      distinctByFajrOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fajrOffset');
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QDistinct>
      distinctByHasAnyAdjustment() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasAnyAdjustment');
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QDistinct>
      distinctByIshaOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ishaOffset');
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QDistinct>
      distinctByMaghribOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maghribOffset');
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, PrayerAdjustmentsModel, QDistinct>
      distinctBySunriseOffset() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sunriseOffset');
    });
  }
}

extension PrayerAdjustmentsModelQueryProperty on QueryBuilder<
    PrayerAdjustmentsModel, PrayerAdjustmentsModel, QQueryProperty> {
  QueryBuilder<PrayerAdjustmentsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, int, QQueryOperations>
      asrOffsetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'asrOffset');
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, int, QQueryOperations>
      dhuhrOffsetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dhuhrOffset');
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, int, QQueryOperations>
      fajrOffsetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fajrOffset');
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, bool, QQueryOperations>
      hasAnyAdjustmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasAnyAdjustment');
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, int, QQueryOperations>
      ishaOffsetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ishaOffset');
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, int, QQueryOperations>
      maghribOffsetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maghribOffset');
    });
  }

  QueryBuilder<PrayerAdjustmentsModel, int, QQueryOperations>
      sunriseOffsetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sunriseOffset');
    });
  }
}

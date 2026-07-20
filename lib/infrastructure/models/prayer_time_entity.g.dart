// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: experimental_member_use

part of 'prayer_time_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPrayerTimeEntityCollection on Isar {
  IsarCollection<PrayerTimeEntity> get prayerTimeEntitys => this.collection();
}

const PrayerTimeEntitySchema = CollectionSchema(
  name: r'PrayerTimeEntity',
  id: -7966033704213852644,
  properties: {
    r'date': PropertySchema(id: 0, name: r'date', type: IsarType.dateTime),
    r'deterministicId': PropertySchema(
      id: 1,
      name: r'deterministicId',
      type: IsarType.long,
    ),
    r'localTimezone': PropertySchema(
      id: 2,
      name: r'localTimezone',
      type: IsarType.string,
    ),
    r'prayerName': PropertySchema(
      id: 3,
      name: r'prayerName',
      type: IsarType.byte,
      enumMap: _PrayerTimeEntityprayerNameEnumValueMap,
    ),
    r'time': PropertySchema(id: 4, name: r'time', type: IsarType.dateTime),
  },

  estimateSize: _prayerTimeEntityEstimateSize,
  serialize: _prayerTimeEntitySerialize,
  deserialize: _prayerTimeEntityDeserialize,
  deserializeProp: _prayerTimeEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'deterministicId': IndexSchema(
      id: 4717108048942014545,
      name: r'deterministicId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'deterministicId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _prayerTimeEntityGetId,
  getLinks: _prayerTimeEntityGetLinks,
  attach: _prayerTimeEntityAttach,
  version: '3.3.2',
);

int _prayerTimeEntityEstimateSize(
  PrayerTimeEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.localTimezone.length * 3;
  return bytesCount;
}

void _prayerTimeEntitySerialize(
  PrayerTimeEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeLong(offsets[1], object.deterministicId);
  writer.writeString(offsets[2], object.localTimezone);
  writer.writeByte(offsets[3], object.prayerName.index);
  writer.writeDateTime(offsets[4], object.time);
}

PrayerTimeEntity _prayerTimeEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PrayerTimeEntity();
  object.date = reader.readDateTime(offsets[0]);
  object.deterministicId = reader.readLong(offsets[1]);
  object.id = id;
  object.localTimezone = reader.readString(offsets[2]);
  object.prayerName =
      _PrayerTimeEntityprayerNameValueEnumMap[reader.readByteOrNull(
        offsets[3],
      )] ??
      PrayerName.fajr;
  object.time = reader.readDateTime(offsets[4]);
  return object;
}

P _prayerTimeEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (_PrayerTimeEntityprayerNameValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              PrayerName.fajr)
          as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _PrayerTimeEntityprayerNameEnumValueMap = {
  'fajr': 0,
  'sunrise': 1,
  'dhuhr': 2,
  'asr': 3,
  'maghrib': 4,
  'isha': 5,
};
const _PrayerTimeEntityprayerNameValueEnumMap = {
  0: PrayerName.fajr,
  1: PrayerName.sunrise,
  2: PrayerName.dhuhr,
  3: PrayerName.asr,
  4: PrayerName.maghrib,
  5: PrayerName.isha,
};

Id _prayerTimeEntityGetId(PrayerTimeEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _prayerTimeEntityGetLinks(PrayerTimeEntity object) {
  return [];
}

void _prayerTimeEntityAttach(
  IsarCollection<dynamic> col,
  Id id,
  PrayerTimeEntity object,
) {
  object.id = id;
}

extension PrayerTimeEntityByIndex on IsarCollection<PrayerTimeEntity> {
  Future<PrayerTimeEntity?> getByDeterministicId(int deterministicId) {
    return getByIndex(r'deterministicId', [deterministicId]);
  }

  PrayerTimeEntity? getByDeterministicIdSync(int deterministicId) {
    return getByIndexSync(r'deterministicId', [deterministicId]);
  }

  Future<bool> deleteByDeterministicId(int deterministicId) {
    return deleteByIndex(r'deterministicId', [deterministicId]);
  }

  bool deleteByDeterministicIdSync(int deterministicId) {
    return deleteByIndexSync(r'deterministicId', [deterministicId]);
  }

  Future<List<PrayerTimeEntity?>> getAllByDeterministicId(
    List<int> deterministicIdValues,
  ) {
    final values = deterministicIdValues.map((e) => [e]).toList();
    // ignore: experimental_member_use
    return getAllByIndex(r'deterministicId', values);
  }

  List<PrayerTimeEntity?> getAllByDeterministicIdSync(
    List<int> deterministicIdValues,
  ) {
    final values = deterministicIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'deterministicId', values);
  }

  Future<int> deleteAllByDeterministicId(List<int> deterministicIdValues) {
    final values = deterministicIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'deterministicId', values);
  }

  int deleteAllByDeterministicIdSync(List<int> deterministicIdValues) {
    final values = deterministicIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'deterministicId', values);
  }

  Future<Id> putByDeterministicId(PrayerTimeEntity object) {
    return putByIndex(r'deterministicId', object);
  }

  Id putByDeterministicIdSync(
    PrayerTimeEntity object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'deterministicId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDeterministicId(List<PrayerTimeEntity> objects) {
    return putAllByIndex(r'deterministicId', objects);
  }

  List<Id> putAllByDeterministicIdSync(
    List<PrayerTimeEntity> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'deterministicId', objects, saveLinks: saveLinks);
  }
}

extension PrayerTimeEntityQueryWhereSort
    on QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QWhere> {
  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterWhere>
  anyDeterministicId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'deterministicId'),
      );
    });
  }
}

extension PrayerTimeEntityQueryWhere
    on QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QWhereClause> {
  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterWhereClause>
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

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterWhereClause>
  deterministicIdEqualTo(int deterministicId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'deterministicId',
          value: [deterministicId],
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterWhereClause>
  deterministicIdNotEqualTo(int deterministicId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deterministicId',
                lower: [],
                upper: [deterministicId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deterministicId',
                lower: [deterministicId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deterministicId',
                lower: [deterministicId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'deterministicId',
                lower: [],
                upper: [deterministicId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterWhereClause>
  deterministicIdGreaterThan(int deterministicId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'deterministicId',
          lower: [deterministicId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterWhereClause>
  deterministicIdLessThan(int deterministicId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'deterministicId',
          lower: [],
          upper: [deterministicId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterWhereClause>
  deterministicIdBetween(
    int lowerDeterministicId,
    int upperDeterministicId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'deterministicId',
          lower: [lowerDeterministicId],
          includeLower: includeLower,
          upper: [upperDeterministicId],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PrayerTimeEntityQueryFilter
    on QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QFilterCondition> {
  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
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

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
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

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
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

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  deterministicIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deterministicId', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  deterministicIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deterministicId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  deterministicIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deterministicId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  deterministicIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deterministicId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
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

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
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

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
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

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  localTimezoneEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'localTimezone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  localTimezoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'localTimezone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  localTimezoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'localTimezone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  localTimezoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'localTimezone',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  localTimezoneStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'localTimezone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  localTimezoneEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'localTimezone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  localTimezoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'localTimezone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  localTimezoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'localTimezone',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  localTimezoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'localTimezone', value: ''),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  localTimezoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'localTimezone', value: ''),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  prayerNameEqualTo(PrayerName value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'prayerName', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  prayerNameGreaterThan(PrayerName value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'prayerName',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  prayerNameLessThan(PrayerName value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'prayerName',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  prayerNameBetween(
    PrayerName lower,
    PrayerName upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'prayerName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  timeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'time', value: value),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  timeGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'time',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  timeLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'time',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterFilterCondition>
  timeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'time',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PrayerTimeEntityQueryObject
    on QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QFilterCondition> {}

extension PrayerTimeEntityQueryLinks
    on QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QFilterCondition> {}

extension PrayerTimeEntityQuerySortBy
    on QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QSortBy> {
  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  sortByDeterministicId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deterministicId', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  sortByDeterministicIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deterministicId', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  sortByLocalTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localTimezone', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  sortByLocalTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localTimezone', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  sortByPrayerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerName', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  sortByPrayerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerName', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy> sortByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  sortByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }
}

extension PrayerTimeEntityQuerySortThenBy
    on QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QSortThenBy> {
  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  thenByDeterministicId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deterministicId', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  thenByDeterministicIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deterministicId', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  thenByLocalTimezone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localTimezone', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  thenByLocalTimezoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localTimezone', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  thenByPrayerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerName', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  thenByPrayerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prayerName', Sort.desc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy> thenByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.asc);
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QAfterSortBy>
  thenByTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'time', Sort.desc);
    });
  }
}

extension PrayerTimeEntityQueryWhereDistinct
    on QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QDistinct> {
  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QDistinct>
  distinctByDeterministicId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deterministicId');
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QDistinct>
  distinctByLocalTimezone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'localTimezone',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QDistinct>
  distinctByPrayerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prayerName');
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QDistinct> distinctByTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'time');
    });
  }
}

extension PrayerTimeEntityQueryProperty
    on QueryBuilder<PrayerTimeEntity, PrayerTimeEntity, QQueryProperty> {
  QueryBuilder<PrayerTimeEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PrayerTimeEntity, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<PrayerTimeEntity, int, QQueryOperations>
  deterministicIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deterministicId');
    });
  }

  QueryBuilder<PrayerTimeEntity, String, QQueryOperations>
  localTimezoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localTimezone');
    });
  }

  QueryBuilder<PrayerTimeEntity, PrayerName, QQueryOperations>
  prayerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prayerName');
    });
  }

  QueryBuilder<PrayerTimeEntity, DateTime, QQueryOperations> timeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'time');
    });
  }
}

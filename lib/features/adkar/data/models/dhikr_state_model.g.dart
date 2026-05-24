// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: experimental_member_use

part of 'dhikr_state_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDhikrStateModelCollection on Isar {
  IsarCollection<DhikrStateModel> get dhikrStateModels => this.collection();
}

const DhikrStateModelSchema = CollectionSchema(
  name: r'DhikrStateModel',
  id: 1798232581178000100,
  properties: {
    r'date': PropertySchema(id: 0, name: r'date', type: IsarType.dateTime),
    r'dhikrId': PropertySchema(id: 1, name: r'dhikrId', type: IsarType.string),
    r'remainingCount': PropertySchema(
      id: 2,
      name: r'remainingCount',
      type: IsarType.long,
    ),
  },
  estimateSize: _dhikrStateModelEstimateSize,
  serialize: _dhikrStateModelSerialize,
  deserialize: _dhikrStateModelDeserialize,
  deserializeProp: _dhikrStateModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'dhikrId': IndexSchema(
      id: -815728071144305379,
      name: r'dhikrId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'dhikrId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},
  getId: _dhikrStateModelGetId,
  getLinks: _dhikrStateModelGetLinks,
  attach: _dhikrStateModelAttach,
  version: '3.1.0+1',
);

int _dhikrStateModelEstimateSize(
  DhikrStateModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dhikrId.length * 3;
  return bytesCount;
}

void _dhikrStateModelSerialize(
  DhikrStateModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeString(offsets[1], object.dhikrId);
  writer.writeLong(offsets[2], object.remainingCount);
}

DhikrStateModel _dhikrStateModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DhikrStateModel();
  object.date = reader.readDateTime(offsets[0]);
  object.dhikrId = reader.readString(offsets[1]);
  object.id = id;
  object.remainingCount = reader.readLong(offsets[2]);
  return object;
}

P _dhikrStateModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dhikrStateModelGetId(DhikrStateModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dhikrStateModelGetLinks(DhikrStateModel object) {
  return [];
}

void _dhikrStateModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  DhikrStateModel object,
) {
  object.id = id;
}

extension DhikrStateModelByIndex on IsarCollection<DhikrStateModel> {
  Future<DhikrStateModel?> getByDhikrId(String dhikrId) {
    return getByIndex(r'dhikrId', [dhikrId]);
  }

  DhikrStateModel? getByDhikrIdSync(String dhikrId) {
    return getByIndexSync(r'dhikrId', [dhikrId]);
  }

  Future<bool> deleteByDhikrId(String dhikrId) {
    return deleteByIndex(r'dhikrId', [dhikrId]);
  }

  bool deleteByDhikrIdSync(String dhikrId) {
    return deleteByIndexSync(r'dhikrId', [dhikrId]);
  }

  Future<List<DhikrStateModel?>> getAllByDhikrId(List<String> dhikrIdValues) {
    final values = dhikrIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'dhikrId', values);
  }

  List<DhikrStateModel?> getAllByDhikrIdSync(List<String> dhikrIdValues) {
    final values = dhikrIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'dhikrId', values);
  }

  Future<int> deleteAllByDhikrId(List<String> dhikrIdValues) {
    final values = dhikrIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'dhikrId', values);
  }

  int deleteAllByDhikrIdSync(List<String> dhikrIdValues) {
    final values = dhikrIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'dhikrId', values);
  }

  Future<Id> putByDhikrId(DhikrStateModel object) {
    return putByIndex(r'dhikrId', object);
  }

  Id putByDhikrIdSync(DhikrStateModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'dhikrId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDhikrId(List<DhikrStateModel> objects) {
    return putAllByIndex(r'dhikrId', objects);
  }

  List<Id> putAllByDhikrIdSync(
    List<DhikrStateModel> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'dhikrId', objects, saveLinks: saveLinks);
  }
}

extension DhikrStateModelQueryWhereSort
    on QueryBuilder<DhikrStateModel, DhikrStateModel, QWhere> {
  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DhikrStateModelQueryWhere
    on QueryBuilder<DhikrStateModel, DhikrStateModel, QWhereClause> {
  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterWhereClause>
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

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterWhereClause>
  dhikrIdEqualTo(String dhikrId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dhikrId', value: [dhikrId]),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterWhereClause>
  dhikrIdNotEqualTo(String dhikrId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dhikrId',
                lower: [],
                upper: [dhikrId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dhikrId',
                lower: [dhikrId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dhikrId',
                lower: [dhikrId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dhikrId',
                lower: [],
                upper: [dhikrId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension DhikrStateModelQueryFilter
    on QueryBuilder<DhikrStateModel, DhikrStateModel, QFilterCondition> {
  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
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

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
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

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
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

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  dhikrIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dhikrId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  dhikrIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dhikrId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  dhikrIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dhikrId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  dhikrIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dhikrId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  dhikrIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dhikrId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  dhikrIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dhikrId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  dhikrIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dhikrId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  dhikrIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dhikrId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  dhikrIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dhikrId', value: ''),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  dhikrIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dhikrId', value: ''),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
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

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
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

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
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

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  remainingCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'remainingCount', value: value),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  remainingCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'remainingCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  remainingCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'remainingCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterFilterCondition>
  remainingCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'remainingCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DhikrStateModelQueryObject
    on QueryBuilder<DhikrStateModel, DhikrStateModel, QFilterCondition> {}

extension DhikrStateModelQueryLinks
    on QueryBuilder<DhikrStateModel, DhikrStateModel, QFilterCondition> {}

extension DhikrStateModelQuerySortBy
    on QueryBuilder<DhikrStateModel, DhikrStateModel, QSortBy> {
  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterSortBy> sortByDhikrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhikrId', Sort.asc);
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterSortBy>
  sortByDhikrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhikrId', Sort.desc);
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterSortBy>
  sortByRemainingCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingCount', Sort.asc);
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterSortBy>
  sortByRemainingCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingCount', Sort.desc);
    });
  }
}

extension DhikrStateModelQuerySortThenBy
    on QueryBuilder<DhikrStateModel, DhikrStateModel, QSortThenBy> {
  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterSortBy> thenByDhikrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhikrId', Sort.asc);
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterSortBy>
  thenByDhikrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dhikrId', Sort.desc);
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterSortBy>
  thenByRemainingCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingCount', Sort.asc);
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QAfterSortBy>
  thenByRemainingCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingCount', Sort.desc);
    });
  }
}

extension DhikrStateModelQueryWhereDistinct
    on QueryBuilder<DhikrStateModel, DhikrStateModel, QDistinct> {
  QueryBuilder<DhikrStateModel, DhikrStateModel, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QDistinct> distinctByDhikrId({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dhikrId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DhikrStateModel, DhikrStateModel, QDistinct>
  distinctByRemainingCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remainingCount');
    });
  }
}

extension DhikrStateModelQueryProperty
    on QueryBuilder<DhikrStateModel, DhikrStateModel, QQueryProperty> {
  QueryBuilder<DhikrStateModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DhikrStateModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DhikrStateModel, String, QQueryOperations> dhikrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dhikrId');
    });
  }

  QueryBuilder<DhikrStateModel, int, QQueryOperations>
  remainingCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remainingCount');
    });
  }
}

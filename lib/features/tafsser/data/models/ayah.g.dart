// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ayah.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAyahTafsserCollection on Isar {
  IsarCollection<AyahTafsser> get ayahTafssers => this.collection();
}

const AyahTafsserSchema = CollectionSchema(
  name: r'AyahTafsser',
  id: 7675602087250390918,
  properties: {
    r'number': PropertySchema(id: 0, name: r'number', type: IsarType.long),
    r'numberInSurah': PropertySchema(
      id: 1,
      name: r'numberInSurah',
      type: IsarType.long,
    ),
    r'text': PropertySchema(id: 2, name: r'text', type: IsarType.string),
  },

  estimateSize: _ayahTafsserEstimateSize,
  serialize: _ayahTafsserSerialize,
  deserialize: _ayahTafsserDeserialize,
  deserializeProp: _ayahTafsserDeserializeProp,
  idName: r'id',
  indexes: {
    r'numberInSurah': IndexSchema(
      id: 7719076524209274548,
      name: r'numberInSurah',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'numberInSurah',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {
    r'surah': LinkSchema(
      id: 9040469133095178590,
      name: r'surah',
      target: r'TafsserSurah',
      single: true,
    ),
  },
  embeddedSchemas: {},

  getId: _ayahTafsserGetId,
  getLinks: _ayahTafsserGetLinks,
  attach: _ayahTafsserAttach,
  version: '3.3.2',
);

int _ayahTafsserEstimateSize(
  AyahTafsser object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.text.length * 3;
  return bytesCount;
}

void _ayahTafsserSerialize(
  AyahTafsser object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.number);
  writer.writeLong(offsets[1], object.numberInSurah);
  writer.writeString(offsets[2], object.text);
}

AyahTafsser _ayahTafsserDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AyahTafsser();
  object.id = id;
  object.number = reader.readLong(offsets[0]);
  object.numberInSurah = reader.readLong(offsets[1]);
  object.text = reader.readString(offsets[2]);
  return object;
}

P _ayahTafsserDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _ayahTafsserGetId(AyahTafsser object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _ayahTafsserGetLinks(AyahTafsser object) {
  return [object.surah];
}

void _ayahTafsserAttach(
  IsarCollection<dynamic> col,
  Id id,
  AyahTafsser object,
) {
  object.id = id;
  object.surah.attach(col, col.isar.collection<TafsserSurah>(), r'surah', id);
}

extension AyahTafsserQueryWhereSort
    on QueryBuilder<AyahTafsser, AyahTafsser, QWhere> {
  QueryBuilder<AyahTafsser, AyahTafsser, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterWhere> anyNumberInSurah() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'numberInSurah'),
      );
    });
  }
}

extension AyahTafsserQueryWhere
    on QueryBuilder<AyahTafsser, AyahTafsser, QWhereClause> {
  QueryBuilder<AyahTafsser, AyahTafsser, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterWhereClause> idBetween(
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

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterWhereClause>
  numberInSurahEqualTo(int numberInSurah) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'numberInSurah',
          value: [numberInSurah],
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterWhereClause>
  numberInSurahNotEqualTo(int numberInSurah) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'numberInSurah',
                lower: [],
                upper: [numberInSurah],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'numberInSurah',
                lower: [numberInSurah],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'numberInSurah',
                lower: [numberInSurah],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'numberInSurah',
                lower: [],
                upper: [numberInSurah],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterWhereClause>
  numberInSurahGreaterThan(int numberInSurah, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'numberInSurah',
          lower: [numberInSurah],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterWhereClause>
  numberInSurahLessThan(int numberInSurah, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'numberInSurah',
          lower: [],
          upper: [numberInSurah],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterWhereClause>
  numberInSurahBetween(
    int lowerNumberInSurah,
    int upperNumberInSurah, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'numberInSurah',
          lower: [lowerNumberInSurah],
          includeLower: includeLower,
          upper: [upperNumberInSurah],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AyahTafsserQueryFilter
    on QueryBuilder<AyahTafsser, AyahTafsser, QFilterCondition> {
  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> numberEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'number', value: value),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition>
  numberGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'number',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> numberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'number',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> numberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'number',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition>
  numberInSurahEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'numberInSurah', value: value),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition>
  numberInSurahGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'numberInSurah',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition>
  numberInSurahLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'numberInSurah',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition>
  numberInSurahBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'numberInSurah',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> textEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> textGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> textLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> textBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'text',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> textContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> textMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'text',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition>
  textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'text', value: ''),
      );
    });
  }
}

extension AyahTafsserQueryObject
    on QueryBuilder<AyahTafsser, AyahTafsser, QFilterCondition> {}

extension AyahTafsserQueryLinks
    on QueryBuilder<AyahTafsser, AyahTafsser, QFilterCondition> {
  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> surah(
    FilterQuery<TafsserSurah> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'surah');
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterFilterCondition> surahIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'surah', 0, true, 0, true);
    });
  }
}

extension AyahTafsserQuerySortBy
    on QueryBuilder<AyahTafsser, AyahTafsser, QSortBy> {
  QueryBuilder<AyahTafsser, AyahTafsser, QAfterSortBy> sortByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.asc);
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterSortBy> sortByNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.desc);
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterSortBy> sortByNumberInSurah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberInSurah', Sort.asc);
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterSortBy>
  sortByNumberInSurahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberInSurah', Sort.desc);
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension AyahTafsserQuerySortThenBy
    on QueryBuilder<AyahTafsser, AyahTafsser, QSortThenBy> {
  QueryBuilder<AyahTafsser, AyahTafsser, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterSortBy> thenByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.asc);
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterSortBy> thenByNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.desc);
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterSortBy> thenByNumberInSurah() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberInSurah', Sort.asc);
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterSortBy>
  thenByNumberInSurahDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberInSurah', Sort.desc);
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }
}

extension AyahTafsserQueryWhereDistinct
    on QueryBuilder<AyahTafsser, AyahTafsser, QDistinct> {
  QueryBuilder<AyahTafsser, AyahTafsser, QDistinct> distinctByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'number');
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QDistinct> distinctByNumberInSurah() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numberInSurah');
    });
  }

  QueryBuilder<AyahTafsser, AyahTafsser, QDistinct> distinctByText({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }
}

extension AyahTafsserQueryProperty
    on QueryBuilder<AyahTafsser, AyahTafsser, QQueryProperty> {
  QueryBuilder<AyahTafsser, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AyahTafsser, int, QQueryOperations> numberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'number');
    });
  }

  QueryBuilder<AyahTafsser, int, QQueryOperations> numberInSurahProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numberInSurah');
    });
  }

  QueryBuilder<AyahTafsser, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }
}

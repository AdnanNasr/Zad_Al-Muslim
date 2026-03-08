// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHadithCollection on Isar {
  IsarCollection<Hadith> get hadiths => this.collection();
}

const HadithSchema = CollectionSchema(
  name: r'Hadith',
  id: 763918714827488792,
  properties: {
    r'book': PropertySchema(
      id: 0,
      name: r'book',
      type: IsarType.string,
    ),
    r'grade': PropertySchema(
      id: 1,
      name: r'grade',
      type: IsarType.byte,
      enumMap: _HadithgradeEnumValueMap,
    ),
    r'hadith': PropertySchema(
      id: 2,
      name: r'hadith',
      type: IsarType.string,
    ),
    r'hadithNarrator': PropertySchema(
      id: 3,
      name: r'hadithNarrator',
      type: IsarType.string,
    ),
    r'isFeautred': PropertySchema(
      id: 4,
      name: r'isFeautred',
      type: IsarType.bool,
    ),
    r'topic': PropertySchema(
      id: 5,
      name: r'topic',
      type: IsarType.string,
    )
  },
  estimateSize: _hadithEstimateSize,
  serialize: _hadithSerialize,
  deserialize: _hadithDeserialize,
  deserializeProp: _hadithDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _hadithGetId,
  getLinks: _hadithGetLinks,
  attach: _hadithAttach,
  version: '3.1.0+1',
);

int _hadithEstimateSize(
  Hadith object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.book.length * 3;
  bytesCount += 3 + object.hadith.length * 3;
  bytesCount += 3 + object.hadithNarrator.length * 3;
  bytesCount += 3 + object.topic.length * 3;
  return bytesCount;
}

void _hadithSerialize(
  Hadith object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.book);
  writer.writeByte(offsets[1], object.grade.index);
  writer.writeString(offsets[2], object.hadith);
  writer.writeString(offsets[3], object.hadithNarrator);
  writer.writeBool(offsets[4], object.isFeautred);
  writer.writeString(offsets[5], object.topic);
}

Hadith _hadithDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Hadith();
  object.book = reader.readString(offsets[0]);
  object.grade = _HadithgradeValueEnumMap[reader.readByteOrNull(offsets[1])] ??
      HadithGrade.sahih;
  object.hadith = reader.readString(offsets[2]);
  object.hadithNarrator = reader.readString(offsets[3]);
  object.id = id;
  object.isFeautred = reader.readBool(offsets[4]);
  object.topic = reader.readString(offsets[5]);
  return object;
}

P _hadithDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (_HadithgradeValueEnumMap[reader.readByteOrNull(offset)] ??
          HadithGrade.sahih) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _HadithgradeEnumValueMap = {
  'sahih': 0,
  'hasan': 1,
  'daif': 2,
};
const _HadithgradeValueEnumMap = {
  0: HadithGrade.sahih,
  1: HadithGrade.hasan,
  2: HadithGrade.daif,
};

Id _hadithGetId(Hadith object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _hadithGetLinks(Hadith object) {
  return [];
}

void _hadithAttach(IsarCollection<dynamic> col, Id id, Hadith object) {
  object.id = id;
}

extension HadithQueryWhereSort on QueryBuilder<Hadith, Hadith, QWhere> {
  QueryBuilder<Hadith, Hadith, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HadithQueryWhere on QueryBuilder<Hadith, Hadith, QWhereClause> {
  QueryBuilder<Hadith, Hadith, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Hadith, Hadith, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterWhereClause> idBetween(
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

extension HadithQueryFilter on QueryBuilder<Hadith, Hadith, QFilterCondition> {
  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> bookEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'book',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> bookGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'book',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> bookLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'book',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> bookBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'book',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> bookStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'book',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> bookEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'book',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> bookContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'book',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> bookMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'book',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> bookIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'book',
        value: '',
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> bookIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'book',
        value: '',
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> gradeEqualTo(
      HadithGrade value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'grade',
        value: value,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> gradeGreaterThan(
    HadithGrade value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'grade',
        value: value,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> gradeLessThan(
    HadithGrade value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'grade',
        value: value,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> gradeBetween(
    HadithGrade lower,
    HadithGrade upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'grade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hadith',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hadith',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hadith',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hadith',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hadith',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hadith',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hadith',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hadith',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hadith',
        value: '',
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hadith',
        value: '',
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithNarratorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hadithNarrator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithNarratorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hadithNarrator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithNarratorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hadithNarrator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithNarratorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hadithNarrator',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithNarratorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hadithNarrator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithNarratorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hadithNarrator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithNarratorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hadithNarrator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithNarratorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hadithNarrator',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithNarratorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hadithNarrator',
        value: '',
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition>
      hadithNarratorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hadithNarrator',
        value: '',
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> isFeautredEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFeautred',
        value: value,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> topicEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> topicGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> topicLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> topicBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> topicStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'topic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> topicEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'topic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> topicContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'topic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> topicMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'topic',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> topicIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topic',
        value: '',
      ));
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> topicIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'topic',
        value: '',
      ));
    });
  }
}

extension HadithQueryObject on QueryBuilder<Hadith, Hadith, QFilterCondition> {}

extension HadithQueryLinks on QueryBuilder<Hadith, Hadith, QFilterCondition> {}

extension HadithQuerySortBy on QueryBuilder<Hadith, Hadith, QSortBy> {
  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByBook() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'book', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByBookDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'book', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByGrade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByGradeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByHadith() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadith', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByHadithDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadith', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByHadithNarrator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadithNarrator', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByHadithNarratorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadithNarrator', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByIsFeautred() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFeautred', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByIsFeautredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFeautred', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByTopic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topic', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByTopicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topic', Sort.desc);
    });
  }
}

extension HadithQuerySortThenBy on QueryBuilder<Hadith, Hadith, QSortThenBy> {
  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByBook() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'book', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByBookDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'book', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByGrade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByGradeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'grade', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByHadith() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadith', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByHadithDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadith', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByHadithNarrator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadithNarrator', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByHadithNarratorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadithNarrator', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByIsFeautred() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFeautred', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByIsFeautredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFeautred', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByTopic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topic', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByTopicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topic', Sort.desc);
    });
  }
}

extension HadithQueryWhereDistinct on QueryBuilder<Hadith, Hadith, QDistinct> {
  QueryBuilder<Hadith, Hadith, QDistinct> distinctByBook(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'book', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Hadith, Hadith, QDistinct> distinctByGrade() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'grade');
    });
  }

  QueryBuilder<Hadith, Hadith, QDistinct> distinctByHadith(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hadith', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Hadith, Hadith, QDistinct> distinctByHadithNarrator(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hadithNarrator',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Hadith, Hadith, QDistinct> distinctByIsFeautred() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFeautred');
    });
  }

  QueryBuilder<Hadith, Hadith, QDistinct> distinctByTopic(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topic', caseSensitive: caseSensitive);
    });
  }
}

extension HadithQueryProperty on QueryBuilder<Hadith, Hadith, QQueryProperty> {
  QueryBuilder<Hadith, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Hadith, String, QQueryOperations> bookProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'book');
    });
  }

  QueryBuilder<Hadith, HadithGrade, QQueryOperations> gradeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'grade');
    });
  }

  QueryBuilder<Hadith, String, QQueryOperations> hadithProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hadith');
    });
  }

  QueryBuilder<Hadith, String, QQueryOperations> hadithNarratorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hadithNarrator');
    });
  }

  QueryBuilder<Hadith, bool, QQueryOperations> isFeautredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFeautred');
    });
  }

  QueryBuilder<Hadith, String, QQueryOperations> topicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topic');
    });
  }
}

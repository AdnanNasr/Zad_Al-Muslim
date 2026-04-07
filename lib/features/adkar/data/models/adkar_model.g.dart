// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adkar_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAdkarModelCollection on Isar {
  IsarCollection<AdkarModel> get adkarModels => this.collection();
}

const AdkarModelSchema = CollectionSchema(
  name: r'AdkarModel',
  id: -7867251181089090440,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
    ),
    r'counts': PropertySchema(
      id: 1,
      name: r'counts',
      type: IsarType.longList,
    ),
    r'footnote': PropertySchema(
      id: 2,
      name: r'footnote',
      type: IsarType.stringList,
    ),
    r'text': PropertySchema(
      id: 3,
      name: r'text',
      type: IsarType.stringList,
    )
  },
  estimateSize: _adkarModelEstimateSize,
  serialize: _adkarModelSerialize,
  deserialize: _adkarModelDeserialize,
  deserializeProp: _adkarModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'category': IndexSchema(
      id: -7560358558326323820,
      name: r'category',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'category',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _adkarModelGetId,
  getLinks: _adkarModelGetLinks,
  attach: _adkarModelAttach,
  version: '3.1.0+1',
);

int _adkarModelEstimateSize(
  AdkarModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.counts.length * 8;
  bytesCount += 3 + object.footnote.length * 3;
  {
    for (var i = 0; i < object.footnote.length; i++) {
      final value = object.footnote[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.text.length * 3;
  {
    for (var i = 0; i < object.text.length; i++) {
      final value = object.text[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _adkarModelSerialize(
  AdkarModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category);
  writer.writeLongList(offsets[1], object.counts);
  writer.writeStringList(offsets[2], object.footnote);
  writer.writeStringList(offsets[3], object.text);
}

AdkarModel _adkarModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AdkarModel();
  object.category = reader.readString(offsets[0]);
  object.counts = reader.readLongList(offsets[1]) ?? [];
  object.footnote = reader.readStringList(offsets[2]) ?? [];
  object.id = id;
  object.text = reader.readStringList(offsets[3]) ?? [];
  return object;
}

P _adkarModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLongList(offset) ?? []) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _adkarModelGetId(AdkarModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _adkarModelGetLinks(AdkarModel object) {
  return [];
}

void _adkarModelAttach(IsarCollection<dynamic> col, Id id, AdkarModel object) {
  object.id = id;
}

extension AdkarModelQueryWhereSort
    on QueryBuilder<AdkarModel, AdkarModel, QWhere> {
  QueryBuilder<AdkarModel, AdkarModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AdkarModelQueryWhere
    on QueryBuilder<AdkarModel, AdkarModel, QWhereClause> {
  QueryBuilder<AdkarModel, AdkarModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<AdkarModel, AdkarModel, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<AdkarModel, AdkarModel, QAfterWhereClause> categoryEqualTo(
      String category) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'category',
        value: [category],
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterWhereClause> categoryNotEqualTo(
      String category) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [],
              upper: [category],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [category],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [category],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'category',
              lower: [],
              upper: [category],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AdkarModelQueryFilter
    on QueryBuilder<AdkarModel, AdkarModel, QFilterCondition> {
  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> categoryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> categoryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      countsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'counts',
        value: value,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      countsElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'counts',
        value: value,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      countsElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'counts',
        value: value,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      countsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'counts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      countsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'counts',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> countsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'counts',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      countsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'counts',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      countsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'counts',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      countsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'counts',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      countsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'counts',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'footnote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'footnote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'footnote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'footnote',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'footnote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'footnote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'footnote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'footnote',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'footnote',
        value: '',
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'footnote',
        value: '',
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'footnote',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'footnote',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'footnote',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'footnote',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'footnote',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      footnoteLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'footnote',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      textElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      textElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      textElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      textElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      textElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      textElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      textElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      textElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      textElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      textElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> textLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'text',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'text',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'text',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      textLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'text',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition>
      textLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'text',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterFilterCondition> textLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'text',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension AdkarModelQueryObject
    on QueryBuilder<AdkarModel, AdkarModel, QFilterCondition> {}

extension AdkarModelQueryLinks
    on QueryBuilder<AdkarModel, AdkarModel, QFilterCondition> {}

extension AdkarModelQuerySortBy
    on QueryBuilder<AdkarModel, AdkarModel, QSortBy> {
  QueryBuilder<AdkarModel, AdkarModel, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }
}

extension AdkarModelQuerySortThenBy
    on QueryBuilder<AdkarModel, AdkarModel, QSortThenBy> {
  QueryBuilder<AdkarModel, AdkarModel, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension AdkarModelQueryWhereDistinct
    on QueryBuilder<AdkarModel, AdkarModel, QDistinct> {
  QueryBuilder<AdkarModel, AdkarModel, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QDistinct> distinctByCounts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'counts');
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QDistinct> distinctByFootnote() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'footnote');
    });
  }

  QueryBuilder<AdkarModel, AdkarModel, QDistinct> distinctByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text');
    });
  }
}

extension AdkarModelQueryProperty
    on QueryBuilder<AdkarModel, AdkarModel, QQueryProperty> {
  QueryBuilder<AdkarModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AdkarModel, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<AdkarModel, List<int>, QQueryOperations> countsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'counts');
    });
  }

  QueryBuilder<AdkarModel, List<String>, QQueryOperations> footnoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'footnote');
    });
  }

  QueryBuilder<AdkarModel, List<String>, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_model.dart';

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
    r'hadithnumber': PropertySchema(
      id: 0,
      name: r'hadithnumber',
      type: IsarType.string,
    ),
    r'isFavorite': PropertySchema(
      id: 1,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'reference': PropertySchema(
      id: 2,
      name: r'reference',
      type: IsarType.object,

      target: r'ReferenceModel',
    ),
    r'text': PropertySchema(id: 3, name: r'text', type: IsarType.string),
    r'textNormalized': PropertySchema(
      id: 4,
      name: r'textNormalized',
      type: IsarType.string,
    ),
  },

  estimateSize: _hadithEstimateSize,
  serialize: _hadithSerialize,
  deserialize: _hadithDeserialize,
  deserializeProp: _hadithDeserializeProp,
  idName: r'id',
  indexes: {
    r'isFavorite': IndexSchema(
      id: 5742774614603939776,
      name: r'isFavorite',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isFavorite',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {r'ReferenceModel': ReferenceModelSchema},

  getId: _hadithGetId,
  getLinks: _hadithGetLinks,
  attach: _hadithAttach,
  version: '3.3.2',
);

int _hadithEstimateSize(
  Hadith object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.hadithnumber.length * 3;
  bytesCount +=
      3 +
      ReferenceModelSchema.estimateSize(
        object.reference,
        allOffsets[ReferenceModel]!,
        allOffsets,
      );
  bytesCount += 3 + object.text.length * 3;
  bytesCount += 3 + object.textNormalized.length * 3;
  return bytesCount;
}

void _hadithSerialize(
  Hadith object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.hadithnumber);
  writer.writeBool(offsets[1], object.isFavorite);
  writer.writeObject<ReferenceModel>(
    offsets[2],
    allOffsets,
    ReferenceModelSchema.serialize,
    object.reference,
  );
  writer.writeString(offsets[3], object.text);
  writer.writeString(offsets[4], object.textNormalized);
}

Hadith _hadithDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Hadith();
  object.hadithnumber = reader.readString(offsets[0]);
  object.id = id;
  object.isFavorite = reader.readBool(offsets[1]);
  object.reference =
      reader.readObjectOrNull<ReferenceModel>(
        offsets[2],
        ReferenceModelSchema.deserialize,
        allOffsets,
      ) ??
      ReferenceModel();
  object.text = reader.readString(offsets[3]);
  object.textNormalized = reader.readString(offsets[4]);
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
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readObjectOrNull<ReferenceModel>(
                offset,
                ReferenceModelSchema.deserialize,
                allOffsets,
              ) ??
              ReferenceModel())
          as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

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

  QueryBuilder<Hadith, Hadith, QAfterWhere> anyIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isFavorite'),
      );
    });
  }
}

extension HadithQueryWhere on QueryBuilder<Hadith, Hadith, QWhereClause> {
  QueryBuilder<Hadith, Hadith, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
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

  QueryBuilder<Hadith, Hadith, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
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

  QueryBuilder<Hadith, Hadith, QAfterWhereClause> isFavoriteEqualTo(
    bool isFavorite,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'isFavorite', value: [isFavorite]),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterWhereClause> isFavoriteNotEqualTo(
    bool isFavorite,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isFavorite',
                lower: [],
                upper: [isFavorite],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isFavorite',
                lower: [isFavorite],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isFavorite',
                lower: [isFavorite],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isFavorite',
                lower: [],
                upper: [isFavorite],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension HadithQueryFilter on QueryBuilder<Hadith, Hadith, QFilterCondition> {
  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithnumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'hadithnumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithnumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hadithnumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithnumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hadithnumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithnumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hadithnumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithnumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'hadithnumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithnumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'hadithnumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithnumberContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'hadithnumber',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithnumberMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'hadithnumber',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithnumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hadithnumber', value: ''),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> hadithnumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'hadithnumber', value: ''),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> isFavoriteEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isFavorite', value: value),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textEqualTo(
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

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textGreaterThan(
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

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textLessThan(
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

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textBetween(
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

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textStartsWith(
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

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textEndsWith(
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

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textContains(
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

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textMatches(
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

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textNormalizedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'textNormalized',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textNormalizedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'textNormalized',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textNormalizedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'textNormalized',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textNormalizedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'textNormalized',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textNormalizedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'textNormalized',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textNormalizedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'textNormalized',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textNormalizedContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'textNormalized',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textNormalizedMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'textNormalized',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> textNormalizedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'textNormalized', value: ''),
      );
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterFilterCondition>
  textNormalizedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'textNormalized', value: ''),
      );
    });
  }
}

extension HadithQueryObject on QueryBuilder<Hadith, Hadith, QFilterCondition> {
  QueryBuilder<Hadith, Hadith, QAfterFilterCondition> reference(
    FilterQuery<ReferenceModel> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'reference');
    });
  }
}

extension HadithQueryLinks on QueryBuilder<Hadith, Hadith, QFilterCondition> {}

extension HadithQuerySortBy on QueryBuilder<Hadith, Hadith, QSortBy> {
  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByHadithnumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadithnumber', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByHadithnumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadithnumber', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByTextNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textNormalized', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> sortByTextNormalizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textNormalized', Sort.desc);
    });
  }
}

extension HadithQuerySortThenBy on QueryBuilder<Hadith, Hadith, QSortThenBy> {
  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByHadithnumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadithnumber', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByHadithnumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hadithnumber', Sort.desc);
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

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'text', Sort.desc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByTextNormalized() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textNormalized', Sort.asc);
    });
  }

  QueryBuilder<Hadith, Hadith, QAfterSortBy> thenByTextNormalizedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'textNormalized', Sort.desc);
    });
  }
}

extension HadithQueryWhereDistinct on QueryBuilder<Hadith, Hadith, QDistinct> {
  QueryBuilder<Hadith, Hadith, QDistinct> distinctByHadithnumber({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hadithnumber', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Hadith, Hadith, QDistinct> distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<Hadith, Hadith, QDistinct> distinctByText({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'text', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Hadith, Hadith, QDistinct> distinctByTextNormalized({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'textNormalized',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension HadithQueryProperty on QueryBuilder<Hadith, Hadith, QQueryProperty> {
  QueryBuilder<Hadith, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Hadith, String, QQueryOperations> hadithnumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hadithnumber');
    });
  }

  QueryBuilder<Hadith, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<Hadith, ReferenceModel, QQueryOperations> referenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reference');
    });
  }

  QueryBuilder<Hadith, String, QQueryOperations> textProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'text');
    });
  }

  QueryBuilder<Hadith, String, QQueryOperations> textNormalizedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'textNormalized');
    });
  }
}

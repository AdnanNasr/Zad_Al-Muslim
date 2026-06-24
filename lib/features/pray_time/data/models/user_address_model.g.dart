// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_address_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserAddressModelCollection on Isar {
  IsarCollection<UserAddressModel> get userAddressModels => this.collection();
}

const UserAddressModelSchema = CollectionSchema(
  name: r'UserAddressModel',
  id: 2708721576613986976,
  properties: {
    r'country': PropertySchema(id: 0, name: r'country', type: IsarType.string),
    r'countryCode': PropertySchema(
      id: 1,
      name: r'countryCode',
      type: IsarType.string,
    ),
    r'locality': PropertySchema(
      id: 2,
      name: r'locality',
      type: IsarType.string,
    ),
  },

  estimateSize: _userAddressModelEstimateSize,
  serialize: _userAddressModelSerialize,
  deserialize: _userAddressModelDeserialize,
  deserializeProp: _userAddressModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _userAddressModelGetId,
  getLinks: _userAddressModelGetLinks,
  attach: _userAddressModelAttach,
  version: '3.3.2',
);

int _userAddressModelEstimateSize(
  UserAddressModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.country;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.countryCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.locality;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _userAddressModelSerialize(
  UserAddressModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.country);
  writer.writeString(offsets[1], object.countryCode);
  writer.writeString(offsets[2], object.locality);
}

UserAddressModel _userAddressModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserAddressModel(
    country: reader.readStringOrNull(offsets[0]),
    countryCode: reader.readStringOrNull(offsets[1]),
    locality: reader.readStringOrNull(offsets[2]),
  );
  object.id = id;
  return object;
}

P _userAddressModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userAddressModelGetId(UserAddressModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userAddressModelGetLinks(UserAddressModel object) {
  return [];
}

void _userAddressModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  UserAddressModel object,
) {
  object.id = id;
}

extension UserAddressModelQueryWhereSort
    on QueryBuilder<UserAddressModel, UserAddressModel, QWhere> {
  QueryBuilder<UserAddressModel, UserAddressModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserAddressModelQueryWhere
    on QueryBuilder<UserAddressModel, UserAddressModel, QWhereClause> {
  QueryBuilder<UserAddressModel, UserAddressModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterWhereClause>
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

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterWhereClause> idBetween(
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
}

extension UserAddressModelQueryFilter
    on QueryBuilder<UserAddressModel, UserAddressModel, QFilterCondition> {
  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'country'),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'country'),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'country',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'country',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'country',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'country',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'country',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'country',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'country',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'country',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'country', value: ''),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'country', value: ''),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'countryCode'),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'countryCode'),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryCodeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'countryCode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryCodeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryCodeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'countryCode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'countryCode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'countryCode', value: ''),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  countryCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'countryCode', value: ''),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
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

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
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

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
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

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  localityIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'locality'),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  localityIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'locality'),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  localityEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'locality',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  localityGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'locality',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  localityLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'locality',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  localityBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'locality',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  localityStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'locality',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  localityEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'locality',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  localityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'locality',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  localityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'locality',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  localityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'locality', value: ''),
      );
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterFilterCondition>
  localityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'locality', value: ''),
      );
    });
  }
}

extension UserAddressModelQueryObject
    on QueryBuilder<UserAddressModel, UserAddressModel, QFilterCondition> {}

extension UserAddressModelQueryLinks
    on QueryBuilder<UserAddressModel, UserAddressModel, QFilterCondition> {}

extension UserAddressModelQuerySortBy
    on QueryBuilder<UserAddressModel, UserAddressModel, QSortBy> {
  QueryBuilder<UserAddressModel, UserAddressModel, QAfterSortBy>
  sortByCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.asc);
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterSortBy>
  sortByCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.desc);
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterSortBy>
  sortByCountryCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryCode', Sort.asc);
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterSortBy>
  sortByCountryCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryCode', Sort.desc);
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterSortBy>
  sortByLocality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locality', Sort.asc);
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterSortBy>
  sortByLocalityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locality', Sort.desc);
    });
  }
}

extension UserAddressModelQuerySortThenBy
    on QueryBuilder<UserAddressModel, UserAddressModel, QSortThenBy> {
  QueryBuilder<UserAddressModel, UserAddressModel, QAfterSortBy>
  thenByCountry() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.asc);
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterSortBy>
  thenByCountryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'country', Sort.desc);
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterSortBy>
  thenByCountryCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryCode', Sort.asc);
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterSortBy>
  thenByCountryCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'countryCode', Sort.desc);
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterSortBy>
  thenByLocality() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locality', Sort.asc);
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QAfterSortBy>
  thenByLocalityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locality', Sort.desc);
    });
  }
}

extension UserAddressModelQueryWhereDistinct
    on QueryBuilder<UserAddressModel, UserAddressModel, QDistinct> {
  QueryBuilder<UserAddressModel, UserAddressModel, QDistinct>
  distinctByCountry({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'country', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QDistinct>
  distinctByCountryCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'countryCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserAddressModel, UserAddressModel, QDistinct>
  distinctByLocality({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locality', caseSensitive: caseSensitive);
    });
  }
}

extension UserAddressModelQueryProperty
    on QueryBuilder<UserAddressModel, UserAddressModel, QQueryProperty> {
  QueryBuilder<UserAddressModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserAddressModel, String?, QQueryOperations> countryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'country');
    });
  }

  QueryBuilder<UserAddressModel, String?, QQueryOperations>
  countryCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'countryCode');
    });
  }

  QueryBuilder<UserAddressModel, String?, QQueryOperations> localityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locality');
    });
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_model.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const ReferenceModelSchema = Schema(
  name: r'ReferenceModel',
  id: -5005050515208716348,
  properties: {
    r'book': PropertySchema(
      id: 0,
      name: r'book',
      type: IsarType.long,
    ),
    r'hadith': PropertySchema(
      id: 1,
      name: r'hadith',
      type: IsarType.long,
    )
  },
  estimateSize: _referenceModelEstimateSize,
  serialize: _referenceModelSerialize,
  deserialize: _referenceModelDeserialize,
  deserializeProp: _referenceModelDeserializeProp,
);

int _referenceModelEstimateSize(
  ReferenceModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _referenceModelSerialize(
  ReferenceModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.book);
  writer.writeLong(offsets[1], object.hadith);
}

ReferenceModel _referenceModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReferenceModel(
    book: reader.readLongOrNull(offsets[0]),
    hadith: reader.readLongOrNull(offsets[1]),
  );
  return object;
}

P _referenceModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension ReferenceModelQueryFilter
    on QueryBuilder<ReferenceModel, ReferenceModel, QFilterCondition> {
  QueryBuilder<ReferenceModel, ReferenceModel, QAfterFilterCondition>
      bookIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'book',
      ));
    });
  }

  QueryBuilder<ReferenceModel, ReferenceModel, QAfterFilterCondition>
      bookIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'book',
      ));
    });
  }

  QueryBuilder<ReferenceModel, ReferenceModel, QAfterFilterCondition>
      bookEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'book',
        value: value,
      ));
    });
  }

  QueryBuilder<ReferenceModel, ReferenceModel, QAfterFilterCondition>
      bookGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'book',
        value: value,
      ));
    });
  }

  QueryBuilder<ReferenceModel, ReferenceModel, QAfterFilterCondition>
      bookLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'book',
        value: value,
      ));
    });
  }

  QueryBuilder<ReferenceModel, ReferenceModel, QAfterFilterCondition>
      bookBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'book',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ReferenceModel, ReferenceModel, QAfterFilterCondition>
      hadithIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'hadith',
      ));
    });
  }

  QueryBuilder<ReferenceModel, ReferenceModel, QAfterFilterCondition>
      hadithIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'hadith',
      ));
    });
  }

  QueryBuilder<ReferenceModel, ReferenceModel, QAfterFilterCondition>
      hadithEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hadith',
        value: value,
      ));
    });
  }

  QueryBuilder<ReferenceModel, ReferenceModel, QAfterFilterCondition>
      hadithGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hadith',
        value: value,
      ));
    });
  }

  QueryBuilder<ReferenceModel, ReferenceModel, QAfterFilterCondition>
      hadithLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hadith',
        value: value,
      ));
    });
  }

  QueryBuilder<ReferenceModel, ReferenceModel, QAfterFilterCondition>
      hadithBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hadith',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReferenceModelQueryObject
    on QueryBuilder<ReferenceModel, ReferenceModel, QFilterCondition> {}

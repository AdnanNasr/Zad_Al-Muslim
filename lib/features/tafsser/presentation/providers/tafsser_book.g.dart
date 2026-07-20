// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tafsser_book.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TafsserBook)
final tafsserBookProvider = TafsserBookProvider._();

final class TafsserBookProvider
    extends
        $AsyncNotifierProvider<
          TafsserBook,
          Either<Failure, List<TafsserBookEntity>>
        > {
  TafsserBookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tafsserBookProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tafsserBookHash();

  @$internal
  @override
  TafsserBook create() => TafsserBook();
}

String _$tafsserBookHash() => r'2311f23a88476c6f5639502454f19b992ff50315';

abstract class _$TafsserBook
    extends $AsyncNotifier<Either<Failure, List<TafsserBookEntity>>> {
  FutureOr<Either<Failure, List<TafsserBookEntity>>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Either<Failure, List<TafsserBookEntity>>>,
              Either<Failure, List<TafsserBookEntity>>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Either<Failure, List<TafsserBookEntity>>>,
                Either<Failure, List<TafsserBookEntity>>
              >,
              AsyncValue<Either<Failure, List<TafsserBookEntity>>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

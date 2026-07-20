// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_book.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedBook)
final selectedBookProvider = SelectedBookProvider._();

final class SelectedBookProvider
    extends $NotifierProvider<SelectedBook, TafsserBookEntity> {
  SelectedBookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedBookProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedBookHash();

  @$internal
  @override
  SelectedBook create() => SelectedBook();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TafsserBookEntity value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TafsserBookEntity>(value),
    );
  }
}

String _$selectedBookHash() => r'4b5ec17d37567ca6ba14570ff6ca945b15c86a02';

abstract class _$SelectedBook extends $Notifier<TafsserBookEntity> {
  TafsserBookEntity build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TafsserBookEntity, TafsserBookEntity>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TafsserBookEntity, TafsserBookEntity>,
              TafsserBookEntity,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

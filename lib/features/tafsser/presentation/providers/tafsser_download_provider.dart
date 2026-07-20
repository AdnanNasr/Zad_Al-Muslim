import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/providers/tafsser_book.dart';

class TafseerDownloadState {
  final double progress;
  final bool isDownloading;

  TafseerDownloadState({required this.progress, required this.isDownloading});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TafseerDownloadState &&
        other.progress == progress &&
        other.isDownloading == isDownloading;
  }

  @override
  int get hashCode => progress.hashCode ^ isDownloading.hashCode;
}

class TafseerDownloadNotifier
    extends StateNotifier<Map<String, TafseerDownloadState>> {
  final Ref ref;

  TafseerDownloadNotifier(this.ref) : super({});

  void startDownload(String bookId) {
    state = {
      ...state,
      bookId: TafseerDownloadState(progress: 0.0, isDownloading: true),
    };
  }

  void updateProgress(String bookId, double progress) {
    state = {
      ...state,
      bookId: TafseerDownloadState(progress: progress, isDownloading: true),
    };
  }

  void stopDownload(String bookId) {
    final newState = Map<String, TafseerDownloadState>.from(state);
    newState.remove(bookId);
    state = newState;

    // Invalidate the books provider to refresh download status
    ref.invalidate(tafsserBookProvider);
  }
}

final tafsserDownloadProvider =
    StateNotifierProvider<
      TafseerDownloadNotifier,
      Map<String, TafseerDownloadState>
    >((ref) {
      return TafseerDownloadNotifier(ref);
    });

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/constants/env.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/extensions/theme_ext.dart';
import 'package:zad_al_muslim/core/utils/network/network_info.dart';
import 'package:zad_al_muslim/core/common/widgets/custom_app_bar.dart';
import 'package:zad_al_muslim/features/tafsser/domain/entities/tafsser_entities.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/providers/tafsser_book.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/widgets/tafseer_dialog.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/widgets/tafsser_buttons.dart';
import 'package:zad_al_muslim/features/tafsser/domain/usecases/tafseer_utils.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/providers/tafsser_download_provider.dart';

class TafseerPage extends ConsumerStatefulWidget {
  const TafseerPage({super.key});

  @override
  ConsumerState<TafseerPage> createState() => _TafseerPageState();
}

class _TafseerPageState extends ConsumerState<TafseerPage> {
  @override
  Widget build(BuildContext context) {
    final themeMode = context.themeMode(ref);
    final booksAsync = ref.watch(tafsserBookProvider);

    return Scaffold(
      backgroundColor: themeMode == ThemeMode.light
          ? context.color.onPrimary
          : context.color.scrim,
      appBar: const CustomAppBar(title: "كتب التفسير", center: false),
      body: booksAsync.when(
        data: (booksEither) {
          return booksEither.fold(
            (failure) => Center(child: Text(failure.message)),
            (books) => ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];

              return TafsserItem(
                info: book,
                isDownloaded: book.isDownloaded,
                onPressed: () async {
                  await _handleDownload(book);
                },
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => TafseerDialog(
                    tafsserInfo: book,
                    isDownloaded: book.isDownloaded,
                  ),
                ),
              );
            },
          ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<void> _handleDownload(TafsserBookEntity book) async {
    final downloadNotifier = ref.read(tafsserDownloadProvider.notifier);

    // نظهر للمستخدم أن العملية بدأت (حتى لو أخذ فحص الإنترنت وقتاً)
    downloadNotifier.startDownload(book.id);

    final bool internetConnected = await NetworkInfo().hasValidConnection();

    if (!internetConnected) {
      downloadNotifier.stopDownload(book.id);
      if (mounted) {
        _showErrorMessage("لا يوجد إتصال بالإنترنت");
      }
      return;
    }

    if (book.isDownloaded) {
      downloadNotifier.stopDownload(book.id);
      if (mounted) {
        _showErrorMessage("هذا التفسير مثبت بالفعل");
      }
      return;
    }

    final String url = "${Env.tafseerEndpint}/${book.id}";

    TafseerUtils.downloadTafseer(
      url: url,
      onProgress: (progress) {
        downloadNotifier.updateProgress(book.id, progress);
      },
      onStart: () {
        if (!mounted) return;
        _showStartMessage(book.name);
      },
      onComplete: () {
        downloadNotifier.stopDownload(book.id);
        if (mounted) {
          _showSuccessMessage(book.name);
        }
      },
      onError: (msg) {
        downloadNotifier.stopDownload(book.id);
        if (mounted) {
          _showErrorMessage(msg);
        }
      },
    );
  }

  void _showSuccessMessage(String bookName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("تم تثبيت $bookName بنجاح"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showStartMessage(String bookName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("جاري تثبيت $bookName"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorMessage(String msg) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

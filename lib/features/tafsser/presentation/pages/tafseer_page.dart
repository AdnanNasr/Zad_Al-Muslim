import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/constants/env.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/utils/network/network_info.dart';
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
    final booksAsync = ref.watch(tafsserBookProvider);

    return Scaffold(
      backgroundColor: context.color.surfaceContainerLowest,
      body: SafeArea(
        child: Column(
          children: [
            const _TafseerHeader(),
            Expanded(
              child: booksAsync.when(
                data: (booksEither) {
                  return booksEither.fold(
                    (failure) => Center(child: Text(failure.message)),
                    (books) => ListView.builder(
                      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 24.h),
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
                error: (err, stack) =>
                    Center(child: Text('تعذّر تحميل كتب التفسير: $err')),
              ),
            ),
          ],
        ),
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

class _TafseerHeader extends StatelessWidget {
  const _TafseerHeader();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 8.h),
      child: Row(
        children: [
          IconButton.filledTonal(
            tooltip: 'العودة',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
          SizedBox(width: 10.w),
          Container(
            width: 46.r,
            height: 46.r,
            decoration: BoxDecoration(
              color: scheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Icon(
              Icons.library_books_rounded,
              color: scheme.onTertiaryContainer,
            ),
          ),
          SizedBox(width: 11.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'كتب التفسير',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  'اختر التفسير المناسب للقراءة دون اتصال',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 10.5.sp,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

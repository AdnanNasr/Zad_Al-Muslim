import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/constants/env.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/extensions/theme_ext.dart';
import 'package:zad_al_muslim/core/utils/network/network_info.dart';
import 'package:zad_al_muslim/core/common/widgets/custom_app_bar.dart';
import 'package:zad_al_muslim/features/tafsser/domain/entities/tafsser_entities.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/providers/tafsser_book_provider.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/widgets/tafseer_dialog.dart';
import 'package:zad_al_muslim/features/tafsser/presentation/widgets/tafsser_buttons.dart';
import 'package:zad_al_muslim/features/tafsser/domain/usecases/tafseer_utils.dart';

class TafseerPage extends ConsumerStatefulWidget {
  const TafseerPage({super.key});

  @override
  ConsumerState<TafseerPage> createState() => _TafseerPageState();
}

class _TafseerPageState extends ConsumerState<TafseerPage> {
  final Map<String, GlobalKey<TafsserItemState>> itemKeys = {};

  @override
  Widget build(BuildContext context) {
    final themeMode = context.themeMode(ref);
    final booksAsync = ref.watch(tafsserBooksProvider);

    return Scaffold(
      backgroundColor: themeMode == ThemeMode.light
          ? context.color.onPrimary
          : context.color.scrim,
      appBar: const CustomAppBar(
        title: "كتب التفسير",
        center: false,
        themeMode: false,
      ),
      body: booksAsync.when(
        data: (books) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              itemKeys.putIfAbsent(
                book.id,
                () => GlobalKey<TafsserItemState>(),
              );

              return TafsserItem(
                key: itemKeys[book.id],
                info: book,
                isDownloaded: book.isDownloaded,
                onPressed: () async {
                  await _handleDownload(book);
                },
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => TafseerDialog(tafsserInfo: book),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<void> _handleDownload(TafsserBookEntity book) async {
    final bool internetConnected = await NetworkInfo().hasValidConnection();

    if (!internetConnected) {
      _showErrorMessage("لا يوجد إتصال بالإنترنت");
      itemKeys[book.id]?.currentState?.setIsDownloading(false);
      return;
    }

    if (book.isDownloaded) {
      _showErrorMessage("هذا التفسير مثبت بالفعل");
      return;
    }

    final String url = "${Env.tafseerEndpint}/${book.id}";

    // سنستخدم TafseerUtils مؤقتاً للتقدم حتى يتم تحسين الـ Repository
    TafseerUtils.downloadTafseer(
      url: url,
      onProgress: (progress) {
        if (mounted) {
          itemKeys[book.id]?.currentState?.updateDownloadProgress(progress);
        }
      },
      onComplete: () {
        if (mounted) {
          itemKeys[book.id]?.currentState?.markAsDownloaded();
          _showSuccessMessage(book.name);
          ref.invalidate(tafsserBooksProvider);
        }
      },
      onError: (msg) {
        if (mounted) {
          itemKeys[book.id]?.currentState?.setIsDownloading(false);
          _showErrorMessage(msg);
        }
      },
    );
  }

  void _showSuccessMessage(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("تم تثبيت $name بنجاح"),
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

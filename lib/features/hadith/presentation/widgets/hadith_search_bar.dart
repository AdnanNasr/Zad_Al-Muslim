import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/features/hadith/presentation/providers/hadith_provider.dart';

class HadithSearchBar extends ConsumerStatefulWidget {
  const HadithSearchBar({super.key});

  @override
  ConsumerState<HadithSearchBar> createState() => HadithSearchBarState();
}

class HadithSearchBarState extends ConsumerState<HadithSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    // Initialize controller with current search query if present
    final initialQuery = ref.read(hadithProvider.notifier).currentSearchQuery;

    if (initialQuery != null) {
      _controller.text = initialQuery;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void clearText() {
    _controller.clear();
    if (_debounce?.isActive ?? false) _debounce!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    void onSearchChanged(String query) {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        ref
            .read(hadithProvider.notifier)
            .setSearchQuery(query.isEmpty ? null : query);
      });
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.color.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TextField(
        controller: _controller,
        onChanged: onSearchChanged,
        style: TextStyle(
          fontSize: 16.sp,
          fontFamily: "Cairo",
          color: context.color.onSurface,
        ),
        decoration: InputDecoration(
          hintText: "ابحث في الأحاديث...",
          hintStyle: TextStyle(
            color: context.color.onSurfaceVariant.withValues(alpha: 0.7),
            fontSize: 14.sp,
            fontFamily: "Cairo",
          ),
          // prefixIcon: Icon(Icons.search_rounded, color: context.color.primary),
          prefixIcon: _controller.text.isNotEmpty
              ? AnimationConfiguration.synchronized(
                  duration: const Duration(milliseconds: 700),
                  child: FadeInAnimation(
                    child: IconButton(
                      onPressed: () {
                        clearText();
                        onSearchChanged("");
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear_outlined),
                    ),
                  ),
                )
              : const Icon(Icons.search_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
}

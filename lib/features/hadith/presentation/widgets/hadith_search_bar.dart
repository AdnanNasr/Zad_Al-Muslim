import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/features/hadith/presentation/providers/hadith_provider.dart';

class HadithSearchBar extends ConsumerStatefulWidget {
  const HadithSearchBar({super.key});

  @override
  ConsumerState<HadithSearchBar> createState() => _HadithSearchBarState();
}

class _HadithSearchBarState extends ConsumerState<HadithSearchBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
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

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(hadithProvider.notifier).setSearchQuery(query.isEmpty ? null : query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.color.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: context.color.primary.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
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
          prefixIcon: Icon(Icons.search_rounded, color: context.color.primary),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: context.color.primary),
                  onPressed: () {
                    _controller.clear();
                    _onSearchChanged("");
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
      ),
    );
  }
}

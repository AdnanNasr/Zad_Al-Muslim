import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:noor_quran/core/extensions/color_ext.dart';
import 'package:noor_quran/core/common/widgets/custom_app_bar.dart';
import 'package:noor_quran/features/adkar/domain/entities/adkar_entity.dart';

class AdkarDetailsPage extends StatelessWidget {
  final AdkarEntity adkarEntity;

  const AdkarDetailsPage({Key? key, required this.adkarEntity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: adkarEntity.category,
        center: true,
        profile: false,
        icon: Icons.arrow_back,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: adkarEntity.text.length,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) {
          return DhikrCard(
            text: adkarEntity.text[index],
            footnote: index < adkarEntity.footnote.length ? adkarEntity.footnote[index] : '',
            index: index + 1,
            initialCount: index < adkarEntity.counts.length ? adkarEntity.counts[index] : 1,
          );
        },
      ),
    );
  }
}

class DhikrCard extends StatefulWidget {
  final String text;
  final String footnote;
  final int index;
  final int initialCount;

  const DhikrCard({
    Key? key,
    required this.text,
    required this.footnote,
    required this.index,
    required this.initialCount,
  }) : super(key: key);

  @override
  State<DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<DhikrCard> {
  late int _remainingCount;

  @override
  void initState() {
    super.initState();
    _remainingCount = widget.initialCount;
  }

  void _decrement() {
    if (_remainingCount > 0) {
      // Feedback: Haptic feedback or sound could be added here
      setState(() {
        _remainingCount--;
      });
    }
  }

  void _reset() {
    setState(() {
      _remainingCount = widget.initialCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
            side: BorderSide(color: context.color.primary.withValues(alpha: .1)),
          ),
          child: InkWell(
            onTap: _decrement,
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Quran', 
                      fontSize: 22.sp,
                      height: 1.8,
                      color: context.color.onSurface,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Divider(color: context.color.primary.withValues(alpha: .05)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.footnote.isNotEmpty)
                        IconButton(
                          icon: Icon(Icons.info_outline, color: context.color.primary),
                          onPressed: () => _showFootnoteDialog(context, widget.footnote),
                        )
                      else
                        const SizedBox.shrink(),
                      
                      _buildCounter(context),
                      
                      IconButton(
                        icon: Icon(Icons.refresh, color: context.color.primary.withValues(alpha: .5), size: 20.sp),
                        onPressed: _reset,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 8.h,
          right: 8.w,
          child: Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: context.color.primary.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                widget.index.toString(),
                style: TextStyle(
                  color: context.color.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCounter(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: context.color.primary,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: context.color.primary.withValues(alpha: .2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        'التكرار: $_remainingCount',
        style: TextStyle(
          color: context.color.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  void _showFootnoteDialog(BuildContext context, String footnote) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: context.color.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: context.color.primary.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'تخريج الحديث / ملاحظة',
                style: TextStyle(
                  fontFamily: 'Cairo', 
                  fontWeight: FontWeight.bold, 
                  fontSize: 18.sp,
                  color: context.color.primary,
                ),
              ),
              SizedBox(height: 16.h),
              SelectableText(
                footnote,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo', 
                  fontSize: 15.sp, 
                  height: 1.6,
                  color: context.color.onSurface,
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      },
    );
  }
}

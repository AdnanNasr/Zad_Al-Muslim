import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const double _iconSize = 30.0;

const double _horizontalPadding = 16.0;

class QuranMoreMenu extends StatelessWidget {
  final List<MenuItem> menuItems;

  final String title;

  const QuranMoreMenu({
    super.key,
    required this.menuItems,
    this.title = 'المزيد من الخيارات',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),

      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: _horizontalPadding,
            right: _horizontalPadding,
            top: 12.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 8.0,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, fontFamily: "Cairo"),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return _MenuItemWidget(item: item);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItemWidget extends StatelessWidget {
  final MenuItem item;

  const _MenuItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(10.0),
      child: Padding(
        padding: EdgeInsets.all(4.0.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 55.w,
              height: 55.h,
              decoration: BoxDecoration(
                color: item.backgroundColor.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, size: _iconSize, color: Colors.white),
            ),
             SizedBox(height: 6.h),

            Expanded(
              child: Text(
                item.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onTap;

  const MenuItem({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.onTap,
  });
}

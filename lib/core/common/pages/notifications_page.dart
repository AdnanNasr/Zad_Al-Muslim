import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zad_al_muslim/core/common/widgets/page_header.dart';
import 'package:zad_al_muslim/core/extensions/color_ext.dart';
import 'package:zad_al_muslim/core/di/injection_container.dart';
import 'package:zad_al_muslim/core/utils/notifications/notification_inbox_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final _inbox = sl<NotificationInboxService>();

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final List<AppNotification> _currentNotifications = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _inbox.markAllRead();

      _currentNotifications.addAll(_inbox.notifications.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const PageHeader(
              tooltip: 'العودة',
              icon: Icons.notifications_outlined,
              title: 'الإشعارات',
              subTitle: 'تابع آخر التنبيهات',
            ),
            Expanded(
              child: ValueListenableBuilder<List<AppNotification>>(
                valueListenable: _inbox.notifications,
                builder: (context, notifications, _) {
                  if (_currentNotifications.isEmpty &&
                      notifications.isNotEmpty) {
                    _currentNotifications.addAll(notifications);
                  }

                  if (notifications.isEmpty && _currentNotifications.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: context.color.secondaryContainer
                                    .withValues(alpha: .55),
                                boxShadow: [
                                  BoxShadow(
                                    color: context.color.secondary.withValues(
                                      alpha: 0.08,
                                    ),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Container(
                                  width: 82,
                                  height: 82,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: context.color.secondary,
                                  ),
                                  child: Icon(
                                    Icons.notifications_none_rounded,
                                    size: 46,
                                    color: context.color.onSecondary,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            Text(
                              'لا توجد إشعارات',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 21.sp,
                                color: context.color.onSurface,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              'سنخبرك عندما يصل إليك إشعار جديد',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: context.color.onSurfaceVariant,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w400,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return AnimatedList(
                    key: _listKey,
                    initialItemCount: _currentNotifications.length,
                    padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 24.h),
                    itemBuilder: (context, index, animation) {
                      final notification = _currentNotifications[index];

                      return _buildItem(notification, animation);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(AppNotification notification, Animation<double> animation) {
    return Column(
      children: [
        _NotificationCard(
          key: ValueKey(notification.id),
          notification: notification,
          onDelete: () => _deleteNotification(notification),
        ),

        SizedBox(height: 10.h),
      ],
    );
  }

  void _deleteNotification(AppNotification notification) {
    final index = _currentNotifications.indexWhere(
      (n) => n.id == notification.id,
    );
    if (index == -1) return;

    final removedItem = _currentNotifications.removeAt(index);

    _listKey.currentState?.removeItem(index, (context, animation) {
      final offsetAnimation =
          Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutBack),
          );

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: animation,

          child: _buildItem(removedItem, animation),
        ),
      );
    }, duration: const Duration(milliseconds: 600));

    _inbox.deleteNotification(notification.id);
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.onDelete,
    super.key,
  });

  final AppNotification notification;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final presentation = _presentationFor(notification.id);

    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(8.r),
      clipBehavior: Clip.antiAlias,
      child: Ink(
        padding: EdgeInsets.fromLTRB(12.w, 12.h, 8.w, 12.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: .6),
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: presentation.color.withValues(alpha: .13),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                presentation.icon,
                color: presentation.color,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 11.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w800,
                      fontSize: 14.sp,
                      color: scheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    notification.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 11.5.sp,
                      height: 1.45,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    _formatDate(notification.createdAt),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: scheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'حذف الإشعار',

              onPressed: onDelete,
              icon: Icon(Icons.delete_outline_rounded, size: 21.sp),
              color: scheme.error,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationPresentation {
  const _NotificationPresentation(this.icon, this.color);

  final IconData icon;
  final Color color;
}

_NotificationPresentation _presentationFor(String id) {
  if (id.startsWith('prayer_')) {
    return const _NotificationPresentation(
      Icons.mosque_outlined,
      Color(0xFF0B806D),
    );
  }
  if (id.startsWith('quran_reading')) {
    return const _NotificationPresentation(
      Icons.menu_book_outlined,
      Color(0xFF2863A6),
    );
  }
  if (id.startsWith('morning_adkar')) {
    return const _NotificationPresentation(
      Icons.wb_sunny_outlined,
      Color(0xFFC07800),
    );
  }
  if (id.startsWith('evening_adkar')) {
    return const _NotificationPresentation(
      Icons.nightlight_outlined,
      Color(0xFF6750A4),
    );
  }
  if (id.startsWith('optional_update')) {
    return const _NotificationPresentation(
      Icons.system_update_alt_rounded,
      Color(0xFF1976D2),
    );
  }
  return const _NotificationPresentation(
    Icons.notifications_outlined,
    Color(0xFF546E7A),
  );
}

String _formatDate(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')} ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

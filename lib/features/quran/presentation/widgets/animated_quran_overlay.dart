import 'package:flutter/material.dart';

// ويدجت ذات حالة للتحكم في الرسوم المتحركة لـ Overlay
class AnimatedQuranOverlay extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;
  final Function() onDismissed; // يتم استدعاؤها بعد اكتمال رسوم الإخفاء

  const AnimatedQuranOverlay({
    super.key,
    required this.child,
    required this.animationDuration,
    required this.onDismissed,
  });

  @override
  AnimatedQuranOverlayState createState() => AnimatedQuranOverlayState();
}

class AnimatedQuranOverlayState extends State<AnimatedQuranOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    // 1. إنشاء وحدة تحكم الرسوم المتحركة
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // 2. تحديد حركة الانزلاق (من الأسفل إلى الموضع الأصلي)
    _animation =
        Tween<Offset>(
          begin: const Offset(0.0, 1.0), // تبدأ من الأسفل (خارج الشاشة)
          end: Offset.zero, // تنتهي في موضعها الأصلي
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.fastOutSlowIn, // منحنى سلس للظهور
          ),
        );

    // تشغيل الرسوم المتحركة للظهور
    _controller.forward();
  }

  // دالة الإخفاء التي يتم استدعاؤها من الـ Manager
  void dismiss() {
    // تشغيل الرسوم المتحركة للعكس (الإخفاء)
    _controller.reverse().then((_) {
      // عند اكتمال الإخفاء، استدعاء الدالة لإزالة الـ OverlayEntry فعليًا
      widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // نستخدم SlideTransition لتطبيق حركة الانزلاق
    return SlideTransition(position: _animation, child: widget.child);
  }
}

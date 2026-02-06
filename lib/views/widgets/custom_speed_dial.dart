import 'package:flutter/material.dart';

class SpeedDialItem {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onTap;

  const SpeedDialItem({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.onTap,
  });
}

class CustomSpeedDial extends StatefulWidget {
  final List<SpeedDialItem> dialChildren;

  const CustomSpeedDial({super.key, required this.dialChildren});

  @override
  State<CustomSpeedDial> createState() => _CustomSpeedDialState();
}

class _CustomSpeedDialState extends State<CustomSpeedDial>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleDial() {
    setState(() {
      _isOpen = !_isOpen;
    });

    if (_isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Widget _buildActionButton(
    int index,
    double animationValue,
    SpeedDialItem item,
  ) {
    final distance = 70.0 * (index + 1);
    final translateY = distance * animationValue;
    final opacity = animationValue;

    final innerContent = <Widget>[
      FloatingActionButton(
        heroTag: null,
        mini: true,
        backgroundColor: item.backgroundColor,
        onPressed: null,
        child: Icon(item.icon, color: Colors.white),
      ),

      const SizedBox(width: 3.0),

      Opacity(
        opacity: opacity,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 2.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: Text(
            item.label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ];

    final fabContent = SizedBox(
      child: Row(children: innerContent.reversed.toList()),
    );

    final clickableContent = InkWell(
      borderRadius: BorderRadius.circular(6.0),
      onTap: _isOpen
          ? () {
              _toggleDial();
              item.onTap.call();
            }
          : null,
      child: fabContent,
    );

    return Positioned(
      bottom: translateY,

      child: IgnorePointer(
        ignoring: !_isOpen,
        child: Opacity(opacity: opacity, child: clickableContent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return SizedBox(
      // height: context.heightScreen,
      // width: context.witdthScreen,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: isRtl ? Alignment.bottomLeft : Alignment.bottomRight,
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: _isOpen ? _toggleDial : null,
                  child: Opacity(
                    opacity: _controller.value * 0.6,
                    child: IgnorePointer(
                      ignoring: !_isOpen,
                      child: Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black12.withValues(alpha: 0.095),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              ...List.generate(widget.dialChildren.length, (index) {
                return _buildActionButton(
                  index,
                  _controller.value,
                  widget.dialChildren[index],
                );
              }).reversed,

              FloatingActionButton(
                heroTag: "mainHero",
                onPressed: _toggleDial,
                mini: true,
                child: _isOpen
                    ? const Icon(Icons.close)
                    : Icon(Icons.adaptive.more_outlined),
              ),
            ],
          );
        },
      ),
    );
  }
}

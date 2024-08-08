import 'package:flutter/material.dart';

class DotIndicatorWidget extends StatefulWidget {
  final Color dotColor;
  final double dotSize;
  final Duration animationDuration;

  const DotIndicatorWidget({
    super.key,
    this.dotColor = Colors.grey,
    this.dotSize = 10.0,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  _DotIndicatorWidgetState createState() => _DotIndicatorWidgetState();
}

class _DotIndicatorWidgetState extends State<DotIndicatorWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _dot1Animation;
  late Animation<double> _dot2Animation;
  late Animation<double> _dot3Animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _dot1Animation = Tween(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _dot2Animation = Tween(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.1, 0.6, curve: Curves.easeInOut),
      ),
    );

    _dot3Animation = Tween(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeInOut),
      ),
    );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _dot1Animation.value,
              child: _buildDot(),
            );
          },
        ),
        SizedBox(width: widget.dotSize * 0.6),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _dot2Animation.value,
              child: _buildDot(),
            );
          },
        ),
        SizedBox(width: widget.dotSize * 0.6),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _dot3Animation.value,
              child: _buildDot(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDot() {
    return Container(
      width: widget.dotSize,
      height: widget.dotSize,
      decoration: BoxDecoration(
        color: widget.dotColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FadeInPage extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const FadeInPage({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 220),
  });

  @override
  State<FadeInPage> createState() => _FadeInPageState();
}

class _FadeInPageState extends State<FadeInPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity, child: widget.child);
  }
}

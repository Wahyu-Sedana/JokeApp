import 'dart:ui';

import 'package:flutter/material.dart';

class SafeContentWrapper extends StatefulWidget {
  const SafeContentWrapper({
    super.key,
    required this.isSafe,
    required this.child,
  });

  final bool isSafe;
  final Widget child;

  @override
  State<SafeContentWrapper> createState() => _SafeContentWrapperState();
}

class _SafeContentWrapperState extends State<SafeContentWrapper> {
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _revealed = widget.isSafe;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSafe) return widget.child;

    return Stack(
      children: [
        ImageFiltered(
          imageFilter: _revealed
              ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
              : ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: widget.child,
        ),
        if (!_revealed) _ExplicitOverlay(onReveal: () => setState(() => _revealed = true)),
      ],
    );
  }
}

class _ExplicitOverlay extends StatelessWidget {
  const _ExplicitOverlay({required this.onReveal});

  final VoidCallback onReveal;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final outline = Theme.of(context).colorScheme.outline;

    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: surface.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline_rounded, size: 22, color: muted),
            const SizedBox(height: 8),
            Text(
              'Explicit content',
              style: TextStyle(fontSize: 13, color: muted),
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: onReveal,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  border: Border.all(color: outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Show anyway',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';

class LiquidGlassNavigationBar extends StatelessWidget {
  const LiquidGlassNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.destinations,
  }) : assert(destinations.length > 1);

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<LiquidGlassNavigationDestination> destinations;

  static const _barHeight = 72.0;
  static const _horizontalMargin = 20.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(
        _horizontalMargin,
        8,
        _horizontalMargin,
        12,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: scheme.surface.withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: scheme.onSurface.withValues(alpha: 0.08),
              ),
              boxShadow: [
                BoxShadow(
                  color: scheme.shadow.withValues(alpha: 0.16),
                  blurRadius: 28,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: SizedBox(
              height: _barHeight,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final itemWidth = constraints.maxWidth / destinations.length;
                  final pillWidth = itemWidth - 12;

                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 420),
                        curve: Curves.easeOutCubic,
                        left: selectedIndex * itemWidth + 6,
                        top: 8,
                        width: pillWidth,
                        height: _barHeight - 16,
                        child: _LiquidGlassPill(color: scheme.primary),
                      ),
                      Positioned.fill(
                        child: Row(
                          children: [
                            for (var i = 0; i < destinations.length; i++)
                              Expanded(
                                child: _LiquidGlassNavItem(
                                  destination: destinations[i],
                                  selected: selectedIndex == i,
                                  onTap: () => onDestinationSelected(i),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LiquidGlassNavigationDestination {
  const LiquidGlassNavigationDestination({
    required this.icon,
    required this.label,
    Widget? selectedIcon,
  }) : selectedIcon = selectedIcon ?? icon;

  final Widget icon;
  final Widget selectedIcon;
  final String label;
}

class _LiquidGlassPill extends StatelessWidget {
  const _LiquidGlassPill({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.5),
            color.withValues(alpha: 0.18),
            color.withValues(alpha: 0.3),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.38)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 14,
            top: 9,
            child: Container(
              width: 28,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: Colors.white.withValues(alpha: 0.55),
              ),
            ),
          ),
          Positioned(
            right: 13,
            bottom: 12,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiquidGlassNavItem extends StatelessWidget {
  const _LiquidGlassNavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final LiquidGlassNavigationDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = selected ? scheme.primary : scheme.onSurfaceVariant;

    return Semantics(
      selected: selected,
      button: true,
      label: destination.label,
      child: Material(
        color: Colors.transparent,
        child: InkResponse(
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          splashColor: scheme.primary.withValues(alpha: 0.08),
          highlightColor: scheme.primary.withValues(alpha: 0.05),
          onTap: onTap,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            style:
                theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ) ??
                TextStyle(color: color),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  scale: selected ? 1.08 : 1,
                  child: IconTheme(
                    data: IconThemeData(color: color, size: 24),
                    child: selected
                        ? destination.selectedIcon
                        : destination.icon,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  destination.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

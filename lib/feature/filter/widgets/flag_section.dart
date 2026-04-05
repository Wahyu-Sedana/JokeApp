import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/flag_fliter_state.dart';
import 'filter_section.dart';

class FlagSection extends ConsumerWidget {
  const FlagSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilterSection(
      title: 'Content Filter',
      subtitle: "Block content types you don't want to see",
      icon: Icons.block_rounded,
      child: const _FlagGrid(),
    );
  }
}

class _FlagGrid extends ConsumerWidget {
  const _FlagGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flags = ref.watch(flagProvider);
    final notifier = ref.read(flagProvider.notifier);

    final items = [
      (label: 'NSFW',      icon: Icons.warning_rounded,    blocked: flags.isNsfw,      onTap: () => notifier.setNsfw(!flags.isNsfw)),
      (label: 'Religious', icon: Icons.church_rounded,     blocked: flags.isReligious, onTap: () => notifier.setReligious(!flags.isReligious)),
      (label: 'Political', icon: Icons.balance_rounded,    blocked: flags.isPolitical, onTap: () => notifier.setPolitical(!flags.isPolitical)),
      (label: 'Racist',    icon: Icons.person_off_rounded, blocked: flags.isRacist,    onTap: () => notifier.setRacist(!flags.isRacist)),
      (label: 'Sexist',    icon: Icons.no_accounts_rounded,blocked: flags.isSexist,    onTap: () => notifier.setSexist(!flags.isSexist)),
      (label: 'Explicit',  icon: Icons.explicit_rounded,   blocked: flags.isExplicit,  onTap: () => notifier.setExplicit(!flags.isExplicit)),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _FlagChip(
          label: item.label,
          icon: item.icon,
          isBlocked: item.blocked,
          onTap: item.onTap,
        );
      },
    );
  }
}

class _FlagChip extends StatelessWidget {
  const _FlagChip({
    required this.label,
    required this.icon,
    required this.isBlocked,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isBlocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final activeColor = scheme.onSurfaceVariant;

    return Material(
      color: isBlocked
          ? scheme.primaryContainer
          : scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isBlocked
                ? Border.all(color: scheme.onPrimaryContainer.withValues(alpha: 0.3))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                isBlocked ? Icons.block_rounded : icon,
                size: 20,
                color: isBlocked ? scheme.onPrimaryContainer : activeColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isBlocked
                            ? scheme.onPrimaryContainer
                            : activeColor,
                        fontWeight: isBlocked
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

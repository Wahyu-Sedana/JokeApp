import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/category_filter_state.dart';
import 'filter_section.dart';

class CategorySection extends ConsumerWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAny = ref.watch(categoryProvider).isAny;

    return FilterSection(
      title: 'Categories',
      subtitle: 'Choose the types of jokes you want to see',
      icon: Icons.category_rounded,
      child: Column(
        children: [
          FilterTile(
            title: 'Any Category',
            subtitle: 'Show jokes from all categories',
            value: isAny,
            isPrimary: true,
            onChanged: (v) {
              if (v == null) return;
              ref.read(categoryProvider.notifier).setAny(v);
            },
          ),
          if (!isAny) ...[
            const SizedBox(height: 8),
            const _CategoryGrid(),
          ],
        ],
      ),
    );
  }
}

class _CategoryGrid extends ConsumerWidget {
  const _CategoryGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cat = ref.watch(categoryProvider);
    final notifier = ref.read(categoryProvider.notifier);

    final items = [
      (label: 'Programming', icon: Icons.code_rounded,        value: cat.isPrograming,    onTap: () => notifier.setPrograming(!cat.isPrograming)),
      (label: 'Dark Humor',   icon: Icons.dark_mode_rounded,  value: cat.isDark,          onTap: () => notifier.setDark(!cat.isDark)),
      (label: 'Miscellaneous',icon: Icons.shuffle_rounded,    value: cat.isMiscellaneous, onTap: () => notifier.setMiscellaneous(!cat.isMiscellaneous)),
      (label: 'Puns',         icon: Icons.psychology_rounded, value: cat.isPun,           onTap: () => notifier.setPun(!cat.isPun)),
      (label: 'Spooky',       icon: Icons.nightlight_rounded, value: cat.isSpooky,        onTap: () => notifier.setSpooky(!cat.isSpooky)),
      (label: 'Christmas',    icon: Icons.celebration_rounded,value: cat.isChristmas,     onTap: () => notifier.setChristmas(!cat.isChristmas)),
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
        return _CategoryChip(
          label: item.label,
          icon: item.icon,
          isSelected: item.value,
          onTap: item.onTap,
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: isSelected ? scheme.primaryContainer : scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? scheme.onPrimaryContainer
                    : scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? scheme.onPrimaryContainer
                            : scheme.onSurfaceVariant,
                        fontWeight: isSelected
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

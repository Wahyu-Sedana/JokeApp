import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nge_joke_app/feature/filter/states/category_filter_state.dart';
import 'package:nge_joke_app/feature/filter/states/flag_fliter_state.dart';
import 'package:nge_joke_app/feature/filter/states/joke_state.dart';

class FilterScreen extends ConsumerWidget {
  static const String routeName = "/filter_screen";
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog.fullscreen(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _FilterAppBar(),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),
                  _CategorySection(),
                  const SizedBox(height: 32),
                  _BlacklistSection(),
                  const SizedBox(height: 32),
                  _ActionButtons(),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterAppBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.close_rounded),
        tooltip: 'Close',
      ),
      title: Text(
        'Filter Jokes',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () => _resetFilters(ref),
          child: const Text('Reset'),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _resetFilters(WidgetRef ref) {
    final category = ref.read(categoryProvider.notifier);
    final flag = ref.read(flagProvider.notifier);

    // Reset all category filters
    category.setAny(true);
    category.setPrograming(false);
    category.setDark(false);
    category.setMiscellaneous(false);
    category.setPun(false);
    category.setSpooky(false);
    category.setChristmas(false);

    // Reset all flag filters
    flag.setNsfw(false);
    flag.setReligious(false);
    flag.setPolitical(false);
    flag.setRacist(false);
    flag.setSexist(false);
    flag.setExplicit(false);
  }
}

class _CategorySection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _FilterSection(
      title: 'Categories',
      subtitle: 'Choose the types of jokes you want to see',
      icon: Icons.category_rounded,
      child: Column(
        children: [
          _FilterTile(
            title: 'Any Category',
            subtitle: 'Show jokes from all categories',
            value: ref.watch(categoryProvider).isAny,
            onChanged: (value) {
              if (value == null) return;
              ref.read(categoryProvider.notifier).setAny(value);
            },
            isPrimary: true,
          ),
          if (!ref.watch(categoryProvider).isAny) ...[
            const SizedBox(height: 8),
            _CategoryGrid(),
          ],
        ],
      ),
    );
  }
}

class _CategoryGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = [
      _CategoryItem(
          'Programming',
          Icons.code_rounded,
          ref.watch(categoryProvider).isPrograming,
          (value) => ref.read(categoryProvider.notifier).setPrograming(value)),
      _CategoryItem(
          'Dark Humor',
          Icons.dark_mode_rounded,
          ref.watch(categoryProvider).isDark,
          (value) => ref.read(categoryProvider.notifier).setDark(value)),
      _CategoryItem(
          'Miscellaneous',
          Icons.shuffle_rounded,
          ref.watch(categoryProvider).isMiscellaneous,
          (value) =>
              ref.read(categoryProvider.notifier).setMiscellaneous(value)),
      _CategoryItem(
          'Puns',
          Icons.psychology_rounded,
          ref.watch(categoryProvider).isPun,
          (value) => ref.read(categoryProvider.notifier).setPun(value)),
      _CategoryItem(
          'Spooky',
          Icons.nightlight_rounded,
          ref.watch(categoryProvider).isSpooky,
          (value) => ref.read(categoryProvider.notifier).setSpooky(value)),
      _CategoryItem(
          'Christmas',
          Icons.celebration_rounded,
          ref.watch(categoryProvider).isChristmas,
          (value) => ref.read(categoryProvider.notifier).setChristmas(value)),
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
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryChip(
          title: category.title,
          icon: category.icon,
          isSelected: category.isSelected,
          onTap: () => category.onChanged(!category.isSelected),
        );
      },
    );
  }
}

class _CategoryItem {
  final String title;
  final IconData icon;
  final bool isSelected;
  final Function(bool) onChanged;

  _CategoryItem(this.title, this.icon, this.isSelected, this.onChanged);
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : Theme.of(context).colorScheme.surfaceVariant,
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
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
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

class _BlacklistSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _FilterSection(
      title: 'Content Filter',
      subtitle: 'Block content types you don\'t want to see',
      icon: Icons.block_rounded,
      child: _BlacklistGrid(),
    );
  }
}

class _BlacklistGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flags = [
      _FlagItem(
          'NSFW',
          Icons.warning_rounded,
          Colors.red,
          ref.watch(flagProvider).isNsfw,
          (value) => ref.read(flagProvider.notifier).setNsfw(value)),
      _FlagItem(
          'Religious',
          Icons.church_rounded,
          Colors.blue,
          ref.watch(flagProvider).isReligious,
          (value) => ref.read(flagProvider.notifier).setReligious(value)),
      _FlagItem(
          'Political',
          Icons.balance_rounded,
          Colors.purple,
          ref.watch(flagProvider).isPolitical,
          (value) => ref.read(flagProvider.notifier).setPolitical(value)),
      _FlagItem(
          'Racist',
          Icons.person_off_rounded,
          Colors.orange,
          ref.watch(flagProvider).isRacist,
          (value) => ref.read(flagProvider.notifier).setRacist(value)),
      _FlagItem(
          'Sexist',
          Icons.no_accounts_rounded,
          Colors.pink,
          ref.watch(flagProvider).isSexist,
          (value) => ref.read(flagProvider.notifier).setSexist(value)),
      _FlagItem(
          'Explicit',
          Icons.explicit_rounded,
          Colors.deepOrange,
          ref.watch(flagProvider).isExplicit,
          (value) => ref.read(flagProvider.notifier).setExplicit(value)),
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
      itemCount: flags.length,
      itemBuilder: (context, index) {
        final flag = flags[index];
        return _FlagChip(
          title: flag.title,
          icon: flag.icon,
          color: flag.color,
          isBlocked: flag.isBlocked,
          onTap: () => flag.onChanged(!flag.isBlocked),
        );
      },
    );
  }
}

class _FlagItem {
  final String title;
  final IconData icon;
  final Color color;
  final bool isBlocked;
  final Function(bool) onChanged;

  _FlagItem(this.title, this.icon, this.color, this.isBlocked, this.onChanged);
}

class _FlagChip extends StatelessWidget {
  const _FlagChip({
    required this.title,
    required this.icon,
    required this.color,
    required this.isBlocked,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color color;
  final bool isBlocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isBlocked
          ? color.withOpacity(0.1)
          : Theme.of(context).colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isBlocked ? Border.all(color: color, width: 2) : null,
          ),
          child: Row(
            children: [
              Icon(
                isBlocked ? Icons.block_rounded : icon,
                size: 20,
                color: isBlocked
                    ? color
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: isBlocked
                            ? color
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight:
                            isBlocked ? FontWeight.w600 : FontWeight.normal,
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

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 20,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }
}

class _FilterTile extends StatelessWidget {
  const _FilterTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isPrimary = false,
  });

  final String title;
  final String subtitle;
  final bool value;
  final Function(bool?) onChanged;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: value && isPrimary
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)
            : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

class _ActionButtons extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _applyFilters(context, ref),
            icon: const Icon(Icons.search_rounded),
            label: const Text('Apply Filters'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
            label: const Text('Cancel'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _applyFilters(BuildContext context, WidgetRef ref) {
    ref.invalidate(jokeProvider);
    Navigator.of(context).pop();

    // Show snackbar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text('Filters applied successfully'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

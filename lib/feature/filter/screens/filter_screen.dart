import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/category_filter_state.dart';
import '../states/flag_fliter_state.dart';
import '../widgets/category_section.dart';
import '../widgets/filter_action_buttons.dart';
import '../widgets/flag_section.dart';

class FilterScreen extends ConsumerWidget {
  static const String routeName = '/filter_screen';

  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog.fullscreen(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            _FilterAppBar(onReset: () => _resetFilters(ref)),
            const SliverPadding(
              padding: EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate.fixed([
                  SizedBox(height: 8),
                  CategorySection(),
                  SizedBox(height: 32),
                  FlagSection(),
                  SizedBox(height: 32),
                  FilterActionButtons(),
                  SizedBox(height: 16),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetFilters(WidgetRef ref) {
    final category = ref.read(categoryProvider.notifier);
    category.setAny(true);
    category.setPrograming(false);
    category.setDark(false);
    category.setMiscellaneous(false);
    category.setPun(false);
    category.setSpooky(false);
    category.setChristmas(false);

    final flag = ref.read(flagProvider.notifier);
    flag.setNsfw(false);
    flag.setReligious(false);
    flag.setPolitical(false);
    flag.setRacist(false);
    flag.setSexist(false);
    flag.setExplicit(false);
  }
}

class _FilterAppBar extends StatelessWidget {
  const _FilterAppBar({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.close_rounded),
        tooltip: 'Close',
      ),
      title: Text(
        'Filter Jokes',
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      actions: [
        TextButton(onPressed: onReset, child: const Text('Reset')),
        const SizedBox(width: 8),
      ],
    );
  }
}

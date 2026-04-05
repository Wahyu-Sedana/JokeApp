import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../filter/screens/filter_screen.dart';
import '../../filter/states/joke_state.dart';
import '../states/theme_state.dart';
import '../widgets/joke_card.dart';
import '../widgets/joke_list_states.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _listController;

  @override
  void initState() {
    super.initState();
    _listController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.refresh(jokeProvider.future).whenComplete(() {});
          _listController.forward(from: 0.0);
        },
        color: Theme.of(context).colorScheme.onSurface,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: CustomScrollView(
          slivers: [
            _HomeAppBar(),
            _JokesList(listController: _listController),
          ],
        ),
      ),
    );
  }
}

class _HomeAppBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;

    return SliverAppBar(
      pinned: true,
      title: const Text('Joke Collection'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: Theme.of(context).colorScheme.outline),
      ),
      actions: [
        IconButton(
          onPressed: () {
            ref.read(themeModeProvider.notifier).state =
                isDark ? ThemeMode.light : ThemeMode.dark;
          },
          icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
          tooltip: isDark ? 'Light mode' : 'Dark mode',
        ),
        IconButton(
          onPressed: () => showDialog(
            context: context,
            barrierLabel: FilterScreen.routeName,
            builder: (_) => const FilterScreen(),
          ),
          icon: const Icon(Icons.tune_rounded),
          tooltip: 'Filter',
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _JokesList extends ConsumerWidget {
  const _JokesList({required this.listController});

  final AnimationController listController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncJokes = ref.watch(jokeProvider);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      sliver: asyncJokes.when(
        data: (jokesModel) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            listController.forward(from: 0.0);
          });

          if (jokesModel.jokes.isEmpty) {
            return const SliverToBoxAdapter(child: JokeEmptyState());
          }

          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => AnimatedBuilder(
                animation: listController,
                builder: (context, _) {
                  final t = Curves.easeOut.transform(
                    (listController.value - index * 0.08).clamp(0.0, 1.0),
                  );
                  return Opacity(
                    opacity: t,
                    child: Transform.translate(
                      offset: Offset(0, 12 * (1 - t)),
                      child: JokeCard(joke: jokesModel.jokes[index]),
                    ),
                  );
                },
              ),
              childCount: jokesModel.jokes.length,
            ),
          );
        },
        error: (_, __) => SliverToBoxAdapter(
          child: JokeErrorState(onRetry: () => ref.invalidate(jokeProvider)),
        ),
        loading: () => const SliverToBoxAdapter(child: JokeLoadingState()),
      ),
    );
  }
}

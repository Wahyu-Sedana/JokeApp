import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/models/api/joke_model.dart';
import '../../../core/models/api/jokes_model.dart';
import '../../filter/states/joke_state.dart';
import '../../filter/screens/filter_screen.dart';
import '../states/theme_state.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () {
        return ref.refresh(jokeProvider.future);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "joke List",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          actions: [
            IconButton(
              onPressed: () {
                final mode = ref.read(themeModeProvider);
                if (mode == ThemeMode.dark) {
                  ref.read(themeModeProvider.notifier).state = ThemeMode.light;
                } else {
                  ref.read(themeModeProvider.notifier).state = ThemeMode.dark;
                }
              },
              icon: ref.watch(themeModeProvider) == ThemeMode.light
                  ? const Icon(Icons.light_mode)
                  : const Icon(Icons.dark_mode),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  barrierLabel: FilterScreen.routeName,
                  context: context,
                  builder: (context) {
                    return const FilterScreen();
                  },
                );
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        body: Consumer(builder: (context, ref, _) {
          AsyncValue<JokesModel> data = ref.watch(jokeProvider);
          return data.when(
            data: (result) {
              final jokes = result.jokes;
              return ListView.builder(
                itemCount: result.jokes.length,
                itemBuilder: (context, index) {
                  return JokeItem(joke: jokes[index]);
                },
              );
            },
            error: (_, __) => const Center(child: Text("Error")),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        }),
      ),
    );
  }
}

class JokeItem extends StatelessWidget {
  const JokeItem({
    Key? key,
    required this.joke,
  }) : super(key: key);

  final JokeModel joke;

  @override
  Widget build(BuildContext context) {
    bool isJokeSingle = joke.type == "single";
    bool isSafe = joke.safe;
    return HideContent(
      isSafe: isSafe,
      joke: joke,
      child: ListTile(
        leading: SizedBox(
          width: 40,
          child: Text(
            isJokeSingle ? "One Part" : "Two Part",
            maxLines: 2,
            overflow: TextOverflow.visible,
            style: isJokeSingle
                ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.deepOrangeAccent,
                    )
                : Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        isThreeLine: isJokeSingle ? false : true,
        title: Text(
          joke.setup ?? joke.joke ?? "",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        subtitle: Text(joke.delivery ?? ""),
        trailing: IconButton(
          onPressed: () {
            String data = "${joke.setup}, ${joke.setup}";
            Share.share(joke.joke ?? data);
          },
          icon: const Icon(Icons.share),
        ),
      ),
    );
  }
}

class HideContent extends StatelessWidget {
  const HideContent({
    Key? key,
    required this.isSafe,
    required this.joke,
    required this.child,
  }) : super(key: key);

  final bool isSafe;
  final JokeModel joke;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //TODO: show hide explisit

        // Positioned(
        //   left: 0,
        //   right: 0,
        //   top: 0,
        //   bottom: 0,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       const Text("Explicit Content"),
        //       IconButton(
        //         onPressed: () {},
        //         icon: const Icon(Icons.hide_source_rounded),
        //       )
        //     ],
        //   ),
        // ),
        ImageFiltered(
          imageFilter: isSafe
              ? ImageFilter.blur(sigmaX: 0, sigmaY: 0)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: child,
        ),
      ],
    );
  }
}

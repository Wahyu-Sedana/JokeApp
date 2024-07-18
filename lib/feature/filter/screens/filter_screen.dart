import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nge_joke_app/feature/filter/states/category_filter_state.dart';
import 'package:nge_joke_app/feature/filter/states/flag_fliter_state.dart';
import 'package:nge_joke_app/feature/filter/states/joke_state.dart';
import 'package:nge_joke_app/feature/jokes/states/theme_state.dart';

class FilterScreen extends ConsumerWidget {
  static const String routeName = "/filter_screen";
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: themeMode == ThemeMode.dark ? Colors.black45 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Consumer(
            builder: (context, ref, _) {
              final category = ref.read(categoryProvider.notifier);
              final flag = ref.read(flagProvider.notifier);
              return Form(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close_outlined),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Category",
                          textAlign: TextAlign.center,
                        ),
                        CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: ref.watch(categoryProvider).isAny,
                          onChanged: (value) {
                            if (value == null) return;
                            category.setAny(value);
                          },
                          title: const Text("Any"),
                        ),
                        const Divider(height: 1),
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 4.0,
                          children: [
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: ref.watch(categoryProvider).isPrograming,
                              onChanged: (value) {
                                if (value == null) return;
                                category.setPrograming(value);
                              },
                              title: const Text("Programing"),
                            ),
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: ref.watch(categoryProvider).isDark,
                              onChanged: (value) {
                                if (value == null) return;
                                category.setDark(value);
                              },
                              title: const Text("Dark"),
                            ),
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value:
                                  ref.watch(categoryProvider).isMiscellaneous,
                              onChanged: (value) {
                                if (value == null) return;
                                category.setMiscellaneous(value);
                              },
                              title: const Text("Miscellaneous"),
                            ),
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: ref.watch(categoryProvider).isPun,
                              onChanged: (value) {
                                if (value == null) return;
                                category.setPun(value);
                              },
                              title: const Text("Pun"),
                            ),
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: ref.watch(categoryProvider).isSpooky,
                              onChanged: (value) {
                                if (value == null) return;
                                category.setSpooky(value);
                              },
                              title: const Text("Spooky"),
                            ),
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: ref.watch(categoryProvider).isChristmas,
                              onChanged: (value) {
                                if (value == null) return;
                                category.setChristmas(value);
                              },
                              title: const Text("Christmas"),
                            ),
                          ],
                        )
                      ],
                    ),
                    const Divider(height: 1),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "BlackList",
                          textAlign: TextAlign.center,
                        ),
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 4.0,
                          children: [
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: ref.watch(flagProvider).isNsfw,
                              onChanged: (value) {
                                if (value == null) return;
                                flag.setNsfw(value);
                              },
                              title: const Text("Nsfw"),
                            ),
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: ref.watch(flagProvider).isReligious,
                              onChanged: (value) {
                                if (value == null) return;
                                flag.setReligious(value);
                              },
                              title: const Text("Religious"),
                            ),
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: ref.watch(flagProvider).isPolitical,
                              onChanged: (value) {
                                if (value == null) return;
                                flag.setPolitical(value);
                              },
                              title: const Text("Political"),
                            ),
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: ref.watch(flagProvider).isRacist,
                              onChanged: (value) {
                                if (value == null) return;
                                flag.setRacist(value);
                              },
                              title: const Text("Racist"),
                            ),
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: ref.watch(flagProvider).isSexist,
                              onChanged: (value) {
                                if (value == null) return;
                                flag.setSexist(value);
                              },
                              title: const Text("Sexist"),
                            ),
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: ref.watch(flagProvider).isExplicit,
                              onChanged: (value) {
                                if (value == null) return;
                                flag.setExplicit(value);
                              },
                              title: const Text("Explicit"),
                            ),
                          ],
                        )
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(jokeProvider);
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.find_in_page),
                      label: const Text("Generate"),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

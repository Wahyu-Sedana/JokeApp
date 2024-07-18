import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nge_joke_app/feature/jokes/states/theme_state.dart';

import 'feature/jokes/screens/home_screen.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [
        Logger(),
      ],
      child: const App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Generate JokeAPI.dev',
      theme: ThemeData(
        brightness: Brightness.light,
        iconTheme: const IconThemeData(color: Colors.black),
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            letterSpacing: -5,
            color: Colors.white,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(78, 11, 62, 1),
          centerTitle: true,
          toolbarHeight: 75,
        ),
        listTileTheme: const ListTileThemeData(
          shape: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        iconTheme: const IconThemeData(color: Colors.white),
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            letterSpacing: -5,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          toolbarHeight: 75,
        ),
        listTileTheme: const ListTileThemeData(
          style: ListTileStyle.drawer,
          shape: Border(
            bottom: BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      ),
      themeMode: mode,
      home: const HomePage(),
    );
  }
}

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    log(
      '''
      {
        "provider": "${provider.name ?? provider.runtimeType}",
        "newValue": "$newValue"
      }''',
    );
  }
}

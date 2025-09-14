import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nge_joke_app/feature/jokes/screens/splash_screen.dart';

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

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Joke Collection',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(78, 11, 62, 1),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0D0F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(78, 11, 62, 1),
          foregroundColor: Colors.white,
          centerTitle: true,
          toolbarHeight: 75,
          elevation: 8,
          shadowColor: Colors.black54,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 24,
          ),
        ),
        textTheme: const TextTheme(
          displaySmall: TextStyle(
            letterSpacing: -1,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          headlineSmall: TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: Colors.white70,
          ),
        ),
        cardTheme: CardTheme(
          elevation: 4,
          shadowColor: Colors.black54,
          color: const Color(0xFF1A1A1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white70,
          iconColor: Colors.white70,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(78, 11, 62, 1),
            foregroundColor: Colors.white,
            elevation: 8,
            shadowColor: Colors.black54,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromRGBO(78, 11, 62, 1),
          foregroundColor: Colors.white,
          elevation: 12,
        ),
      ),
      home: AppWithSplash(
        homeScreen: const HomePage(),
      ),
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

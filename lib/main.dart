import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nge_joke_app/feature/jokes/screens/splash_screen.dart';
import 'package:nge_joke_app/feature/jokes/states/theme_state.dart';

import 'feature/jokes/screens/home_screen.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [Logger()],
      child: const App(),
    ),
  );
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Joke Collection',
      themeMode: themeMode,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      home: AppWithSplash(homeScreen: const HomePage()),
    );
  }
}

ThemeData _lightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF111111),
      surfaceContainerHighest: Color(0xFFF3F3F3),
      onSurfaceVariant: Color(0xFF777777),
      primary: Color(0xFF111111),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFEEEEEE),
      onPrimaryContainer: Color(0xFF111111),
      secondary: Color(0xFF555555),
      onSecondary: Color(0xFFFFFFFF),
      outline: Color(0xFFE8E8E8),
      outlineVariant: Color(0xFFF0F0F0),
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
      foregroundColor: Color(0xFF111111),
      centerTitle: true,
      toolbarHeight: 56,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Color(0xFF111111),
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: Color(0xFF888888), size: 22),
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        letterSpacing: -1,
        fontWeight: FontWeight.w600,
        color: Color(0xFF111111),
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: Color(0xFF111111),
      ),
      titleLarge: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF111111)),
      titleMedium: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF111111)),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF777777)),
      labelLarge: TextStyle(color: Color(0xFF111111), fontWeight: FontWeight.w500),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: const Color(0xFFFAFAFA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFEAEAEA), width: 1),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      textColor: Color(0xFF777777),
      iconColor: Color(0xFF777777),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return const Color(0xFF111111);
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(const Color(0xFFFFFFFF)),
      side: const BorderSide(color: Color(0xFFCCCCCC), width: 1.5),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF111111),
        foregroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF111111),
        side: const BorderSide(color: Color(0xFFDDDDDD)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF111111),
        foregroundColor: const Color(0xFFFFFFFF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFFEEEEEE), thickness: 1),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF111111),
      contentTextStyle: const TextStyle(color: Color(0xFFFFFFFF)),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

ThemeData _darkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      surface: Color(0xFF000000),
      onSurface: Color(0xFFFFFFFF),
      surfaceContainerHighest: Color(0xFF1A1A1A),
      onSurfaceVariant: Color(0xFF666666),
      primary: Color(0xFFFFFFFF),
      onPrimary: Color(0xFF000000),
      primaryContainer: Color(0xFF1F1F1F),
      onPrimaryContainer: Color(0xFFFFFFFF),
      secondary: Color(0xFFAAAAAA),
      onSecondary: Color(0xFF000000),
      outline: Color(0xFF222222),
      outlineVariant: Color(0xFF1A1A1A),
    ),
    scaffoldBackgroundColor: const Color(0xFF000000),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF000000),
      foregroundColor: Color(0xFFFFFFFF),
      centerTitle: true,
      toolbarHeight: 56,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: Color(0xFF888888), size: 22),
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        letterSpacing: -1,
        fontWeight: FontWeight.w600,
        color: Color(0xFFFFFFFF),
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: Color(0xFFFFFFFF),
      ),
      titleLarge: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFFFFFFF)),
      titleMedium: TextStyle(fontWeight: FontWeight.w500, color: Color(0xFFFFFFFF)),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF888888)),
      labelLarge: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.w500),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: const Color(0xFF111111),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF1F1F1F), width: 1),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      textColor: Color(0xFF888888),
      iconColor: Color(0xFF888888),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return const Color(0xFFFFFFFF);
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(const Color(0xFF000000)),
      side: const BorderSide(color: Color(0xFF444444), width: 1.5),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF000000),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFFFFFFF),
        side: const BorderSide(color: Color(0xFF333333)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF000000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    dividerTheme: const DividerThemeData(color: Color(0xFF1A1A1A), thickness: 1),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF1A1A1A),
      contentTextStyle: const TextStyle(color: Color(0xFFFFFFFF)),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
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

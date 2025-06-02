import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dict_foot_traffic/Screens/main_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 0, 217, 255),
  surface: const Color.fromARGB(255, 0, 70, 199),
);

final theme = ThemeData(fontFamily: 'PalatinoLinotype').copyWith(
  scaffoldBackgroundColor: colorScheme.surface,
  colorScheme: colorScheme,
  textTheme: const TextTheme()
      .apply(bodyColor: colorScheme.primary, displayColor: colorScheme.primary),
);

Future main() async {
  //Future is used MAYBE for application version and NOT for Mobile Version
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const MainScreen(),
    ),
  ));
}

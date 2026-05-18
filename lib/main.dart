import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/item_repository.dart';
import 'bloc/item_cubit.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  final repo = ItemRepository();
  runApp(
    RepositoryProvider.value(
      value: repo,
      child: BlocProvider(
        create: (_) => ItemCubit(repo)..getItems(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Campus Lost & Found',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF00897B),
              brightness: Brightness.light,
            ),
            cardTheme: CardTheme(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF00897B), width: 2),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          home: const HomeScreen(),
        ),
      ),
    ),
  );
}

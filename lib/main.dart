import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_perfect_pitch_trainer/services/auto_skip_timer.dart';

import 'components/home_page.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(autoSkipTimerProvider);
    return  MaterialApp(
      title: 'Simple Perfect Pitch Trainer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Simple Perfect Pitch Trainer'),
    );
  }
}

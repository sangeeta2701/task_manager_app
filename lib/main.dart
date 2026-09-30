import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/core/constants/app.colors.dart';
import 'package:task_manager_app/features/home/provider/task_provider.dart';
import 'package:task_manager_app/features/splash/screen/splash_screen.dart';


void main() {
  runApp(
    // 1. Provide the TaskProvider at the very top level
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
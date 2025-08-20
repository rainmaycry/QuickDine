import 'package:flutter/material.dart';
import 'core/app_router.dart';

void main() {
  runApp(const QuickDineApp());
}

class QuickDineApp extends StatelessWidget {
  const QuickDineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QuickDine',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      routerConfig: AppRouter.router,
    );
  }
}

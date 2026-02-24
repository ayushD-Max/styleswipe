import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'services/storage_service.dart';
import 'controllers/product_controller.dart';
import 'controllers/history_controller.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final storageService = await StorageService().init();
  Get.put(storageService);

  // Initialize controllers
  Get.put(HistoryController());
  Get.put(ProductController());

  runApp(const StyleSwipeApp());
}

class StyleSwipeApp extends StatelessWidget {
  const StyleSwipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'StyleSwipe',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}

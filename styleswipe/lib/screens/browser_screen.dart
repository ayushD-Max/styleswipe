import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/browser_controller.dart';

class BrowserScreen extends StatefulWidget {
  final String url;
  final String title;

  const BrowserScreen({super.key, required this.url, required this.title});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  late final BrowserController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(BrowserController());
    controller.initController(widget.url);
  }

  @override
  void dispose() {
    Get.delete<BrowserController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Column(
              children: [
                Text(
                  controller.currentTitle.value,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  controller.currentUrl.value,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Obx(() => controller.isLoading.value
              ? LinearProgressIndicator(
                  value: controller.progress.value,
                  backgroundColor: Colors.transparent,
                  color: Theme.of(context).colorScheme.primary,
                )
              : const SizedBox(height: 4)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.reload(),
          ),
        ],
      ),
      body: WebViewWidget(controller: controller.controller),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () => controller.goBack(),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              onPressed: () => controller.goForward(),
            ),
            IconButton(
              icon: const Icon(Icons.home_rounded),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}

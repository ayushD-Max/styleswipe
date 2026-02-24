import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'history_controller.dart';

class BrowserController extends GetxController {
  late final WebViewController controller;
  final RxString currentUrl = ''.obs;
  final RxString currentTitle = 'Loading...'.obs;
  final RxBool isLoading = true.obs;
  final RxDouble progress = 0.0.obs;

  final HistoryController historyController = Get.find<HistoryController>();

  void initController(String initialUrl) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int p) {
            progress.value = p / 100;
          },
          onPageStarted: (String url) {
            isLoading(true);
            currentUrl.value = url;
          },
          onPageFinished: (String url) async {
            isLoading(false);
            final title = await controller.getTitle() ?? url;
            currentTitle.value = title;
            currentUrl.value = url;
            historyController.addHistoryEntry(url, title);
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl));
  }

  void reload() => controller.reload();
  void goBack() async {
    if (await controller.canGoBack()) {
      controller.goBack();
    }
  }
  void goForward() async {
    if (await controller.canGoForward()) {
      controller.goForward();
    }
  }
}

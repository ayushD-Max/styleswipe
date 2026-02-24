import 'package:get/get.dart';
import '../models/history_entry.dart';
import '../services/storage_service.dart';

class HistoryController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  final RxList<HistoryEntry> history = <HistoryEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() {
    history.assignAll(_storageService.getHistory());
  }

  void addHistoryEntry(String url, String title) {
    final entry = HistoryEntry(
      url: url,
      title: title,
      timestamp: DateTime.now(),
    );
    _storageService.saveHistoryEntry(entry);
    loadHistory();
  }

  void clearHistory() async {
    await _storageService.clearHistory();
    history.clear();
  }
}

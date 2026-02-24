import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_entry.dart';

class StorageService {
  static const String keyLikedProducts = 'liked_products';
  static const String keyDislikedProducts = 'disliked_products';
  static const String keyHistory = 'browsing_history';

  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Liked Products
  List<int> getLikedProductIds() {
    final List<String>? ids = _prefs.getStringList(keyLikedProducts);
    return ids?.map((e) => int.parse(e)).toList() ?? [];
  }

  Future<void> saveLikedProductId(int id) async {
    final List<int> current = getLikedProductIds();
    if (!current.contains(id)) {
      current.add(id);
      await _prefs.setStringList(keyLikedProducts, current.map((e) => e.toString()).toList());
    }
  }

  Future<void> removeLikedProductId(int id) async {
    final List<int> current = getLikedProductIds();
    if (current.contains(id)) {
      current.remove(id);
      await _prefs.setStringList(keyLikedProducts, current.map((e) => e.toString()).toList());
    }
  }

  // Disliked Products
  List<int> getDislikedProductIds() {
    final List<String>? ids = _prefs.getStringList(keyDislikedProducts);
    return ids?.map((e) => int.parse(e)).toList() ?? [];
  }

  Future<void> saveDislikedProductId(int id) async {
    final List<int> current = getDislikedProductIds();
    if (!current.contains(id)) {
      current.add(id);
      await _prefs.setStringList(keyDislikedProducts, current.map((e) => e.toString()).toList());
    }
  }

  // History
  List<HistoryEntry> getHistory() {
    final List<String>? historyJson = _prefs.getStringList(keyHistory);
    if (historyJson == null) return [];
    return historyJson.map((e) => HistoryEntry.fromJson(jsonDecode(e))).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  Future<void> saveHistoryEntry(HistoryEntry entry) async {
    final List<HistoryEntry> current = getHistory();
    // Avoid double entries for same URL in close succession if needed, 
    // but here we just add and keep limited history
    current.insert(0, entry);
    // Keep last 100 entries
    final toSave = current.take(100).toList();
    await _prefs.setStringList(
      keyHistory,
      toSave.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  Future<void> clearHistory() async {
    await _prefs.remove(keyHistory);
  }
}

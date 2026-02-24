class HistoryEntry {
  final String url;
  final String title;
  final DateTime timestamp;

  HistoryEntry({
    required this.url,
    required this.title,
    required this.timestamp,
  });

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      url: json['url'],
      title: json['title'] ?? 'No Title',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'title': title,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

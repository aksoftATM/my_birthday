class WishItem {
  final String id;
  final String title;
  final String? url;
  final bool isPurchased;
  final DateTime createdAt;

  const WishItem({
    required this.id,
    required this.title,
    this.url,
    this.isPurchased = false,
    required this.createdAt,
  });

  WishItem copyWith({
    String? title,
    String? url,
    bool? isPurchased,
  }) {
    return WishItem(
      id: id,
      title: title ?? this.title,
      url: url ?? this.url,
      isPurchased: isPurchased ?? this.isPurchased,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'isPurchased': isPurchased,
        'createdAt': createdAt.toIso8601String(),
      };

  factory WishItem.fromJson(Map<String, dynamic> json) => WishItem(
        id: json['id'] as String,
        title: json['title'] as String,
        url: json['url'] as String?,
        isPurchased: json['isPurchased'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

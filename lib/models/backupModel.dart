class BackUpData {
  dynamic category;
  dynamic bookMark;

  BackUpData({required this.category, required this.bookMark});

  factory BackUpData.fromJson(Map<String, dynamic> json) {
    return BackUpData(
      category: json['category'],
      bookMark: json['bookMark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'bookMark': bookMark,
    };
  }
}

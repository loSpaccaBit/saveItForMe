class CategoryMark {
  final int? id_category;
  final String titolo;

  CategoryMark({this.id_category, required this.titolo});

  factory CategoryMark.fromJson(Map<String, dynamic> json) =>
      CategoryMark(id_category: json['id_category'], titolo: json['titolo']);

  Map<String, dynamic> toJson() =>
      {'id_category': id_category, 'titolo': titolo};
}

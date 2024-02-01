class BookMark {
  final int? id_bookMark;
  final int id_category;
  final String titolo;
  final String url;
  final String descrizione;
  BookMark(
      {this.id_bookMark,
      required this.id_category,
      required this.titolo,
      required this.url,
      required this.descrizione});

  factory BookMark.fromJson(Map<String, dynamic> json) => BookMark(
      id_bookMark: json['id_bookMark'],
      id_category: json['id_category'],
      titolo: json['titolo'],
      url: json['url'],
      descrizione: json['descrizione']);
  Map<String, dynamic> toJson() => {
        'id_bookMark': id_bookMark,
        'id_category': id_category,
        'titolo': titolo,
        'url': url,
        'descrizione': descrizione,
      };
}

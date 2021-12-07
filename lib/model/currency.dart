class GbpCurrency {
  final String currency;
  final String currencyCode;
  final double amount;

  GbpCurrency({
    required this.currency,
    required this.currencyCode,
    required this.amount,
  });

  // factory Book.fromJson(Map<String, dynamic> json) => Book(
  //   id: json['id'],
  //   author: json['author'],
  //   title: json['title'],
  //   urlImage: json['urlImage'],
  // );
  //
  // Map<String, dynamic> toJson() => {
  //   'id': id,
  //   'title': title,
  //   'author': author,
  //   'urlImage': urlImage,
  // };
}

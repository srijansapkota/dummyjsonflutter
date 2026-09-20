class Product {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final String? description;
  final double rating;
  final List<Reviews> reviews;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.description,
    required this.rating,
    required this.reviews,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'],
      description: json['description'],
      rating: (json['rating'] as num).toDouble(),
      reviews: (json['reviews'] as List)
          .map((review) => Reviews.fromJson(review))
          .toList(),
    );
  }
}

class Reviews {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;

  Reviews({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      rating: json['rating'],
      comment: json['comment'],
      date: json['date'],
      reviewerName: json['reviewerName'],
      reviewerEmail: json['reviewerEmail'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['rating'] = rating;
    data['comment'] = comment;
    data['date'] = date;
    data['reviewerName'] = reviewerName;
    data['reviewerEmail'] = reviewerEmail;

    return data;
  }
}
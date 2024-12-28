class CardImage {
  final String? imageUrl;
  final double? aspectRatio;

  CardImage({this.aspectRatio, this.imageUrl});

  factory CardImage.fromJson(Map<String, dynamic> json) {
    return CardImage(
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble(),
      imageUrl: json['image_url'],
    );
  }
}

class CardImage {
  final String? imageType;
  final String? imageUrl;
  final String? assetType;
  final double? aspectRatio;

  CardImage({this.imageType, this.aspectRatio, this.assetType, this.imageUrl});

  factory CardImage.fromJson(Map<String, dynamic> json) {
    return CardImage(
      imageType: json['image_type'],
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble(),
      assetType: json['asset_type'],
      imageUrl: json['image_url'],
    );
  }
}

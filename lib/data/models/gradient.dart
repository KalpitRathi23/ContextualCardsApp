class GradientModel {
  final List<String> colors;
  final int angle;

  GradientModel({required this.colors, required this.angle});

  factory GradientModel.fromJson(Map<String, dynamic> json) {
    return GradientModel(
      colors: (json['colors'] as List).map((color) => color as String).toList(),
      angle: json['angle'] ?? 0,
    );
  }
}

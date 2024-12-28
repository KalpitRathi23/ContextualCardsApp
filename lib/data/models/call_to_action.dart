class CallToAction {
  final String text;
  final String? url;
  final String? bgColor;
  final String? textColor;

  CallToAction({
    required this.text,
    this.url,
    this.bgColor,
    this.textColor,
  });

  factory CallToAction.fromJson(Map<String, dynamic> json) {
    return CallToAction(
      text: json['text'],
      url: json['url'],
      bgColor: json['bg_color'],
      textColor: json['text_color'],
    );
  }
}

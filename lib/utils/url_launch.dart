import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';

class URLLaunch {
  static Future<void> launchURL(String? url) async {
    if (url != null && url.isNotEmpty) {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        log('Could not launch URL: $url');
      }
    } else {
      log('Invalid URL: $url');
    }
  }
}

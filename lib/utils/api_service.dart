import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://polyjuice.kong.fampay.co/mock/famapp/feed/home_section/";

  static Future<List<dynamic>> fetchCardGroups(String slug) async {
    final url = Uri.parse('$baseUrl?slugs=$slug');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("API error: $error");
    }
  }
}

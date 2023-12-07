import 'package:http/http.dart' as http;

class ApiService {
  final http.Client _httpClient;
  static const String baseUrl = 'https://newsapi.org/v2/';

  static final ApiService _instance = ApiService._internal(
    http.Client(),
  );

  factory ApiService() => _instance;

  ApiService._internal(this._httpClient);

  http.Client get client => _httpClient;
}

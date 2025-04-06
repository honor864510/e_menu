import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A client for interacting with the Directus API.
///
/// This class provides functionality to communicate with a Directus backend
/// using the Dio HTTP client.
class DirectusClient {
  /// Creates a new [DirectusClient] instance.
  ///
  /// Requires a [directusUrl] parameter which specifies the base URL of the Directus API.
  /// Initializes a new [Dio] instance for HTTP communications.
  DirectusClient({required this.directusUrl, required SharedPreferences preferences}) : _preferences = preferences {
    dio = Dio();
  }

  /// Shared preferences
  late final SharedPreferences _preferences;

  /// The base URL of the Directus API.
  final String directusUrl;

  /// Directus url
  String get url => _preferences.getString(directusUrlKey) ?? directusUrl;

  /// Directus url
  static const directusUrlKey = 'directus_url';

  /// The Dio HTTP client instance used for making API requests.
  late final Dio dio;
}

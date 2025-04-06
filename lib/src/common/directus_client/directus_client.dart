import 'package:dio/dio.dart';

/// A client for interacting with the Directus API.
///
/// This class provides functionality to communicate with a Directus backend
/// using the Dio HTTP client.
class DirectusClient {
  /// Creates a new [DirectusClient] instance.
  ///
  /// Requires a [url] parameter which specifies the base URL of the Directus API.
  /// Initializes a new [Dio] instance for HTTP communications.
  DirectusClient({required this.url}) {
    dio = Dio();
  }

  /// The base URL of the Directus API.
  final String url;

  /// The Dio HTTP client instance used for making API requests.
  late final Dio dio;

  /// Creates a copy of this [DirectusClient] with an optionally new [url].
  ///
  /// If [url] is null, the current URL will be used.
  /// Returns a new [DirectusClient] instance with the specified configuration.
  DirectusClient copyWith(String? url) => DirectusClient(url: url ?? this.url);
}

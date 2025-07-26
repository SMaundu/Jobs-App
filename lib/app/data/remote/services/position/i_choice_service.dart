import 'package:dio/dio.dart';

/// An abstract interface for services that provide choices or options, like positions.
abstract class IChoiceService {
  /// Fetches all items from the service.
  Future<Response> getAll({int? limit, int? offset});
}
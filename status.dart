/// A wrapper class to represent the status of an operation,
/// typically an API call. It can hold either a success [data] or a failure [reason].
class Status<T> {
  /// The data returned on a successful operation. Null on failure.
  final T? data;

  /// The reason for a failed operation. Null on success.
  final String? reason;

  /// Private constructor. Use the factory constructors [Status.success] or [Status.failure].
  const Status._({this.data, this.reason});

  /// Creates a success status with optional [data].
  factory Status.success({T? data}) {
    return Status._(data: data);
  }

  /// Creates a failure status with a required [reason].
  factory Status.failure({required String reason}) {
    return Status._(reason: reason);
  }

  /// Returns true if the status is success.
  bool get isSuccess => reason == null;
}
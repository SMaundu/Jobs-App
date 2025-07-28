/// Defines the different types of status for an asynchronous operation.
enum StatusType {
  loading,
  success,
  error,
  // You might also have an 'idle' or 'initial' state if needed
}

/// Represents the status of an asynchronous operation,
/// typically an API request.
/// It can be in a loading, success, or error state.
class Status<T> {
  final StatusType type;
  final T? data;
  final String? message;

  const Status._({required this.type, this.data, this.message});

  /// Creates a loading status.
  factory Status.loading() => const Status._(type: StatusType.loading);

  /// Creates a success status with optional data.
  factory Status.success(T? data) => Status._(type: StatusType.success, data: data);

  /// Creates an error status with an optional message.
  factory Status.error({String? message}) => Status._(type: StatusType.error, message: message);

  // You might also add an 'idle' factory if your controllers use it:
  // factory Status.idle() => const Status._(type: StatusType.idle);


  /// Returns true if the status is loading.
  bool get isLoading => type == StatusType.loading;

  /// Returns true if the status is successful.
  bool get isSuccess => type == StatusType.success;

  /// Returns true if the status is an error.
  bool get isError => type == StatusType.error;

  // You might also add an 'isIdle' getter if your controllers use it:
  // bool get isIdle => type == StatusType.idle;

  @override
  String toString() {
    switch (type) {
      case StatusType.loading:
        return 'Status<${T.runtimeType}>.loading()';
      case StatusType.success:
        return 'Status<${T.runtimeType}>.success(data: $data)';
      case StatusType.error:
        return 'Status<${T.runtimeType}>.error(message: $message)';
      // case StatusType.idle: // Uncomment if you add idle
      //   return 'Status<${T.runtimeType}>.idle()';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Status<T> &&
        type == other.type &&
        data == other.data &&
        message == other.message;
  }

  @override
  int get hashCode => Object.hash(type, data, message);
}

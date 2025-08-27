class ApiResponse<T> {
  const ApiResponse({
    required this.statusCode,
    required this.headers,
    required this.body,
    required this.exception,
    required this.isSuccess,
  });

  final int statusCode;
  final Map<String, String> headers;
  final T body;
  final String exception;
  final bool isSuccess;

  ApiResponse copyWith({
    dynamic body,
    Map<String, String>? headers,
    int? statusCode,
    String? exception,
    bool? isSuccess,
  }) {
    return ApiResponse(
      statusCode: statusCode ?? this.statusCode,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      exception: exception ?? this.exception,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

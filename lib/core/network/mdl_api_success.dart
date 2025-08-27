import 'dart:convert';

class ApiSuccess {
  final int code;
  final String data;

  ApiSuccess({
    required this.code,
    required this.data,
  });

  ApiSuccess copyWith({
    int? code,
    String? data,
    String? message,
  }) =>
      ApiSuccess(
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory ApiSuccess.fromJson(String str) =>
      ApiSuccess.fromMap(json.decode(str));

  factory ApiSuccess.fromMap(Map<String, dynamic> json) => ApiSuccess(
        code: json["code"] ?? 0,
        data: json["data"] ?? '',
      );

  factory ApiSuccess.empty() => ApiSuccess(code: 0, data: '');
}

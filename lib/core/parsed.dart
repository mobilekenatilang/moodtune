class Parsed<T> {
  Parsed.fromJson(
    Map<String, dynamic> json,
    this.statusCode,
    this.data,
  ) {
    message = (json['error'] ?? json['detail'] ?? '') as String;
  }

  Parsed.fromDynamicData(this.statusCode, this.data);

  late int statusCode;
  late String message;
  late T data;
}
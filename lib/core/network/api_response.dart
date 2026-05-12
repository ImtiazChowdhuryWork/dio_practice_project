class ApiResponse {
  final bool success;
  final dynamic data;
  final String? error;

  const ApiResponse({required this.success, this.data, this.error});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] as bool? ?? false,
      data: json['data'],
      error: json['error'] as String?,
    );
  }
}

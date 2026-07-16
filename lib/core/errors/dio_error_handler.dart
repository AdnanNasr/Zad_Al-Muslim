import 'package:dio/dio.dart';

sealed class DioErrorHandler {
  final String message;
  DioErrorHandler(this.message);

  factory DioErrorHandler.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ConnectionTimeout();

      case DioExceptionType.sendTimeout:
        return SendTimeout();

      case DioExceptionType.receiveTimeout:
        return ReceiveTimeout();

      case DioExceptionType.badCertificate:
        return BadCertificate();

      case DioExceptionType.badResponse:
        return BadResponse.fromResponse(dioException.response);

      case DioExceptionType.cancel:
        return RequestCancelled();

      case DioExceptionType.connectionError:
        return ConnectionError();

      case DioExceptionType.unknown:
        return UnknownError();
      case DioExceptionType.transformTimeout:
        return DioErrorHandler.fromDioException(dioException);
    }
  }
}

class ConnectionTimeout extends DioErrorHandler {
  ConnectionTimeout() : super("انتهت مهلة الاتصال بالخادم.");
}

class SendTimeout extends DioErrorHandler {
  SendTimeout() : super("فشل إرسال البيانات (مهلة زمنية).");
}

class ReceiveTimeout extends DioErrorHandler {
  ReceiveTimeout() : super("فشل استلام البيانات من الخادم.");
}

class BadCertificate extends DioErrorHandler {
  BadCertificate() : super("خطأ في شهادة الأمان.");
}

class ConnectionError extends DioErrorHandler {
  ConnectionError() : super("لا يوجد اتصال بالإنترنت.");
}

class RequestCancelled extends DioErrorHandler {
  RequestCancelled() : super("تم إلغاء الطلب.");
}

class UnknownError extends DioErrorHandler {
  UnknownError() : super("حدث خطأ غير متوقع، يرجى المحاولة لاحقاً.");
}

class BadResponse extends DioErrorHandler {
  final int? statusCode;
  BadResponse(this.statusCode, String message) : super(message);

  factory BadResponse.fromResponse(Response? response) {
    int? statusCode = response?.statusCode;
    String msg = "حدث خطأ في الخادم (Code: $statusCode)";
    if (statusCode == 400) msg = "بيانات الطلب غير صحيحة.";
    if (statusCode == 401) msg = "غير مصرح لك بالوصول (يجب تسجيل الدخول).";
    if (statusCode == 403) msg = "لا تملك صلاحية للوصول لهذا المورد.";
    if (statusCode == 404) msg = "المورد المطلوب غير موجود.";
    if (statusCode == 500) msg = "خطأ داخلي في الخادم.";

    return BadResponse(statusCode, msg);
  }
}

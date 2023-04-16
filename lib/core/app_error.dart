import '../utils/app_localizations.dart';

enum AppErrorType {
  http,
  unexpected,
}

enum AppErrorDescription {
  serverParsingFailed,
  noConnection,
  unexpectedError,
}

extension AppErrorDescriptionStrings on AppErrorDescription {
  String get stringValue {
    switch (this) {
      case AppErrorDescription.serverParsingFailed:
        return "There was a problem understanding the server's response"
            .localized;
      case AppErrorDescription.noConnection:
        return 'Please check your internet connection then try again'.localized;
      case AppErrorDescription.unexpectedError:
        return 'An unexpected error ocured'.localized;
    }
  }
}

class AppError {
  AppError({
    this.data,
    this.type = AppErrorType.unexpected,
    final int? code,
  }) : code = code ?? 0;

  dynamic data;
  AppErrorType type;
  int code;

  String get message {
    if (data is String) {
      return data;
    }
    if (data is Map) {
      return data['error'] as String? ??
          AppErrorDescription.unexpectedError.stringValue;
    }
    if (data is AppErrorDescription) {
      return (data as AppErrorDescription).stringValue;
    }
    return AppErrorDescription.unexpectedError.stringValue;
  }
}

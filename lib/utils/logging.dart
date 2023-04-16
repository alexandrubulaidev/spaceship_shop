import 'package:logger/logger.dart' as log;

class Logs {
  static final _logger = log.Logger();

  /// Log a message at level verbose.
  static void verbose(
    final dynamic message, [
    final dynamic error,
    final StackTrace? stackTrace,
  ]) {
    _logger.v(message, error, stackTrace);
  }

  /// Log a message at level debug.
  static void debug(
    final dynamic message, [
    final dynamic error,
    final StackTrace? stackTrace,
  ]) {
    _logger.d(message, error, stackTrace);
  }

  /// Log a message at level info.
  static void info(
    final dynamic message, [
    final dynamic error,
    final StackTrace? stackTrace,
  ]) {
    _logger.i(message, error, stackTrace);
  }

  /// Log a message at level warning.
  static void warning(
    final dynamic message, [
    final dynamic error,
    final StackTrace? stackTrace,
  ]) {
    _logger.w(message, error, stackTrace);
  }

  /// Log a message at level error.
  static void error(
    final dynamic message, [
    final dynamic error,
    final StackTrace? stackTrace,
  ]) {
    _logger.e(message, error, stackTrace);
  }

  /// Log a message at level wtf.
  static void wtf(
    final dynamic message, [
    final dynamic error,
    final StackTrace? stackTrace,
  ]) {
    _logger.wtf(message, error, stackTrace);
  }
}

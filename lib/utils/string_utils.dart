import 'package:sprintf/sprintf.dart';

class StringUtils {
  static String formatted(final String key, final dynamic args) {
    return sprintf(key, args);
  }
}

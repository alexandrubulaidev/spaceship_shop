/// A lightweight service locator class.
/// Inspired by get_it with the addition of tag
class Services {
  static final _services = <String, Object>{};

  /// Registers a service or returns the already registered service.
  /// Multiple instances of the same services can be achived by supplying a unique [tag] for each.
  /// When [overwrite] is true it will replace the existing service (if any).
  static T register<T extends Object>(
    final Object object, {
    final Type? type,
    final String? tag,
    final bool overwrite = false,
  }) {
    final key = _getKey<T>(tag);
    final exists = _services.containsKey(key);
    if (overwrite || !exists) {
      _services[key] = object;
    }
    return object as T;
  }

  /// Get service by type and [tag].
  /// Note that supplying [tag] will look for a service of type [T] with that specific [tag] !!
  static T get<T>([final String? tag]) {
    final key = _getKey<T>(tag);
    if (_services.containsKey(key)) {
      return _services[key] as T;
    }
    throw ServiceNotFoundException('singletion:$key');
  }

  static T? tryGet<T>([final String? key]) {
    try {
      return get<T>(key);
    } on ServiceNotFoundException catch (_) {}

    return null;
  }

  static List<T> getAll<T>() {
    final list = <T>[];
    final queryKey = T.toString();
    for (var i = 0; i < _services.values.length; i++) {
      final value = _services.values.toList()[i];
      final key = _services.keys.toList()[i];
      if (value.runtimeType == T && key.contains(queryKey)) {
        list.add(value as T);
      }
    }

    return list;
  }

  static String _getKey<T>([final String? tag]) {
    final typeKey = T.toString();
    final tagKey = tag != null ? '#$tag' : '';

    return '$typeKey$tagKey';
  }

  static void unregister<T>([final String? tag]) {
    final key = _getKey<T>(tag);
    final service = _services[key];
    if (service is BaseService) {
      service.onDispose();
    }
    _services.remove(key);
  }
}

class ServiceNotFoundException implements Exception {
  ServiceNotFoundException(this.message);
  final String message;
}

class ServiceInvalidException implements Exception {
  ServiceInvalidException(this.message);
  final String message;
}

abstract class BaseService {
  void onDispose() {}
}

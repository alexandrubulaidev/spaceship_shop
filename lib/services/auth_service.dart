import '../core/services.dart';
import '../data/network/mocks.dart';
import '../data/repositories/spaceship_repository.dart';
import '../model/spaceship.dart';

class AuthService {
  Spaceship? _spaceship;

  int? get spaceshipId {
    return kSpaceshipId;
  }

  Future<Spaceship?> get spaceship async {
    final id = spaceshipId;
    if (id == null) {
      return null;
    }
    if (_spaceship?.id == id) {
      return _spaceship;
    }
    final result = await Services.get<SpaceshipRepository>().getSpaceship(
      spaceshipId: id,
    );
    return result.when((final success) {
      _spaceship = success;
      return success;
    }, (final error) {
      return null;
    });
  }
}

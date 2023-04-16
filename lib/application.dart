import 'core/services.dart';
import 'data/database/database.dart';
import 'data/repositories/spaceship_repository.dart';
import 'data/repositories/spaceship_repository_impl.dart';
import 'services/auth_service.dart';
import 'services/shopping_service.dart';

/// Initialize base components and 3rd party libs
class Application {
  static Future<void> init() async {
    Services.register<Database>(await Database.create());
    Services.register<AuthService>(AuthService());
    Services.register<SpaceshipRepository>(SpaceshipRepositoryImpl());
    Services.register<ShoppingService>(ShoppingService());

    // initialize components
    // await Get.find<GameStateService>().init();
  }
}

import 'package:multiple_result/multiple_result.dart';

import '../../core/app_error.dart';
import '../../model/spaceship.dart';
import '../../model/spaceship_component.dart';
import '../../model/spaceship_shop_component.dart';
import '../../model/spaceship_station.dart';

abstract class SpaceshipRepository {
  Future<Result<Spaceship, AppError>> getSpaceship({
    required final int spaceshipId,
  });

  Future<Result<List<SpaceshipComponent>, AppError>> getSpaceshipComponents({
    required final int spaceshipId,
  });

  Future<AppError?> save({
    required final Spaceship spaceship,
  });

  Future<AppError?> addComponent({
    required final int spaceshipId,
    required final SpaceshipComponent component,
  });

  Future<Result<List<SpaceshipShopComponent>, AppError>>
      getAvailableShopComponents();

  Future<Result<List<SpaceshipStation>, AppError>> getServiceStations();
}

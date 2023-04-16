// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:multiple_result/multiple_result.dart';

import '../../core/app_error.dart';
import '../../core/services.dart';
import '../../model/spaceship.dart';
import '../../model/spaceship_component.dart';
import '../../model/spaceship_shop_component.dart';
import '../../model/spaceship_station.dart';
import '../database/database.dart';
import '../network/galactic_api.dart';
import 'spaceship_repository.dart';

class SpaceshipRepositoryImpl implements SpaceshipRepository {
  final _spaceshipApi = GalacticApi.mock();
  Database get _db => Services.get<Database>();

  @override
  Future<AppError?> addComponent({
    required final int spaceshipId,
    required final SpaceshipComponent component,
  }) {
    // TODO: implement addComponent
    throw UnimplementedError();
  }

  @override
  Future<Result<Spaceship, AppError>> getSpaceship({
    required final int spaceshipId,
  }) async {
    final spaceship = await _db.getSpaceship(id: spaceshipId);
    if (spaceship != null) {
      return Result.success(spaceship);
    }
    final result = await _spaceshipApi.getSpaceship(
      id: spaceshipId,
    );
    return result.when((final success) {
      try {
        final spaceship = Spaceship.fromMap(success);
        _db.save(spaceship);
        return Result.success(spaceship);
      } catch (e) {
        return Result.error(
          AppError(
            data: AppErrorDescription.serverParsingFailed,
          ),
        );
      }
    }, (final error) {
      return Result.error(error);
    });
  }

  @override
  Future<Result<List<SpaceshipComponent>, AppError>> getSpaceshipComponents({
    required final int spaceshipId,
  }) async {
    final components = await _db.getSpaceshipComponents(
      spaceshipId: spaceshipId,
    );
    if (components.isNotEmpty) {
      return Result.success(components);
    }
    final result = await _spaceshipApi.getSpaceshipComponents(
      spaceshipId: spaceshipId,
    );
    return result.when((final success) {
      try {
        final components = success
            .map((final map) {
              try {
                return SpaceshipComponent.fromMap(map);
              } catch (e) {
                return null;
              }
            })
            .where((final element) => element != null)
            .toList()
            .cast<SpaceshipComponent>();
        components.forEach((final element) {
          _db.save(element);
        });
        return Result.success(components);
      } catch (e) {
        return Result.error(
          AppError(
            data: AppErrorDescription.serverParsingFailed,
          ),
        );
      }
    }, (final error) {
      return Result.error(error);
    });
  }

  @override
  Future<AppError?> save({
    required final Spaceship spaceship,
  }) {
    // TODO: implement save
    throw UnimplementedError();
  }

  @override
  Future<Result<List<SpaceshipShopComponent>, AppError>>
      getAvailableShopComponents() async {
    return Result.success([
      SpaceshipShopComponent(
        id: 1,
        type: 'communication',
        manufacturer: 'Boeing',
        model: 'quantum-communication-device',
        year: 2060,
        price: 5000,
      ),
      SpaceshipShopComponent(
        id: 2,
        type: 'navigation',
        manufacturer: 'Northrop Grumman',
        model: 'star-mapping-system-2',
        year: 2062,
        price: 4000,
      ),
      SpaceshipShopComponent(
        id: 3,
        type: 'weapon',
        manufacturer: 'Lockheed Martin',
        model: 'particle-beam-cannon',
        year: 2063,
        price: 7000,
      ),
      SpaceshipShopComponent(
        id: 4,
        type: 'engine',
        manufacturer: 'Rolls-Royce',
        model: 'nova-2',
        year: 2064,
        price: 300000,
      ),
      SpaceshipShopComponent(
        id: 5,
        type: 'communication',
        manufacturer: 'Samsung',
        model: 'galaxy-net',
        year: 2066,
        price: 15000,
      ),
      SpaceshipShopComponent(
        id: 6,
        type: 'shield',
        manufacturer: 'Boeing',
        model: 'dome-shield',
        year: 2067,
        price: 5000,
      ),
      SpaceshipShopComponent(
        id: 7,
        type: 'weapon',
        manufacturer: 'SpaceX',
        model: 'star-destroyer-cannon',
        year: 2068,
        price: 8000,
      ),
      SpaceshipShopComponent(
        id: 8,
        type: 'navigation',
        manufacturer: 'Thales Group',
        model: 'astro-navigation-system',
        year: 2070,
        price: 6000,
      ),
      SpaceshipShopComponent(
        id: 9,
        type: 'engine',
        manufacturer: 'General Electric',
        model: 'fission-propulsion',
        year: 2072,
        price: 250000,
      ),
      SpaceshipShopComponent(
        id: 10,
        type: 'shield',
        manufacturer: 'Lockheed Martin',
        model: 'aegis-shield',
        year: 2075,
        price: 7000,
      ),
    ]);
  }

  @override
  Future<Result<List<SpaceshipStation>, AppError>> getServiceStations() async {
    return Result.success([
      SpaceshipStation(
        id: 1,
        address: 'Proxima Centauri b',
        name: 'Starship Repair Co.',
        picture:
            'https://scitechdaily.com/images/International-Space-Station-Flying-Orbital-Sunset-scaled.jpg',
        price: 8000,
        rating: 4.8,
        serviceDuration: 75,
      ),
      SpaceshipStation(
        id: 2,
        address: 'Andromeda Galaxy, Sector 12',
        name: 'Cosmic Fuel & Supply',
        picture:
            'https://wallup.net/wp-content/uploads/2016/01/99936-spaceship-space_station-science_fiction.jpg',
        price: 6000,
        rating: 3.2,
        serviceDuration: 40,
      ),
      SpaceshipStation(
        id: 3,
        address: 'Mars Orbit, Station 7',
        name: 'Red Planet Repairs',
        price: 4000,
        picture:
            'https://cdnb.artstation.com/p/assets/images/images/013/412/127/large/mitchell-stuart-ftl-dock3.jpg',
        rating: 4.2,
        serviceDuration: 60,
      ),
      SpaceshipStation(
        id: 4,
        address: 'Sirius A, Planet 3',
        name: 'Galactic Gear & Gadgets',
        price: 7000,
        rating: 3.9,
        serviceDuration: 45,
      ),
      SpaceshipStation(
        id: 5,
        address: 'Vega, Planet 9',
        name: 'Universal Upgrades Inc.',
        price: 9000,
        rating: 4.6,
        serviceDuration: 90,
      ),
      SpaceshipStation(
        id: 6,
        address: 'Alpha Centauri A, Planet 2',
        name: 'Solar Sail Services',
        price: 5500,
        rating: 3.5,
        serviceDuration: 35,
      ),
      SpaceshipStation(
        id: 7,
        address: 'Saturn Rings, Station 14',
        name: 'Saturn Supplies Co.',
        price: 3500,
        rating: 2.9,
        serviceDuration: 30,
      ),
      SpaceshipStation(
        id: 8,
        address: 'Jupiter, Moon 6-12',
        name: 'Jupiter Jumpstart',
        price: 4500,
        rating: 4,
        serviceDuration: 55,
      ),
      SpaceshipStation(
        id: 9,
        address: 'Uranus, Planet 7',
        name: 'Uranus Upgrades & Repairs',
        price: 6500,
        rating: 4.3,
        serviceDuration: 70,
      ),
      SpaceshipStation(
        id: 10,
        address: 'Orion Nebula, Station 21',
        name: 'Orion Outfitters',
        price: 7500,
        rating: 4.7,
        serviceDuration: 80,
      ),
      SpaceshipStation(
        id: 11,
        address: 'Neptune x35',
        name: 'Jack & Tools CO',
        price: 5000,
        rating: 4.5,
        serviceDuration: 50,
      ),
      SpaceshipStation(
        id: 12,
        address: 'Terra, Moon 25-24',
        name: 'Europe International',
        price: 3000,
        rating: 2.5,
        serviceDuration: 25,
      ),
    ]);
  }
}

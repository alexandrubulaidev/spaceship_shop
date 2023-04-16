import 'package:multiple_result/multiple_result.dart';

import '../../core/app_error.dart';
import 'galactic_api_mock.dart';

abstract class GalacticApi {
  factory GalacticApi.mock() {
    return GalacticApiMock();
  }

  Future<Result<Map<String, dynamic>, AppError>> getSpaceship({
    required final int id,
  });

  Future<Result<List<Map<String, dynamic>>, AppError>> getSpaceshipComponents({
    required final int spaceshipId,
  });
}

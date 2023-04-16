import 'package:multiple_result/multiple_result.dart';

import '../../core/app_error.dart';
import 'galactic_api.dart';
import 'mocks.dart';

// API example
class GalacticApiMock implements GalacticApi {
  @override
  Future<Result<Map<String, dynamic>, AppError>> getSpaceship({
    required final int id,
  }) async {
    return Result.success(kSpaceship);
  }

  @override
  Future<Result<List<Map<String, dynamic>>, AppError>> getSpaceshipComponents({
    required final int spaceshipId,
  }) async {
    return Result.success(kSpaceshipComponents);
  }
}

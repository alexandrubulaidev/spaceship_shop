// SAMPLE - NOT USED 

// class GalacticApiImpl extends BaseApi implements GalacticApi {
//   GalacticApiImpl() : super(baseUrl: 'https://someapi.com/');

//   @override
//   Future<Result<Map<String, dynamic>, AppError>> getSpaceship({
//     required final int id,
//   }) async {
//     final response = await request(
//       method: ApiMethod.get,
//       path: id,
//       headers: {
//         'Authorization': 'Bearer / Basic / Token etc',
//       },
//     );
//     return response.when(
//       (final success) {
//         try {
//           // parse result, etc
//           return Result.success(success);
//         } catch (_) {
//           return Result.error(
//             AppError.httpError(
//               data: AppErrorDescription.serverParsingFailed,
//             ),
//           );
//         }
//       },
//       (final error) {
//         return Result.error(error);
//       },
//     );
//   }
// }

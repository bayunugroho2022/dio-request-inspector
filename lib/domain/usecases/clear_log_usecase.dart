import 'package:dio_request_inspector/common/failure.dart';
import 'package:dio_request_inspector/data/models/http_activity.dart';
import 'package:dio_request_inspector/domain/repositories/dio_request_repository.dart';
import 'package:dartz/dartz.dart';

class ClearLogUseCase {
  final DioRequestRepository? repository;

  ClearLogUseCase(this.repository);

  Future<Either<Failure, Stream<List<HttpActivity>>>> execute() {
    return repository!.clearAllLog();
  }
}

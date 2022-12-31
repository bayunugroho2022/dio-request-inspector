import 'package:dio_request_inspector/common/failure.dart';
import 'package:dio_request_inspector/domain/repositories/dio_request_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class SaveResponseUseCase {
  final DioRequestRepository? repository;

  SaveResponseUseCase(this.repository);

  Future<Either<Failure, String>> execute(Response response) {
    return repository!.saveResponse(response);
  }
}
